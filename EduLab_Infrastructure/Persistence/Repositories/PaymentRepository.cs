// EduLab_Infrastructure/Persistence/Repositories/PaymentRepository.cs
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for payment-related data operations
    /// </summary>
    public class PaymentRepository : IPaymentRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<PaymentRepository> _logger;

        /// <summary>
        /// Initializes a new instance of the PaymentRepository class
        /// </summary>
        /// <param name="context">The database context</param>
        /// <param name="logger">The logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when context or logger is null</exception>
        public PaymentRepository(ApplicationDbContext context, ILogger<PaymentRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region CRUD Operations

        /// <summary>
        /// Creates a new payment record in the database
        /// </summary>
        /// <param name="payment">The payment entity to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created payment entity</returns>
        public async Task<Payment> CreatePaymentAsync(Payment payment, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating payment for user {UserId}", payment.UserId);

            try
            {
                _logger.LogInformation("Creating new payment for user ID: {UserId}", payment.UserId);

                _context.Payments.Add(payment);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created payment with ID: {PaymentId}", payment.Id);
                return payment;
            }
            catch (DbUpdateException dbEx)
            {
                _logger.LogError(dbEx, "Database error creating payment for user ID: {UserId}", payment.UserId);
                throw new ApplicationException("Database error occurred while creating payment", dbEx);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error creating payment for user ID: {UserId}", payment.UserId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a payment by its unique identifier
        /// </summary>
        /// <param name="paymentId">The payment identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The payment entity or null if not found</returns>
        public async Task<Payment> GetPaymentByIdAsync(int paymentId, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Retrieving payment {PaymentId}", paymentId);

            try
            {
                _logger.LogInformation("Retrieving payment with ID: {PaymentId}", paymentId);

                return await _context.Payments
                    .AsNoTracking()
                    .Include(p => p.User)
                    .Include(p => p.Course)
                    .FirstOrDefaultAsync(p => p.Id == paymentId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving payment with ID: {PaymentId}", paymentId);
                throw;
            }
        }

        /// <summary>
        /// Updates the status of a payment
        /// </summary>
        /// <param name="paymentId">The payment identifier</param>
        /// <param name="status">The new status value</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if update was successful, false otherwise</returns>
        public async Task<bool> UpdatePaymentStatusAsync(int paymentId, string status, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Updating payment status for {PaymentId}", paymentId);

            try
            {
                _logger.LogInformation("Updating payment status for payment ID: {PaymentId} to {Status}", paymentId, status);

                var payment = await _context.Payments
                    .FirstOrDefaultAsync(p => p.Id == paymentId, cancellationToken);

                if (payment != null)
                {
                    payment.Status = status;
                    payment.PaidAt = DateTime.UtcNow;
                    await _context.SaveChangesAsync(cancellationToken);

                    _logger.LogInformation("Successfully updated payment status for payment ID: {PaymentId}", paymentId);
                    return true;
                }

                _logger.LogWarning("Payment not found with ID: {PaymentId}", paymentId);
                return false;
            }
            catch (DbUpdateException dbEx)
            {
                _logger.LogError(dbEx, "Database error updating payment status for ID: {PaymentId}", paymentId);
                throw new ApplicationException("Database error occurred while updating payment status", dbEx);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error updating payment status for ID: {PaymentId}", paymentId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves all payments for a specific user
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Collection of user payments</returns>
        public async Task<IEnumerable<Payment>> GetUserPaymentsAsync(string userId, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Retrieving payments for user {UserId}", userId);

            try
            {
                _logger.LogInformation("Retrieving payments for user ID: {UserId}", userId);

                return await _context.Payments
                    .AsNoTracking()
                    .Include(p => p.Course)
                    .Where(p => p.UserId == userId)
                    .OrderByDescending(p => p.PaidAt)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving payments for user ID: {UserId}", userId);
                throw;
            }
        }

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Creates multiple payment records in a single transaction
        /// </summary>
        /// <param name="payments">Collection of payments to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Number of created payments</returns>
        public async Task<int> CreateBulkPaymentsAsync(IEnumerable<Payment> payments, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating bulk payments");

            try
            {
                _logger.LogInformation("Creating {Count} payments in bulk", payments.Count());

                await _context.Payments.AddRangeAsync(payments, cancellationToken);
                var result = await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created {Count} payments in bulk", result);
                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating bulk payments");
                throw;
            }
        }

        #endregion
    }
}