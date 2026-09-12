using EduLab_Application.DTOs.Legal;
using EduLab_Application.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for delivering localized platform information, privacy policy, and terms of service
    /// </summary>
    public class LegalService : ILegalService
    {
        private readonly ILogger<LegalService> _logger;
        private const string AppVersion = "1.0.0";
        private const string ContactEmail = "support@edulab.com";
        private const string WebsiteUrl = "https://edulabapi.runasp.net";

        public LegalService(ILogger<LegalService> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public Task<LegalContentDto> GetAboutInfoAsync(string? language = null, CancellationToken cancellationToken = default)
        {
            var lang = NormalizeLanguage(language);
            return Task.FromResult(lang == "ar" ? GetAboutArabic() : GetAboutEnglish());
        }

        public Task<LegalContentDto> GetPrivacyPolicyAsync(string? language = null, CancellationToken cancellationToken = default)
        {
            var lang = NormalizeLanguage(language);
            return Task.FromResult(lang == "ar" ? GetPrivacyArabic() : GetPrivacyEnglish());
        }

        public Task<LegalContentDto> GetTermsOfServiceAsync(string? language = null, CancellationToken cancellationToken = default)
        {
            var lang = NormalizeLanguage(language);
            return Task.FromResult(lang == "ar" ? GetTermsArabic() : GetTermsEnglish());
        }

        public async Task<Dictionary<string, LegalContentDto>> GetAllLegalInfoAsync(string? language = null, CancellationToken cancellationToken = default)
        {
            var about = await GetAboutInfoAsync(language, cancellationToken);
            var privacy = await GetPrivacyPolicyAsync(language, cancellationToken);
            var terms = await GetTermsOfServiceAsync(language, cancellationToken);

            return new Dictionary<string, LegalContentDto>(StringComparer.OrdinalIgnoreCase)
            {
                { "about", about },
                { "privacy", privacy },
                { "terms", terms }
            };
        }

        private static string NormalizeLanguage(string? language)
        {
            if (string.IsNullOrWhiteSpace(language)) return "en";
            var normalized = language.Trim().ToLower();
            return normalized.StartsWith("ar") ? "ar" : "en";
        }

        #region About Us Content
        private static LegalContentDto GetAboutArabic()
        {
            return new LegalContentDto
            {
                Type = "about",
                Title = "عن منصة EduLab",
                Subtitle = "المنصة التعليمية الرائدة للتعلم الذكي وتطوير المهارات العملية",
                LastUpdated = "سبتمبر 2026",
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new LegalSectionDto
                    {
                        Title = "من نحن",
                        Content = "EduLab هي بيئة تعليمية تفاعلية متكاملة تهدف إلى تمكين الطلاب والمهنيين في العالم العربي وحول العالم من اكتساب مهارات المستقبل بأعلى جودة ممكنة وبأسلوب تعليمي عملي وممتع.",
                        Icon = "info",
                        BulletPoints = new List<string>
                        {
                            "توفير مسارات تعليمية شاملة في البرمجة، التصميم، إدارة الأعمال، والعلوم الحديثة.",
                            "تجسير الفجوة بين التعليم الأكاديمي واحتياجات سوق العمل الحقيقية.",
                            "إتاحة التعلم للجميع في أي وقت ومن أي مكان عبر تطبيقات الموبايل والويب."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "رؤيتنا ورسالتنا",
                        Content = "نؤمن بأن التعليم هو المحرك الأساسي لبناء المستقبل، ولذلك نسعى لإعادة ابتكار تجربة التعلم الرقمي من خلال الجمع بين التكنولوجيا المتطورة والمحتوى المميز والتفاعل المباشر بين الطلاب ونخبة المدربين.",
                        Icon = "rocket",
                        BulletPoints = new List<string>
                        {
                            "الريادة في تقديم تجارب تعليمية ذكية وتفاعلية تتكيف مع وتيرة كل متعلم.",
                            "تمكين المحاضرين والخبراء من مشاركة معرفتهم وتدريب أجيال جديدة من المبدعين.",
                            "الالتزام بأعلى معايير الجودة والمصداقية في المحتوى والشهادات."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "ما الذي يميز منصة EduLab؟",
                        Content = "تم تصميم المنصة لتوفير تجربة تعليمية فائقة السلاسة والقوة تشمل:",
                        Icon = "star",
                        BulletPoints = new List<string>
                        {
                            "محتوى تدريبي عالي الدقة يركز على التطبيق العملي والمشاريع الحقيقية.",
                            "شهادات إتمام رقمية معتمدة ومؤمنة برمز QR للتحقق الفوري من صحتها.",
                            "نظام تفاعلي متكامل للأسئلة والنقاشات المباشرة تحت كل محاضرة.",
                            "تتبع دقيق لتقدمك الدراسي مع تذكيرات ذكية لمواصلة التعلم بانتظام.",
                            "دعم فني وخدمة عملاء على مدار الساعة لمساعدتك في كل خطوة."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "فريق العمل والتواصل",
                        Content = "وراء EduLab فريق شغوف من المطورين والخبراء التعليميين المكرسين لتقديم أفضل تجربة للمستخدمين. إذا كانت لديك أي اقتراحات أو استفسارات، يسعدنا تواصلك معنا دائماً.",
                        Icon = "mail",
                        BulletPoints = new List<string>
                        {
                            $"البريد الإلكتروني للدعم: {ContactEmail}",
                            $"الموقع الرسمي: {WebsiteUrl}",
                            "فريق الدعم الفني متاح للإجابة على مدار 24/7."
                        }
                    }
                }
            };
        }

        private static LegalContentDto GetAboutEnglish()
        {
            return new LegalContentDto
            {
                Type = "about",
                Title = "About EduLab",
                Subtitle = "The premier learning platform for practical skill development and interactive education",
                LastUpdated = "September 2026",
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new LegalSectionDto
                    {
                        Title = "Who We Are",
                        Content = "EduLab is a modern, comprehensive learning ecosystem designed to empower students, creators, and professionals worldwide with cutting-edge skills through engaging and practical courses.",
                        Icon = "info",
                        BulletPoints = new List<string>
                        {
                            "Comprehensive learning tracks spanning technology, programming, design, and business.",
                            "Bridging the gap between theory and practical industry requirements.",
                            "Seamless multi-platform learning across mobile and web at your own pace."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "Our Mission & Vision",
                        Content = "We believe education is the fundamental catalyst for human progress. Our mission is to democratize high-quality education by combining advanced technology, curated curriculum, and real-time collaboration between students and leading instructors.",
                        Icon = "rocket",
                        BulletPoints = new List<string>
                        {
                            "Leading the frontier of smart, adaptive learning experiences.",
                            "Empowering educators to share expertise and mentor next-generation talent.",
                            "Uncompromising commitment to curriculum quality and verified certifications."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "Why Choose EduLab?",
                        Content = "Built from the ground up for maximum learner productivity and retention:",
                        Icon = "star",
                        BulletPoints = new List<string>
                        {
                            "High-definition video lectures focused on hands-on project building.",
                            "Verified digital certificates with cryptographically signed QR verification.",
                            "Direct lecture Q&A and community discussions with instructors.",
                            "Personalized progress tracking and automated learning reminders.",
                            "Dedicated 24/7 technical and customer support."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "Contact & Community",
                        Content = "Our global team of engineers and educators is always here to assist you with your learning journey.",
                        Icon = "mail",
                        BulletPoints = new List<string>
                        {
                            $"Support Email: {ContactEmail}",
                            $"Official Website: {WebsiteUrl}",
                            "Customer assistance available 24 hours a day, 7 days a week."
                        }
                    }
                }
            };
        }
        #endregion

        #region Privacy Policy Content
        private static LegalContentDto GetPrivacyArabic()
        {
            return new LegalContentDto
            {
                Type = "privacy",
                Title = "سياسة الخصوصية",
                Subtitle = "نحن ملتزمون بحماية خصوصيتك وبياناتك الشخصية بأعلى معايير الأمان",
                LastUpdated = "سبتمبر 2026",
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new LegalSectionDto
                    {
                        Title = "1. المعلومات التي نجمعها",
                        Content = "نقوم بجمع المعلومات الضرورية فقط لتقديم أفضل تجربة تعليمية مخصصة لك:",
                        Icon = "shield",
                        BulletPoints = new List<string>
                        {
                            "معلومات الحساب: الاسم الكامل، عنوان البريد الإلكتروني، واللغة المفضلة.",
                            "بيانات التعلم: الكورسات المسجلة، تقدم المشاهدة، المحاضرات المكتملة، والشهادات الصادرة.",
                            "بيانات المعاملات: تفاصيل عمليات الشراء وسجلات الاسترداد (تتم معالجة بيانات الدفع البنكية بشكل مشفر عبر Stripe دون تخزين أرقام البطاقات على خوادمنا).",
                            "معلومات الجهاز: رمز الجهاز (Device Token) لإرسال الإشعارات والتذكيرات الدراسية الهامة."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "2. كيف نستخدم معلوماتك",
                        Content = "تُستخدم البيانات التي يتم جمعها للأغراض التالية فقط:",
                        Icon = "lock",
                        BulletPoints = new List<string>
                        {
                            "إنشاء وإدارة حسابك التعليمي وتمكينك من الوصول إلى محتوى الدورات.",
                            "إصدار وتوثيق شهادات التخرج برمز التحقق QR الخاص بك.",
                            "إرسال إشعارات هامة بخصوص ردود المدربين على أسئلتك وتحديثات الكورسات.",
                            "تحسين أداء واستقرار المنصة وتوفير الدعم الفني السريع."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "3. حماية البيانات والأمان",
                        Content = "نطبق أعلى بروتوكولات الأمان العالمية لحماية بياناتك من الوصول غير المصرح به أو التسريب:",
                        Icon = "shield",
                        BulletPoints = new List<string>
                        {
                            "تشفير كامل لجميع الاتصالات عبر بروتوكول HTTPS/TLS 1.3.",
                            "تشفير كلمات المرور باستخدام خوارزميات التجزئة الآمنة (Argon2 / Identity Hashes).",
                            "دعم خاصية المصادقة الثنائية (Two-Factor Authentication) لحماية إضافية لحسابك.",
                            "عدم بيع أو مشاركة بياناتك الشخصية مع أي طرف ثالث لأغراض إعلانية مطلقاً."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "4. حقوقك وخياراتك",
                        Content = "أنت صاحب القرار الأول في بياناتك وحسابك على المنصة:",
                        Icon = "user",
                        BulletPoints = new List<string>
                        {
                            "الوصول إلى بياناتك الشخصية وتعديلها في أي وقت من خلال شاشة تعديل الملف الشخصي.",
                            "التحكم الكامل في إشعارات التطبيق والرسائل الترويجية من صفحة الإعدادات.",
                            "طلب حذف حسابك وجميع البيانات المرتبطة به نهائياً عبر التواصل مع فريق الدعم."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "5. التواصل بخصوص الخصوصية",
                        Content = $"إذا كانت لديك أي أسئلة أو استفسارات تتعلق بسياسة الخصوصية أو ممارسات حماية البيانات، يرجى مراسلتنا عبر البريد الإلكتروني: {ContactEmail}.",
                        Icon = "mail"
                    }
                }
            };
        }

        private static LegalContentDto GetPrivacyEnglish()
        {
            return new LegalContentDto
            {
                Type = "privacy",
                Title = "Privacy Policy",
                Subtitle = "We are committed to protecting your privacy and personal data with industry-leading standards",
                LastUpdated = "September 2026",
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new LegalSectionDto
                    {
                        Title = "1. Information We Collect",
                        Content = "We collect only information essential to providing you with an optimal, personalized educational experience:",
                        Icon = "shield",
                        BulletPoints = new List<string>
                        {
                            "Account Details: Full name, email address, and preferred language.",
                            "Learning Activity: Enrolled courses, video progress, completed lectures, and issued certificates.",
                            "Payment Records: Transaction IDs and refund logs (card information is encrypted and securely processed directly via Stripe; no credit card numbers are stored on our servers).",
                            "Device Data: Device push tokens utilized exclusively for essential notifications and learning reminders."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "2. How We Use Your Information",
                        Content = "Your data is strictly utilized for the following operational purposes:",
                        Icon = "lock",
                        BulletPoints = new List<string>
                        {
                            "Provisioning and authenticating your account and delivering course content.",
                            "Generating and verifying cryptographically signed completion certificates.",
                            "Sending timely notifications for instructor replies, course updates, and progress milestones.",
                            "Platform optimization, stability monitoring, and rapid customer support."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "3. Data Security & Storage",
                        Content = "We apply robust industry security protocols to safeguard your personal data:",
                        Icon = "shield",
                        BulletPoints = new List<string>
                        {
                            "End-to-end transport encryption via HTTPS/TLS 1.3.",
                            "Secure cryptographic hashing for passwords and credentials.",
                            "Optional Two-Factor Authentication (2FA) for heightened account defense.",
                            "Zero third-party data selling or tracking for external marketing purposes."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "4. Your Rights and Choices",
                        Content = "You retain complete authority over your personal information:",
                        Icon = "user",
                        BulletPoints = new List<string>
                        {
                            "Review and update your profile information directly in settings at any time.",
                            "Manage push notifications and communication preferences.",
                            "Request complete account deletion and data erasure by contacting our support team."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "5. Privacy Inquiries",
                        Content = $"For inquiries or requests concerning our privacy policy and data governance practices, contact our Data Protection Officer at: {ContactEmail}.",
                        Icon = "mail"
                    }
                }
            };
        }
        #endregion

        #region Terms of Service Content
        private static LegalContentDto GetTermsArabic()
        {
            return new LegalContentDto
            {
                Type = "terms",
                Title = "شروط الاستخدام والخدمة",
                Subtitle = "يرجى قراءة هذه الشروط بعناية قبل استخدام منصة وتطبيقات EduLab",
                LastUpdated = "سبتمبر 2026",
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new LegalSectionDto
                    {
                        Title = "1. قبول الشروط وإنشاء الحساب",
                        Content = "باستخدامك لمنصة EduLab أو تسجيل حساب، فإنك توافق على الالتزام بجميع بنود هذه الاتفاقية وسياسة الخصوصية الخاصة بالمنصة:",
                        Icon = "check",
                        BulletPoints = new List<string>
                        {
                            "يجب أن تكون المعلومات المقدمة أثناء التسجيل دقيقة وحديثة.",
                            "أنت مسؤول بالكامل عن الحفاظ على سرية بيانات تسجيل الدخول وكلمة المرور الخاصة بك.",
                            "لا يجوز مشاركة الحساب الشخصي أو بيعه أو نقله إلى أي شخص آخر."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "2. الوصول إلى الدورات والملكية الفكرية",
                        Content = "جميع المواد التعليمية والفيديوهات والمستندات المنشورة على EduLab محمية بموجب قوانين حقوق الملكية الفكرية الدولية:",
                        Icon = "book",
                        BulletPoints = new List<string>
                        {
                            "يمنحك شراء الكورس ترخيصاً شخصياً وغير حصري لمشاهدة المحتوى التعليمي.",
                            "يُحظر تماماً إعادة نشر، تسجيل، توزيع، أو بيع أي جزء من المحتوى دون إذن كتابي مسبق.",
                            "الشهادات الصادرة تمنح للمتعلم الذي أتم متطلبات الدورة بنجاح فقط."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "3. الدفع وسياسة استرداد الأموال",
                        Content = "نلتزم بتقديم تجربة شراء شفافة وآمنة بالكامل:",
                        Icon = "credit-card",
                        BulletPoints = new List<string>
                        {
                            "تتم معالجة جميع المدفوعات بشكل آمن وفوري عبر بوابات الدفع المعتمدة عالمياً.",
                            "يحق للطالب تقديم طلب استرداد خلال 30 يوماً من تاريخ الشراء في حال عدم مشاهدة نسبة كبيرة من الكورس.",
                            "تتم مراجعة طلبات الاسترداد من قبل الإدارة وإعادة المبلغ إلى حساب الدفع الأصلي عند الموافقة."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "4. قواعد السلوك والمجتمع",
                        Content = "حرصاً على بيئة تعليمية إيجابية ومحترمة للجميع، يُحظر ما يلي:",
                        Icon = "users",
                        BulletPoints = new List<string>
                        {
                            "استخدام لغة غير لائقة أو الإساءة لأي طالب أو مدرب في التعليقات أو المراسلات.",
                            "نشر أي محتوى غير قانوني أو مسروق أو دعائي مضلل.",
                            "يحق لإدارة المنصة تعليق أو حظر أي حساب يخالف قواعد المجتمع بشكل متكرر."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "5. تعديل الشروط والتواصل",
                        Content = $"تحتفظ EduLab بالحق في تحديث هذه الشروط عند الضرورة، وسيتم إخطار المستخدمين بأي تغييرات جوهرية. لأي استفسار يرجى مراسلتنا على: {ContactEmail}.",
                        Icon = "mail"
                    }
                }
            };
        }

        private static LegalContentDto GetTermsEnglish()
        {
            return new LegalContentDto
            {
                Type = "terms",
                Title = "Terms of Service",
                Subtitle = "Please review these terms and conditions carefully before utilizing EduLab services",
                LastUpdated = "September 2026",
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new LegalSectionDto
                    {
                        Title = "1. Acceptance & Account Responsibilities",
                        Content = "By creating an account or accessing the EduLab platform, you explicitly agree to be bound by these terms and our privacy policy:",
                        Icon = "check",
                        BulletPoints = new List<string>
                        {
                            "You must provide accurate, complete, and current information during registration.",
                            "You are solely responsible for maintaining the confidentiality and security of your credentials.",
                            "Accounts are non-transferable and may not be shared, sold, or redistributed."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "2. Intellectual Property & Course Access",
                        Content = "All course materials, video lectures, coding exercises, and digital assets on EduLab are proprietary and protected by copyright law:",
                        Icon = "book",
                        BulletPoints = new List<string>
                        {
                            "Course enrollment grants a personal, non-exclusive, non-transferable license to view educational material.",
                            "Recording, scraping, unauthorized redistribution, or reselling of course material is strictly prohibited.",
                            "Completion certificates are issued exclusively to the registered individual who satisfies course requirements."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "3. Payments & Refund Policy",
                        Content = "We are dedicated to providing a fair, transparent, and secure purchasing process:",
                        Icon = "credit-card",
                        BulletPoints = new List<string>
                        {
                            "Transactions are processed securely via certified global payment gateways.",
                            "Learners are entitled to submit a refund request within 30 days of purchase under qualifying conditions.",
                            "Approved refunds are credited directly back to the original method of payment."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "4. Community Code of Conduct",
                        Content = "To maintain an inspiring, constructive, and respectful educational environment, users must adhere to our standards:",
                        Icon = "users",
                        BulletPoints = new List<string>
                        {
                            "Refrain from abusive, discriminatory, or disruptive communication in comments and reviews.",
                            "Never upload infringing, fraudulent, or unsolicited promotional content.",
                            "EduLab reserves the right to suspend or terminate accounts violating community integrity."
                        }
                    },
                    new LegalSectionDto
                    {
                        Title = "5. Modifications & Inquiries",
                        Content = $"EduLab reserves the right to update these terms as necessary. Continued use signifies acceptance of revised terms. For questions, contact us at: {ContactEmail}.",
                        Icon = "mail"
                    }
                }
            };
        }
        #endregion
    }
}
