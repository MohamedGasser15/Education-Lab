using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class CourseCertificateRepository : ICourseCertificateRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CourseCertificateRepository> _logger;

        public CourseCertificateRepository(ApplicationDbContext context, ILogger<CourseCertificateRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<CourseCertificate> CreateAsync(CourseCertificate certificate, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Creating certificate for enrollment ID: {EnrollmentId}", certificate.EnrollmentId);

            _context.CourseCertificates.Add(certificate);
            await _context.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Successfully created certificate with ID: {CertificateId}", certificate.Id);
            return certificate;
        }

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
