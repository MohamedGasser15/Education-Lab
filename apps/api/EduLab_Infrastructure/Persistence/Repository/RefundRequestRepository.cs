using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for refund request data operations
    /// </summary>
    public class RefundRequestRepository : IRefundRequestRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<RefundRequestRepository> _logger;

        /// <summary>
        /// Initializes a new instance of the RefundRequestRepository class
        /// </summary>
        /// <param name="context">The database context</param>
        /// <param name="logger">The logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when context or logger is null</exception>
        public RefundRequestRepository(ApplicationDbContext context, ILogger<RefundRequestRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Creates a new refund request
        /// </summary>
        /// <param name="request">Refund request entity</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created refund request entity</returns>
        public async Task<RefundRequest> CreateAsync(RefundRequest request, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating refund request for payment {PaymentId}", request.PaymentId);

            try
            {
                _logger.LogInformation("Creating refund request for payment ID: {PaymentId}", request.PaymentId);

                _context.RefundRequests.Add(request);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created refund request with ID: {RequestId}", request.Id);
                return request;
            }
            catch (DbUpdateException dbEx)
            {
                _logger.LogError(dbEx, "Database error creating refund request for payment ID: {PaymentId}", request.PaymentId);
                throw new ApplicationException("Database error occurred while creating refund request", dbEx);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error creating refund request");
                throw;
            }
        }

        /// <summary>
        /// Retrieves a refund request by its identifier
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Refund request entity or null</returns>
        public async Task<RefundRequest> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving refund request with ID: {RequestId}", id);

                return await _context.RefundRequests
                    .AsNoTracking()
                    .Include(r => r.Payment)
                        .ThenInclude(p => p.Course)
                    .Include(r => r.User)
                    .FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving refund request with ID: {RequestId}", id);
                throw;
            }
        }

        /// <summary>
        /// Retrieves all refund requests with related data
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Collection of refund requests</returns>
        public async Task<IEnumerable<RefundRequest>> GetAllAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving all refund requests");

                return await _context.RefundRequests
                    .AsNoTracking()
                    .Include(r => r.Payment)
                        .ThenInclude(p => p.Course)
                    .Include(r => r.User)
                    .OrderByDescending(r => r.CreatedAt)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving all refund requests");
                throw;
            }
        }

        /// <summary>
        /// Retrieves the latest refund request for a payment
        /// </summary>
        /// <param name="paymentId">Payment identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Refund request entity or null</returns>
        public async Task<RefundRequest> GetByPaymentIdAsync(int paymentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving refund request for payment ID: {PaymentId}", paymentId);

                return await _context.RefundRequests
                    .AsNoTracking()
                    .Where(r => r.PaymentId == paymentId)
                    .OrderByDescending(r => r.CreatedAt)
                    .FirstOrDefaultAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving refund request for payment ID: {PaymentId}", paymentId);
                throw;
            }
        }

        /// <summary>
        /// Updates an existing refund request
        /// </summary>
        /// <param name="request">Refund request entity with updated values</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if successful, false otherwise</returns>
        public async Task<bool> UpdateAsync(RefundRequest request, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Updating refund request {RequestId}", request.Id);

            try
            {
                _logger.LogInformation("Updating refund request with ID: {RequestId} to status {Status}", request.Id, request.Status);

                var existing = await _context.RefundRequests
                    .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

                if (existing != null)
                {
                    existing.Status = request.Status;
                    existing.ProcessedAt = request.ProcessedAt;
                    existing.ProcessedBy = request.ProcessedBy;
                    existing.RejectionReason = request.RejectionReason;
                    existing.StripeRefundId = request.StripeRefundId;
                    await _context.SaveChangesAsync(cancellationToken);

                    _logger.LogInformation("Successfully updated refund request with ID: {RequestId}", request.Id);
                    return true;
                }

                _logger.LogWarning("Refund request not found with ID: {RequestId}", request.Id);
                return false;
            }
            catch (DbUpdateException dbEx)
            {
                _logger.LogError(dbEx, "Database error updating refund request ID: {RequestId}", request.Id);
                throw new ApplicationException("Database error occurred while updating refund request", dbEx);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error updating refund request");
                throw;
            }
        }
    }
}
