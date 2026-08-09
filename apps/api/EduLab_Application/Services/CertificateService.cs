using EduLab_Application.Common;
using EduLab_Application.DTOs.Certificates;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.Resources;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Localization;
using Microsoft.Extensions.Logging;
using QRCoder;
using SkiaSharp;
using Svg.Skia;
using Svg.Skia.TypefaceProviders;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Security;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class CertificateService : ICertificateService
    {
        private readonly ICourseCertificateRepository _certificateRepository;
        private readonly IEnrollmentRepository _enrollmentRepository;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly IEmailSender _emailSender;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly INotificationService _notificationService;
        private readonly ILinkBuilderService _linkBuilderService;
        private readonly IStringLocalizer<SharedResources> _localizer;
        private readonly ILogger<CertificateService> _logger;

        private const int CanvasWidth = 1414;
        private const int CanvasHeight = 1000;

        public CertificateService(
            ICourseCertificateRepository certificateRepository,
            IEnrollmentRepository enrollmentRepository,
            UserManager<ApplicationUser> userManager,
            IWebHostEnvironment webHostEnvironment,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            INotificationService notificationService,
            ILinkBuilderService linkBuilderService,
            IStringLocalizer<SharedResources> localizer,
            ILogger<CertificateService> logger)
        {
            _certificateRepository = certificateRepository;
            _enrollmentRepository = enrollmentRepository;
            _userManager = userManager;
            _webHostEnvironment = webHostEnvironment;
            _emailSender = emailSender;
            _emailTemplateService = emailTemplateService;
            _notificationService = notificationService;
            _linkBuilderService = linkBuilderService;
            _localizer = localizer;
            _logger = logger;
        }

        public async Task<CertificateDto> GetByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            var certificate = await _certificateRepository.GetByEnrollmentIdAsync(enrollmentId, cancellationToken);
            return certificate == null ? null : MapToDto(certificate);
        }

        public async Task<CertificateDto> GetByCodeAsync(string code, CancellationToken cancellationToken = default)
        {
            var certificate = await _certificateRepository.GetByCodeAsync(code, cancellationToken);
            return certificate == null ? null : MapToDto(certificate);
        }

        public async Task<List<CertificateDto>> GetMyCertificatesAsync(string userId, CancellationToken cancellationToken = default)
        {
            var certificates = await _certificateRepository.GetByUserIdAsync(userId, cancellationToken);
            var result = new List<CertificateDto>();
            foreach (var cert in certificates)
            {
                result.Add(MapToDto(cert));
            }
            return result;
        }

        public string GetCertificateFilePath(string code)
        {
            return Path.Combine(_webHostEnvironment.WebRootPath ?? Directory.GetCurrentDirectory(),
                "uploads", "certificates", $"Certificate_{code}.png");
        }

        /// <summary>
        /// Generates a certificate image when a student completes a course (100% progress).
        /// Idempotent: no-op if a certificate already exists for the enrollment.
        /// </summary>
        public async Task<CertificateDto> GenerateCertificateAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            var existing = await _certificateRepository.GetByEnrollmentIdAsync(enrollmentId, cancellationToken);
            if (existing != null)
            {
                _logger.LogInformation("Certificate already exists for enrollment {EnrollmentId}, skipping generation", enrollmentId);
                return MapToDto(existing);
            }

            var enrollment = await _enrollmentRepository.GetEnrollmentByIdAsync(enrollmentId, cancellationToken);
            if (enrollment?.Course == null)
            {
                _logger.LogWarning("Enrollment {EnrollmentId} or its course not found, certificate not generated", enrollmentId);
                return null;
            }

            var user = enrollment.User ?? await _userManager.FindByIdAsync(enrollment.UserId);
            if (user == null)
            {
                _logger.LogWarning("User not found for enrollment {EnrollmentId}, certificate not generated", enrollmentId);
                return null;
            }

            var code = GenerateCertificateCode();
            var verifyUrl = _linkBuilderService.GenerateCertificateVerifyLink(code);
            var language = user.PreferredLanguage ?? "en";

            try
            {
                var templatePath = Path.Combine(_webHostEnvironment.ContentRootPath, "wwwroot", "templates", "certificate-template.svg");
                var svgContent = File.ReadAllText(templatePath);

                var fileName = $"Certificate_{code}.png";
                var folderPath = Path.Combine(_webHostEnvironment.WebRootPath ?? Directory.GetCurrentDirectory(),
                    "uploads", "certificates");
                Directory.CreateDirectory(folderPath);
                var fullPath = Path.Combine(folderPath, fileName);

                await RenderPngAsync(svgContent, fullPath, user.FullName,
                    enrollment.Course.Title, DateTime.UtcNow, code, verifyUrl, language);

                var certificate = new CourseCertificate
                {
                    EnrollmentId = enrollmentId,
                    CertificateCode = code,
                    PdfPath = $"/uploads/certificates/{fileName}",
                    IssuedDate = DateTime.UtcNow
                };

                var created = await _certificateRepository.CreateAsync(certificate, cancellationToken);

                await NotifyStudentAsync(user, enrollment.Course.Title, code, language);

                _logger.LogInformation("Certificate {Code} generated for enrollment {EnrollmentId}", code, enrollmentId);
                return MapToDto(created);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to generate certificate for enrollment {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        private async Task NotifyStudentAsync(ApplicationUser user, string courseTitle, string certificateCode, string language)
        {
            try
            {
                await _notificationService.CreateNotificationAsync(new CreateNotificationDto
                {
                    Title = "مبروك! حصلت على شهادة إتمام",
                    Message = $"مبروك! لقد أكملت دورة '{courseTitle}' وحصلت على شهادة إتمام.",
                    TitleKey = NotificationMessages.CertificateEarned_Title,
                    MessageKey = NotificationMessages.CertificateEarned_Msg,
                    Parameters = System.Text.Json.JsonSerializer.Serialize(new { courseTitle, certificateCode }),
                    Type = NotificationTypeDto.Course,
                    UserId = user.Id,
                    RelatedEntityId = certificateCode,
                    RelatedEntityType = "Certificate"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to create certificate notification for user {UserId}", user.Id);
            }

            if (!string.IsNullOrEmpty(user.Email))
            {
                try
                {
                    var body = _emailTemplateService.GenerateCertificateEmail(
                        user, courseTitle, certificateCode,
                        _linkBuilderService.GenerateCertificateVerifyLink(certificateCode), language);
                    await _emailSender.SendEmailWithAttachmentAsync(
                        user.Email,
                        _emailTemplateService.GetLocalizedText("EmailCertificateSubject", language),
                        body,
                        GetCertificateFilePath(certificateCode),
                        $"Certificate_{certificateCode}.png");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to send certificate email for user {UserId}", user.Id);
                }
            }
        }

        /// <summary>
        /// Renders the SVG design template to a bitmap, then draws the certificate texts
        /// (HarfBuzz-shaped, RTL-aware) and the QR code on top.
        /// </summary>
        private async Task RenderPngAsync(string svgContent, string pngFullPath, string studentName,
            string courseTitle, DateTime issuedDate, string certificateId, string verifyUrl, string language)
        {
            using var svg = new SKSvg();
            svg.FromSvg(svgContent);

            using var bitmap = svg.Picture.ToBitmap(
                SKColors.White, 1f, 1f,
                SKColorType.Rgba8888, SKAlphaType.Unpremul, SKColorSpace.CreateSrgb());

            var fontsPath = Path.Combine(_webHostEnvironment.ContentRootPath, "wwwroot", "fonts");
            using var canvas = new SKCanvas(bitmap);

            DrawCertificateTexts(canvas, fontsPath, studentName, courseTitle, issuedDate, certificateId, language);

            DrawQrCode(canvas, verifyUrl);

            using var image = SKImage.FromBitmap(bitmap);
            using var data = image.Encode(SKEncodedImageFormat.Png, 100);
            await using (var fs = File.Create(pngFullPath))
            {
                data.SaveTo(fs);
            }
        }

        private void DrawCertificateTexts(SKCanvas canvas, string fontsPath, string studentName,
            string courseTitle, DateTime issuedDate, string certificateId, string language)
        {
            var isArabic = (language ?? "en").StartsWith("ar");
            var culture = isArabic ? new CultureInfo("ar") : new CultureInfo("en");
            var dateText = issuedDate.ToString("dd MMMM yyyy", culture);

            var nameSize = FitNameFont(studentName);
            var courseSize = FitCourseFont(courseTitle);

            var nameHasArabic = studentName?.Any(IsArabicChar) ?? false;
            var courseHasArabic = courseTitle?.Any(IsArabicChar) ?? false;
            var nameFontFamily = nameHasArabic ? "Cairo" : "Inter";
            var courseFontFamily = courseHasArabic ? "Cairo" : "Inter";

            using var paint = new SKPaint { IsAntialias = true, Color = SKColors.White };

            // EL logo
            paint.Color = SKColors.White;
            DrawTextLine(canvas, "EL", 707, 133, CreateFont(fontsPath, "Inter", 700, 32), paint);

            // Small title line (blue, letterspaced)
            paint.Color = SKColor.Parse("#2563eb");
            DrawTextLine(canvas,
                isArabic ? "شهادة إتمام" : "CERTIFICATE OF COMPLETION",
                707, 235,
                CreateFont(fontsPath, isArabic ? "Cairo" : "Inter", 700, isArabic ? 24 : 20),
                paint, letterSpacing: isArabic ? 2 : 4);

            // Main title
            paint.Color = SKColor.Parse("#0a1628");
            DrawTextLine(canvas,
                isArabic ? "شهادة إتمام دورة تدريبية" : "Certificate of Completion",
                707, 280,
                CreateFont(fontsPath, isArabic ? "Cairo" : "Inter", 800, 34), paint);

            // Subtitle
            paint.Color = SKColor.Parse("#64748b");
            DrawTextLine(canvas,
                isArabic ? "تعلن منصة EducationLab التعليمية بأن الطالب/طالبة:" : "EduLab Academy certifies that the student:",
                707, 340,
                CreateFont(fontsPath, "Cairo", 600, 18), paint);

            // Student name
            paint.Color = SKColor.Parse("#0a1628");
            DrawTextLine(canvas, studentName, 707, 425, CreateFont(fontsPath, nameFontFamily, 800, nameSize), paint);

            // Course label
            paint.Color = SKColor.Parse("#64748b");
            DrawTextLine(canvas,
                isArabic ? "قد أتم بنجاح وكفاءة جميع متطلبات الدورة التدريبية:" : "has successfully completed all the requirements of the course:",
                707, 505,
                CreateFont(fontsPath, "Cairo", 600, 18), paint);

            // Course title
            paint.Color = SKColor.Parse("#2563eb");
            DrawTextLine(canvas, courseTitle, 707, 555, CreateFont(fontsPath, courseFontFamily, 700, courseSize), paint);

            // Issue date
            paint.Color = SKColor.Parse("#0a1628");
            DrawTextLine(canvas,
                isArabic ? $"تاريخ الإصدار: {dateText}" : $"Issue Date: {dateText}",
                707, 642,
                CreateFont(fontsPath, "Cairo", 700, 18), paint);

            // Certificate ID
            DrawTextLine(canvas,
                isArabic ? $"رقم الشهادة: {certificateId}" : $"Certificate ID: {certificateId}",
                707, 670,
                CreateFont(fontsPath, "Inter", 700, 16), paint);

            // Left signature block
            DrawSignatureBlock(canvas, fontsPath, paint, 270, isArabic,
                isArabic ? "إدارة المنصة" : "Platform Management",
                "EduLab Management");

            // Right signature block
            DrawSignatureBlock(canvas, fontsPath, paint, 1144, isArabic,
                isArabic ? "المحاضر / المدرب" : "Lead Instructor",
                isArabic ? "Lead Instructor" : "EduLab Academy");
        }

        private static void DrawSignatureBlock(SKCanvas canvas, string fontsPath, SKPaint paint, float centerX,
            bool isArabic, string title, string sub)
        {
            var handTypeface = SKFontManager.Default.MatchFamily("Brush Script MT")
                ?? SKFontManager.Default.MatchFamily("Segoe Script");
            using var hand = handTypeface != null
                ? new CertFont(new SKFont(handTypeface, 30), null)
                : CreateFont(fontsPath, "Cairo", 700, 30);
            paint.Color = SKColor.Parse("#1e3a8a");
            DrawTextLine(canvas, "EduLab", centerX, 755, hand, paint);

            paint.Color = SKColor.Parse("#0a1628");
            DrawTextLine(canvas, title, centerX, 795, CreateFont(fontsPath, "Cairo", 700, 14), paint);

            paint.Color = SKColor.Parse("#94a3b8");
            DrawTextLine(canvas, sub, centerX, 815, CreateFont(fontsPath, "Cairo", 600, 12), paint);
        }

        private static CertFont CreateFont(string fontsPath, string family, int weight, float size)
        {
            var filePath = Path.Combine(fontsPath, CertificateTypefaceProvider.GetFontFileName(family, weight));
            var typeface = CertificateTypefaceProvider.Resolve(family, weight, fontsPath) ?? SKTypeface.Default;
            return new CertFont(new SKFont(typeface, size), filePath);
        }

        private static void DrawQrCode(SKCanvas canvas, string verifyUrl)
        {
            using var qrGenerator = new QRCodeGenerator();
            using var qrData = qrGenerator.CreateQrCode(verifyUrl, QRCodeGenerator.ECCLevel.Q);
            using var qrCode = new QRCode(qrData);
            using var qrBitmap = qrCode.GetGraphic(20);

            byte[] pngBytes;
            using (var ms = new MemoryStream())
            {
                qrBitmap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                pngBytes = ms.ToArray();
            }

            using var skQr = SKBitmap.Decode(pngBytes);
            canvas.DrawBitmap(skQr, new SKRect(653, 726, 761, 834));
        }

        // ---------------- Text rendering (HarfBuzz shaping + RTL) ----------------

        private sealed class CertFont : IDisposable
        {
            public CertFont(SKFont font, string filePath)
            {
                Font = font;
                FilePath = filePath;
            }

            public SKFont Font { get; }
            public string FilePath { get; }
            public void Dispose() => Font?.Dispose();
        }

        private static void DrawTextLine(SKCanvas canvas, string text, float centerX, float baselineY,
            CertFont certFont, SKPaint paint, float letterSpacing = 0)
        {
            var runs = SplitBidiRuns(text);
            var shaped = new List<(string Seg, bool IsArabic, List<(ushort Glyph, SKPoint Pos, float Advance)> Glyphs, float Width)>();

            foreach (var run in runs)
            {
                shaped.Add(ShapeRun(run.Seg, certFont, letterSpacing, run.IsArabic));
            }

            var totalWidth = shaped.Sum(s => s.Width);
            float x = centerX - totalWidth / 2f;

            var isRtlParagraph = shaped.Any(s => s.IsArabic);

            foreach (var s in isRtlParagraph ? shaped.AsEnumerable().Reverse() : shaped.AsEnumerable())
            {
                DrawShapedRun(canvas, s.Glyphs, x, baselineY, certFont.Font, paint);
                x += s.Width;
            }
        }

        private static (string Seg, bool IsArabic)[] SplitBidiRuns(string text)
        {
            var result = new List<(string, bool)>();
            var current = new System.Text.StringBuilder();
            bool? currentArabic = null;

            foreach (var c in text)
            {
                var isArabic = IsArabicChar(c);
                if (currentArabic.HasValue && currentArabic.Value != isArabic)
                {
                    result.Add((current.ToString(), currentArabic.Value));
                    current.Clear();
                }
                current.Append(c);
                currentArabic = isArabic;
            }

            if (current.Length > 0)
                result.Add((current.ToString(), currentArabic ?? false));

            return result.ToArray();
        }

        private static bool IsArabicChar(char c)
        {
            return (c >= 0x0600 && c <= 0x06FF) ||
                   (c >= 0x0750 && c <= 0x077F) ||
                   (c >= 0x08A0 && c <= 0x08FF) ||
                   (c >= 0xFB50 && c <= 0xFDFF) ||
                   (c >= 0xFE70 && c <= 0xFEFF);
        }

        private static readonly System.Collections.Concurrent.ConcurrentDictionary<string, (HarfBuzzSharp.Blob Blob, HarfBuzzSharp.Face Face)> HbFaceCache =
            new();

        private static (string Seg, bool IsArabic, List<(ushort Glyph, SKPoint Pos, float Advance)> Glyphs, float Width)
            ShapeRun(string text, CertFont certFont, float letterSpacing, bool isArabic)
        {
            var glyphs = new List<(ushort, SKPoint, float)>();
            float x = 0;

            if (!string.IsNullOrEmpty(certFont.FilePath) && File.Exists(certFont.FilePath))
            {
                // HarfBuzz shaping (proper Arabic joining + RTL visual order)
                var faceEntry = HbFaceCache.GetOrAdd(certFont.FilePath, p =>
                {
                    var blob = HarfBuzzSharp.Blob.FromFile(p);
                    return (blob, new HarfBuzzSharp.Face(blob, 0));
                });

                using var buffer = new HarfBuzzSharp.Buffer();
                buffer.AddUtf8(text);
                buffer.GuessSegmentProperties();

                using var hbFont = new HarfBuzzSharp.Font(faceEntry.Face);
                hbFont.SetScale((int)(certFont.Font.Size * 64), (int)(certFont.Font.Size * 64));
                hbFont.Shape(buffer);

                var infos = buffer.GlyphInfos;
                var positions = buffer.GlyphPositions;

                for (int i = 0; i < infos.Length; i++)
                {
                    var advancePx = positions[i].XAdvance / 64f;
                    glyphs.Add(((ushort)infos[i].Codepoint,
                        new SKPoint(x + positions[i].XOffset / 64f, positions[i].YOffset / 64f),
                        advancePx));
                    x += advancePx;
                    if (i < infos.Length - 1)
                        x += letterSpacing;
                }
            }
            else
            {
                // Simple shaping fallback (Latin system fonts)
                var glyphIds = certFont.Font.GetGlyphs(text);
                var widths = certFont.Font.GetGlyphWidths(glyphIds);
                for (int i = 0; i < glyphIds.Length; i++)
                {
                    glyphs.Add((glyphIds[i], new SKPoint(x, 0), widths[i]));
                    x += widths[i];
                    if (i < glyphIds.Length - 1)
                        x += letterSpacing;
                }
            }

            return (text, isArabic, glyphs, x);
        }

        private static void DrawShapedRun(SKCanvas canvas, List<(ushort Glyph, SKPoint Pos, float Advance)> glyphs,
            float startX, float baselineY, SKFont font, SKPaint paint)
        {
            using var builder = new SKTextBlobBuilder();
            var run = builder.AllocatePositionedRun(font, glyphs.Count);

            var glyphIds = new ushort[glyphs.Count];
            var positions = new SKPoint[glyphs.Count];
            for (int i = 0; i < glyphs.Count; i++)
            {
                glyphIds[i] = glyphs[i].Glyph;
                positions[i] = glyphs[i].Pos;
            }
            run.SetGlyphs(glyphIds);
            run.SetPositions(positions);

            using var blob = builder.Build();
            canvas.DrawText(blob, startX, baselineY, paint);
        }

        private static int FitNameFont(string name)
        {
            var len = name?.Length ?? 0;
            if (len <= 24) return 46;
            if (len <= 32) return 38;
            return 32;
        }

        private static int FitCourseFont(string title)
        {
            var len = title?.Length ?? 0;
            if (len <= 45) return 28;
            if (len <= 60) return 24;
            return 20;
        }

        private string GenerateCertificateCode()
        {
            return $"EL-{DateTime.UtcNow:yyyyMMdd}-{Guid.NewGuid():N}"[..^16].ToUpperInvariant();
        }

        private CertificateDto MapToDto(CourseCertificate certificate)
        {
            return new CertificateDto
            {
                Id = certificate.Id,
                EnrollmentId = certificate.EnrollmentId,
                CertificateCode = certificate.CertificateCode,
                PdfPath = certificate.PdfPath,
                IssuedDate = certificate.IssuedDate,
                StudentName = certificate.Enrollment?.User?.FullName,
                CourseTitle = certificate.Enrollment?.Course?.Title,
                VerifyUrl = _linkBuilderService.GenerateCertificateVerifyLink(certificate.CertificateCode)
            };
        }
    }
}
