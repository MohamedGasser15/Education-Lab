using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class EmailTemplateService : IEmailTemplateService
    {
        public string GenerateLoginEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime requestTime, string passwordResetLink)
        {
            string emailTemplate = $@"
<!DOCTYPE html>
<html lang='ar' dir='rtl'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>EduLab - تنبيه تسجيل دخول</title>
    <link href='https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700&display=swap' rel='stylesheet'>
</head>
<body style='margin: 0; background-color: #f0f4f8; font-family: ""Tajawal"", sans-serif; direction: rtl; text-align: right; color: #1e293b;'>

    <div style='max-width: 600px; margin: auto; background: #ffffff; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden;'>

                    <div style='background: linear-gradient(90deg, #2563eb, #1e40af); padding: 20px; text-align: center;'>
                        <h1 style='color: #ffffff; font-size: 1.4rem; font-weight: 700; margin: 0;'>تنبيه تسجيل دخول جديد</h1>
                        <a href='/' style='display: inline-block; color: #ffffff; font-size: 1.1rem; margin-top: 10px; text-decoration: none;'>Education Lab</a>
                    </div>

        <div style='padding: 28px;'>

            <p style='font-size: 1rem; margin-bottom: 20px;'>مرحباً <strong>{user.FullName}</strong>، تم رصد تسجيل دخول جديد لحسابك. التفاصيل موضّحة بالأسفل:</p>

            <div style='background-color: #f9fafb; border: 1px solid #d1d5db; border-radius: 12px; padding: 20px; margin-bottom: 24px;'>

                <div style='margin-bottom: 12px;'>
                    <span style='display:inline-block; width: 12px; height: 12px; background-color: #2563eb; border-radius: 50%; margin-left: 8px;'></span>
                    <strong>الاسم الكامل:</strong> {user.FullName}
                </div>

                <div style='margin-bottom: 12px;'>
                    <span style='display:inline-block; width: 12px; height: 12px; background-color: #2563eb; border-radius: 50%; margin-left: 8px;'></span>
                    <strong>وقت الدخول:</strong> {requestTime:yyyy/MM/dd HH:mm}
                </div>

                <div style='margin-bottom: 12px;'>
                    <span style='display:inline-block; width: 12px; height: 12px; background-color: #2563eb; border-radius: 50%; margin-left: 8px;'></span>
                    <strong>عنوان الإنترنت:</strong> {ipAddress}
                </div>

                <div>
                    <span style='display:inline-block; width: 12px; height: 12px; background-color: #2563eb; border-radius: 50%; margin-left: 8px;'></span>
                    <strong>نوع الجهاز:</strong> {deviceName}
                </div>

            </div>

            <div style='background-color: #fff7ed; border-right: 4px solid #f59e0b; border-radius: 8px; padding: 16px; margin-bottom: 24px;'>
                <h3 style='margin-top: 0; font-size: 1rem; color: #b45309;'>تحذير أمني</h3>
                <p style='margin: 0;'>إذا لم تكن أنت من قام بهذا الدخول، قم بتغيير كلمة المرور فوراً باستخدام الزر التالي. وننصحك بتفعيل المصادقة الثنائية لزيادة الأمان.</p>
            </div>

            <div style='text-align: center; margin-bottom: 32px;'>
                <a href='{passwordResetLink}' style='display: inline-block; padding: 14px 28px; background-color: #2563eb; color: #ffffff; text-decoration: none; border-radius: 8px; font-size: 1rem; font-weight: 600;'>تغيير كلمة المرور</a>
            </div>

            <p style='font-size: 0.875rem; color: #64748b; text-align: center;'>لو كان الدخول من طرفك، يمكنك تجاهل هذه الرسالة.</p>
        </div>

        <div style='background-color: #f1f5f9; text-align: center; padding: 16px; font-size: 0.75rem; color: #64748b; border-top: 1px solid #e2e8f0;'>
            <a href='https://edulab.com/privacy' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>سياسة الخصوصية</a> |
            <a href='https://edulab.com/terms' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الشروط والأحكام</a> |
            <a href='https://edulab.com/contact' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الدعم الفني</a>
            <p style='margin-top: 12px;'>© {DateTime.Now.Year} EduLab. جميع الحقوق محفوظة.</p>
        </div>

    </div>
</body>
</html>";
            return emailTemplate;
        }
        public string GenerateVerificationEmail(string code)
        {
            string emailTemplate = $@"
<!DOCTYPE html>
<html lang='ar' dir='rtl'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>تأكيد البريد الإلكتروني - EduLab</title>
</head>
<body style='margin: 0; background-color: #f0f4f8; font-family: Arial, sans-serif; direction: rtl; text-align: right; color: #1e293b;'>

    <div style='max-width: 600px; margin: auto; background: #ffffff; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden;'>

        <!-- Header -->
        <div style='background: linear-gradient(90deg, #2563eb, #1e40af); padding: 20px; text-align: center;'>
            <h1 style='color: #ffffff; font-size: 1.4rem; font-weight: 700; margin: 0;'>تأكيد البريد الإلكتروني</h1>
            <a href='/' style='display: inline-block; color: #ffffff; font-size: 1.1rem; margin-top: 10px; text-decoration: none;'>Education Lab</a>
        </div>

        <!-- Content -->
        <div style='padding: 28px;'>

            <p style='font-size: 1rem; margin-bottom: 20px;'>مرحباً ، شكراً لتسجيلك في منصة EduLab التعليمية! يرجى استخدام رمز التحقق التالي لتأكيد بريدك الإلكتروني:</p>

            <!-- Verification Code -->
            <div style='font-size: 28px; font-weight: bold; color: #2563eb; letter-spacing: 3px; text-align: center; margin: 25px 0; padding: 15px; background-color: #f0f7ff; border-radius: 6px; border: 1px dashed #2563eb;'>
                {code}
            </div>

            <p style='font-size: 1rem; margin-bottom: 20px;'>هذا الرمز صالح لمدة 15 دقيقة فقط. إذا لم تطلبه، يمكنك تجاهل هذه الرسالة.</p>

            <!-- Security Alert -->
            <div style='background-color: #fff7ed; border-right: 4px solid #f59e0b; border-radius: 8px; padding: 16px; margin-bottom: 24px;'>
                <h3 style='margin-top: 0; font-size: 1rem; color: #b45309;'>تحذير أمني</h3>
                <p style='margin: 0;'>لا تشارك هذا الرمز مع أي شخص. منصة EduLab لن تطلب منك رمز التحقق أبداً.</p>
            </div>
        </div>

        <!-- Footer -->
        <div style='background-color: #f1f5f9; text-align: center; padding: 16px; font-size: 0.75rem; color: #64748b; border-top: 1px solid #e2e8f0;'>
            <a href='https://edulab.com/privacy' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>سياسة الخصوصية</a> |
            <a href='https://edulab.com/terms' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الشروط والأحكام</a> |
            <a href='https://edulab.com/contact' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الدعم الفني</a>
            <p style='margin-top: 12px;'>© {DateTime.Now.Year} EduLab. جميع الحقوق محفوظة.</p>
        </div>

    </div>
</body>
</html>";

            return emailTemplate;
        }
        public string GeneratePasswordChangeEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime changeTime, string passwordResetLink)
        {
            string emailTemplate = $@"
<!DOCTYPE html>
<html lang='ar' dir='rtl'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>EduLab - تنبيه تغيير كلمة المرور</title><link href='https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700&display=swap' rel='stylesheet'></head><body style='margin: 0; background-color: #f0f4f8; font-family: ""Tajawal"", sans-serif; direction: rtl; text-align: right; color: #1e293b;'>
<div style='max-width: 600px; margin: auto; background: #ffffff; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden;'>

    <div style='background: linear-gradient(90deg, #2563eb, #1e40af); padding: 20px; text-align: center;'>
        <h1 style='color: #ffffff; font-size: 1.4rem; font-weight: 700; margin: 0;'>تنبيه تغيير كلمة المرور</h1>
        <a href='/' style='display: inline-block; color: #ffffff; font-size: 1.1rem; margin-top: 10px; text-decoration: none;'>Education Lab</a>
    </div>

    <div style='padding: 28px;'>

        <p style='font-size: 1rem; margin-bottom: 20px;'>مرحباً <strong>{user.FullName}</strong>، تم تغيير كلمة المرور لحسابك. التفاصيل موضّحة بالأسفل:</p>

        <div style='background-color: #f9fafb; border: 1px solid #d1d5db; border-radius: 12px; padding: 20px; margin-bottom: 24px;'>

            <div style='margin-bottom: 12px;'>
                <span style='display:inline-block; width: 12px; height: 12px; background-color: #2563eb; border-radius: 50%; margin-left: 8px;'></span>
                <strong>الاسم الكامل:</strong> {user.FullName}
            </div>

            <div style='margin-bottom: 12px;'>
                <span style='display:inline-block; width: 12px; height: 12px; background-color: #2563eb; border-radius: 50%; margin-left: 8px;'></span>
                <strong>وقت التغيير:</strong> {changeTime:yyyy/MM/dd HH:mm}
            </div>

            <div style='margin-bottom: 12px;'>
                <span style='display:inline-block; width: 12px; height: 12px; background-color: #2563eb; border-radius: 50%; margin-left: 8px;'></span>
                <strong>عنوان الإنترنت:</strong> {ipAddress}
            </div>

            <div>
                <span style='display:inline-block; width: 12px; height: 12px; background-color: #2563eb; border-radius: 50%; margin-left: 8px;'></span>
                <strong>نوع الجهاز:</strong> {deviceName}
            </div>

        </div>

        <div style='background-color: #fff7ed; border-right: 4px solid #f59e0b; border-radius: 8px; padding: 16px; margin-bottom: 24px;'>
            <h3 style='margin-top: 0; font-size: 1rem; color: #b45309;'>تحذير أمني</h3>
            <p style='margin: 0;'>إذا لم تكن أنت من قام بهذا التغيير، قم بتأمين حسابك فوراً باستخدام الزر التالي. وننصحك بتفعيل المصادقة الثنائية لزيادة الأمان.</p>
        </div>

        <div style='text-align: center; margin-bottom: 32px;'>
            <a href='{passwordResetLink}' style='display: inline-block; padding: 14px 28px; background-color: #2563eb; color: #ffffff; text-decoration: none; border-radius: 8px; font-size: 1rem; font-weight: 600;'>تأمين حسابي</a>
        </div>

        <p style='font-size: 0.875rem; color: #64748b; text-align: center;'>لو كان التغيير من طرفك، يمكنك تجاهل هذه الرسالة.</p>
    </div>

    <div style='background-color: #f1f5f9; text-align: center; padding: 16px; font-size: 0.75rem; color: #64748b; border-top: 1px solid #e2e8f0;'>
        <a href='https://edulab.com/privacy' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>سياسة الخصوصية</a> |
        <a href='https://edulab.com/terms' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الشروط والأحكام</a> |
        <a href='https://edulab.com/contact' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الدعم الفني</a>
        <p style='margin-top: 12px;'>© {DateTime.Now.Year} EduLab. جميع الحقوق محفوظة.</p>
    </div>

</div>
</body></html>";

            return emailTemplate;
        }
        public string GenerateEmailEnable2FA(ApplicationUser user, string code, string Enable2FALink)
        {
            return $@"<!DOCTYPE html>
<html lang='ar' dir='rtl'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>EduLab - رمز المصادقة الثنائية</title>
    <link href='https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700&display=swap' rel='stylesheet'>
</head>
<body style='margin: 0; background-color: #f0f4f8; font-family: ""Tajawal"", sans-serif; direction: rtl; text-align: right; color: #1e293b;'>
<div style='max-width: 600px; margin: auto; background: #ffffff; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden;'>

    <div style='background: linear-gradient(90deg, #2563eb, #1e40af); padding: 20px; text-align: center;'>
        <h1 style='color: #ffffff; font-size: 1.4rem; font-weight: 700; margin: 0;'>المصادقة الثنائية</h1>
        <a href='/' style='display: inline-block; color: #ffffff; font-size: 1.1rem; margin-top: 10px; text-decoration: none;'>Education Lab</a>
    </div>

    <div style='padding: 28px;'>
        <p style='font-size: 1rem; margin-bottom: 20px;'>مرحباً <strong>{user.FullName}</strong>،</p>
        <p style='font-size: 1rem; margin-bottom: 20px;'>تحتاج محاولة تسجيل الدخول الخاصة بك إلى التحقق. استخدم هذا الرمز لإكمال عملية الدخول:</p>

        <div style='font-size: 28px; font-weight: bold; color: #2563eb; letter-spacing: 3px; text-align: center; margin: 25px 0; padding: 15px; background-color: #f0f7ff; border-radius: 6px; border: 1px dashed #2563eb;'>
            {code}
        </div>

        <p style='font-size: 1rem; margin-bottom: 20px;'>هذا الرمز صالح لمدة 15 دقيقة فقط. إذا لم تطلبه، يمكنك تجاهل هذه الرسالة.</p>

        <div style='background-color: #fff7ed; border-right: 4px solid #f59e0b; border-radius: 8px; padding: 16px; margin-bottom: 24px;'>
            <h3 style='margin-top: 0; font-size: 1rem; color: #b45309;'>نصيحة أمنية</h3>
            <p style='margin: 0;'>لا تشارك هذا الرمز مع أي شخص. منصة EduLab لن تطلب منك رمز التحقق أبداً.</p>
        </div>

        <div style='text-align: center; margin-bottom: 32px;'>
            <a href='{Enable2FALink}' style='display: inline-block; padding: 14px 28px; background-color: #2563eb; color: #ffffff; text-decoration: none; border-radius: 8px; font-size: 1rem; font-weight: 600;'>تأكيد البريد الإلكتروني</a>
        </div>

        <p style='font-size: 0.875rem; color: #64748b; text-align: center;'>إذا لم يعمل الزر، انسخ والصق الرابط التالي في متصفحك:</p>
        <p style='font-size: 0.875rem; color: #64748b; text-align: center; word-break: break-all;'>{Enable2FALink}</p>
    </div>

    <div style='background-color: #f1f5f9; text-align: center; padding: 16px; font-size: 0.75rem; color: #64748b; border-top: 1px solid #e2e8f0;'>
        <a href='https://edulab.com/privacy' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>سياسة الخصوصية</a> |
        <a href='https://edulab.com/terms' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الشروط والأحكام</a> |
        <a href='https://edulab.com/contact' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الدعم الفني</a>
        <p style='margin-top: 12px;'>© {DateTime.Now.Year} EduLab. جميع الحقوق محفوظة.</p>
    </div>

</div>
</body>
</html>";
        }

        public string GenerateInstructorApprovalEmail(ApplicationUser user)
        {
            string emailTemplate = $@"
            <!DOCTYPE html>
            <html lang='ar' dir='rtl'>
            <head>
                <meta charset='UTF-8'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>EduLab - قبول طلب الانضمام كمدرب</title>
                <link href='https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700&display=swap' rel='stylesheet'>
            </head>
            <body style='margin: 0; background-color: #f0f4f8; font-family: ""Tajawal"", sans-serif; direction: rtl; text-align: right; color: #1e293b;'>

                <div style='max-width: 600px; margin: auto; background: #ffffff; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden;'>

                    <div style='background: linear-gradient(90deg, #10b981, #059669); padding: 20px; text-align: center;'>
                        <h1 style='color: #ffffff; font-size: 1.4rem; font-weight: 700; margin: 0;'>مبروك! تم قبولك كمدرب</h1>
                        <a href='/' style='display: inline-block; color: #ffffff; font-size: 1.1rem; margin-top: 10px; text-decoration: none;'>Education Lab</a>
                    </div>

                    <div style='padding: 28px;'>

                        <p style='font-size: 1rem; margin-bottom: 20px;'>مرحباً <strong>{user.FullName}</strong>،</p>
                        <p style='font-size: 1rem; margin-bottom: 20px;'>يسعدنا إعلامك بأن طلب الانضمام كمدرب في منصة EduLab <strong>تمت الموافقة عليه</strong>. نرحب بك في عائلة مدربينا المتميزين.</p>

                        <div style='background-color: #ecfdf5; border: 1px solid #d1fae5; border-radius: 12px; padding: 20px; margin-bottom: 24px;'>

                            <div style='margin-bottom: 12px;'>
                                <span style='display:inline-block; width: 12px; height: 12px; background-color: #10b981; border-radius: 50%; margin-left: 8px;'></span>
                                <strong>الاسم الكامل:</strong> {user.FullName}
                            </div>

                            <div style='margin-bottom: 12px;'>
                                <span style='display:inline-block; width: 12px; height: 12px; background-color: #10b981; border-radius: 50%; margin-left: 8px;'></span>
                                <strong>تاريخ القبول:</strong> {DateTime.Now:yyyy/MM/dd HH:mm}
                            </div>

                            <div>
                                <span style='display:inline-block; width: 12px; height: 12px; background-color: #10b981; border-radius: 50%; margin-left: 8px;'></span>
                                <strong>الحالة الجديدة:</strong> مدرب معتمد
                            </div>

                        </div>

                        <div style='background-color: #f0f9ff; border-right: 4px solid #0ea5e9; border-radius: 8px; padding: 16px; margin-bottom: 24px;'>
                            <h3 style='margin-top: 0; font-size: 1rem; color: #0369a1;'>الخطوات التالية</h3>
                            <p style='margin: 0;'>يمكنك الآن تسجيل الدخول إلى حسابك والبدء في إنشاء محتوى تعليمي. ننصحك بمراجعة دليل المدربين للتعرف على سياسات النشر والإرشادات.</p>
                        </div>

                        <div style='text-align: center; margin-bottom: 32px;'>
                            <a href='https://edulab.com/instructor-dashboard' style='display: inline-block; padding: 14px 28px; background-color: #10b981; color: #ffffff; text-decoration: none; border-radius: 8px; font-size: 1rem; font-weight: 600;'>الذهاب إلى لوحة التحكم</a>
                        </div>

                        <p style='font-size: 0.875rem; color: #64748b; text-align: center;'>نتمنى لك تجربة تدريس مميزة ومثمرة مع منصة EduLab.</p>
                    </div>

                    <div style='background-color: #f1f5f9; text-align: center; padding: 16px; font-size: 0.75rem; color: #64748b; border-top: 1px solid #e2e8f0;'>
                        <a href='https://edulab.com/privacy' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>سياسة الخصوصية</a> |
                        <a href='https://edulab.com/terms' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الشروط والأحكام</a> |
                        <a href='https://edulab.com/contact' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الدعم الفني</a>
                        <p style='margin-top: 12px;'>© {DateTime.Now.Year} EduLab. جميع الحقوق محفوظة.</p>
                    </div>

                </div>
            </body>
            </html>";
            return emailTemplate;
        }
        public string GenerateInstructorRejectionEmail(ApplicationUser user, string rejectionReason = "")
        {
            string emailTemplate = $@"
            <!DOCTYPE html>
            <html lang='ar' dir='rtl'>
            <head>
                <meta charset='UTF-8'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>EduLab - قرار بشأن طلب الانضمام كمدرب</title>
                <link href='https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700&display=swap' rel='stylesheet'>
            </head>
            <body style='margin: 0; background-color: #f0f4f8; font-family: ""Tajawal"", sans-serif; direction: rtl; text-align: right; color: #1e293b;'>

                <div style='max-width: 600px; margin: auto; background: #ffffff; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden;'>

                    <div style='background: linear-gradient(90deg, #ef4444, #dc2626); padding: 20px; text-align: center;'>
                        <h1 style='color: #ffffff; font-size: 1.4rem; font-weight: 700; margin: 0;'>قرار بشأن طلب المدرب</h1>
                        <a href='/' style='display: inline-block; color: #ffffff; font-size: 1.1rem; margin-top: 10px; text-decoration: none;'>Education Lab</a>
                    </div>

                    <div style='padding: 28px;'>

                        <p style='font-size: 1rem; margin-bottom: 20px;'>مرحباً <strong>{user.FullName}</strong>،</p>
                        <p style='font-size: 1rem; margin-bottom: 20px;'>نشكرك على اهتمامك بالانضمام كمدرب في منصة EduLab. بعد مراجعة طلبك، نأسف لإعلامك بأنه <strong>لم يتم قبوله في هذه المرحلة</strong>.</p>

                        <div style='background-color: #fef2f2; border: 1px solid #fecaca; border-radius: 12px; padding: 20px; margin-bottom: 24px;'>

                            <div style='margin-bottom: 12px;'>
                                <span style='display:inline-block; width: 12px; height: 12px; background-color: #ef4444; border-radius: 50%; margin-left: 8px;'></span>
                                <strong>الاسم الكامل:</strong> {user.FullName}
                            </div>

                            <div style='margin-bottom: 12px;'>
                                <span style='display:inline-block; width: 12px; height: 12px; background-color: #ef4444; border-radius: 50%; margin-left: 8px;'></span>
                                <strong>تاريخ الرد:</strong> {DateTime.Now:yyyy/MM/dd HH:mm}
                            </div>

                            <div>
                                <span style='display:inline-block; width: 12px; height: 12px; background-color: #ef4444; border-radius: 50%; margin-left: 8px;'></span>
                                <strong>الحالة:</strong> مرفوض
                            </div>

                        </div>

                        {(string.IsNullOrEmpty(rejectionReason) ? "" : $@"
                        <div style='background-color: #fffbeb; border-right: 4px solid #f59e0b; border-radius: 8px; padding: 16px; margin-bottom: 24px;'>
                            <h3 style='margin-top: 0; font-size: 1rem; color: #b45309;'>ملاحظات:</h3>
                            <p style='margin: 0;'>{rejectionReason}</p>
                        </div>
                        ")}

                        <div style='background-color: #f0f9ff; border-right: 4px solid #0ea5e9; border-radius: 8px; padding: 16px; margin-bottom: 24px;'>
                            <h3 style='margin-top: 0; font-size: 1rem; color: #0369a1;'>خيارات مستقبلية</h3>
                            <p style='margin: 0;'>يمكنك تحسين مؤهلاتك وإعادة التقديم في المستقبل. نرحب دائمًا بالمتقدمين المتحمسين للانضمام إلى مجتمعنا التعليمي.</p>
                        </div>

                        <div style='text-align: center; margin-bottom: 32px;'>
                            <a href='https://edulab.com/apply-again' style='display: inline-block; padding: 14px 28px; background-color: #3b82f6; color: #ffffff; text-decoration: none; border-radius: 8px; font-size: 1rem; font-weight: 600;'>التقديم مرة أخرى</a>
                        </div>

                        <p style='font-size: 0.875rem; color: #64748b; text-align: center;'>نشكرك على تفهمك ونهنئك على روح المبادرة.</p>
                    </div>

                    <div style='background-color: #f1f5f9; text-align: center; padding: 16px; font-size: 0.75rem; color: #64748b; border-top: 1px solid #e2e8f0;'>
                        <a href='https://edulab.com/privacy' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>سياسة الخصوصية</a> |
                        <a href='https://edulab.com/terms' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الشروط والأحكام</a> |
                        <a href='https://edulab.com/contact' style='margin: 0 8px; text-decoration: none; color: #2563eb;'>الدعم الفني</a>
                        <p style='margin-top: 12px;'>© {DateTime.Now.Year} EduLab. جميع الحقوق محفوظة.</p>
                    </div>

                </div>
            </body>
            </html>";
            return emailTemplate;
        }
    }
}
