using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class EmailTemplateService: IEmailTemplateService
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
    }
}
