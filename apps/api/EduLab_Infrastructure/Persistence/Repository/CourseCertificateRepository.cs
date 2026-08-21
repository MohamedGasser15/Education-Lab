using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for course certificate operations
    /// </summary>
    public class CourseCertificateRepository : ICourseCertificateRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CourseCertificateRepository> _logger;

        /// <summary>
        /// Initializes a new instance of the CourseCertificateRepository class
        /// </summary>
        /// <param name="context">Application database context</param>
        /// <param name="logger">Logger instance</param>
        public CourseCertificateRepository(ApplicationDbContext context, ILogger<CourseCertificateRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Creates a new course certificate
        /// </summary>
        /// <param name="certificate">The certificate to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created certificate</returns>
        public async Task<CourseCertificate> CreateAsync(CourseCertificate certificate, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Creating certificate for enrollment ID: {EnrollmentId}", certificate.EnrollmentId);

            _context.CourseCertificates.Add(certificate);
            await _context.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Successfully created certificate with ID: {CertificateId}", certificate.Id);
            return certificate;
        }

        /// <summary>
        /// Gets the certificate for a given enrollment including related course and user data
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The certificate, or null if none exists</returns>
        public async Task<CourseCertificate> GetByEnrollmentIdAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            return await _context.CourseCertificates
                .AsNoTracking()
                .Include(cc => cc.Enrollment)
                    .ThenInclude(e => e.Course)
                .Include(cc => cc.Enrollment)
                    .ThenInclude(e => e.User)
                .FirstOrDefaultAsync(cc => cc.EnrollmentId == enrollmentId, cancellationToken);
        }

        /// <summary>
        /// Gets the certificate by its unique certificate code
        /// </summary>
        /// <param name="code">The certificate code</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The certificate, or null if none matches</returns>
        public async Task<CourseCertificate> GetByCodeAsync(string code, CancellationToken cancellationToken = default)
        {
            return await _context.CourseCertificates
                .AsNoTracking()
                .Include(cc => cc.Enrollment)
                    .ThenInclude(e => e.Course)
                .Include(cc => cc.Enrollment)
                    .ThenInclude(e => e.User)
                .FirstOrDefaultAsync(cc => cc.CertificateCode == code, cancellationToken);
        }

        /// <summary>
        /// Gets all certificates issued to a user, ordered by issue date descending
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of the user's certificates</returns>
        public async Task<List<CourseCertificate>> GetByUserIdAsync(string userId, CancellationToken cancellationToken = default)
        {
            return await _context.CourseCertificates
                .AsNoTracking()
                .Include(cc => cc.Enrollment)
                    .ThenInclude(e => e.Course)
                .Include(cc => cc.Enrollment)
                    .ThenInclude(e => e.User)
                .Where(cc => cc.Enrollment.UserId == userId)
                .OrderByDescending(cc => cc.IssuedDate)
                .ToListAsync(cancellationToken);
        }
    }
}
