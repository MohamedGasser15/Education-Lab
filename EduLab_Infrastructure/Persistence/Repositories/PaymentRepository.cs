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
    public class PaymentRepository : IPaymentRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<PaymentRepository> _logger;

        public PaymentRepository(ApplicationDbContext context, ILogger<PaymentRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<Payment> CreatePaymentAsync(Payment payment, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating new payment for user ID: {UserId}", payment.UserId);

                _context.Payments.Add(payment);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created payment with ID: {PaymentId}", payment.Id);
                return payment;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating payment for user ID: {UserId}", payment.UserId);
                throw;
            }
        }

        public async Task<Payment> GetPaymentByIdAsync(int paymentId, CancellationToken cancellationToken = default)
        {
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

        public async Task<bool> UpdatePaymentStatusAsync(int paymentId, string status, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating payment status for payment ID: {PaymentId} to {Status}", paymentId, status);

                var payment = await _context.Payments.FindAsync(new object[] { paymentId }, cancellationToken);
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
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating payment status for payment ID: {PaymentId}", paymentId);
                throw;
            }
        }

        public async Task<IEnumerable<Payment>> GetUserPaymentsAsync(string userId, CancellationToken cancellationToken = default)
        {
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
    }
}