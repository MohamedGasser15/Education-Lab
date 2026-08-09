using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.Resources;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Localization;
using System.Globalization;
namespace EduLab_Application.Services
{


    public class EmailTemplateService : IEmailTemplateService
    {
        private readonly IStringLocalizer<SharedResources> _localizer;

        public EmailTemplateService(IStringLocalizer<SharedResources> localizer)
        {
            _localizer = localizer;
        }
        private static string HtmlLang(string lang) => lang.StartsWith("en") ? "en" : "ar";
        private static string HtmlDir(string lang) => lang.StartsWith("en") ? "ltr" : "rtl";
        private static string FontFamily(string lang) => lang.StartsWith("en") ? "'Inter', sans-serif" : "'Tajawal', sans-serif";
        private static string FontUrl(string lang) => lang.StartsWith("en")
            ? "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap"
            : "https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700&display=swap";
        private static string BodyStyle(string lang) => lang.StartsWith("en")
            ? "margin: 0; background-color: #f0f4f8; font-family: 'Inter', sans-serif; direction: ltr; text-align: left; color: #1e293b;"
            : "margin: 0; background-color: #f0f4f8; font-family: \"Tajawal\", sans-serif; direction: rtl; text-align: right; color: #1e293b;";
        private static string BorderSide(string lang) => lang.StartsWith("en") ? "border-left" : "border-right";
        private static string MarginSide(string lang) => lang.StartsWith("en") ? "margin-right" : "margin-left";
        private static string EduLabLink() => "https://edulab.runasp.net";

        public string GenerateLoginEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime requestTime, string passwordResetLink, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailLoginAlertTitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{(isEn ? "left" : "right")}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["EmailNewLoginAlert"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailLoginAlertTitle"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailLoginDetailsMsg"], user.FullName)}
                    </div>

                    <!-- Session Details -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailFullName"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{user.FullName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailLoginTime"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{requestTime:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailIPAddress"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{ipAddress}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailDevice"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{deviceName}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Security Warning -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{(isEn ? "left" : "right")}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#991b1b;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#7f1d1d;'>{_localizer["EmailSecurityWarning"]}</strong>
                                {_localizer["EmailLoginWarningMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{passwordResetLink}' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailChangePasswordBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                    <!-- Ignore Message -->
                    <div dir='{dir}' style='font-size:12px;color:#9ca3af;text-align:center;padding-top:12px;border-top:1px solid #f0f2f5;'>
                        {_localizer["EmailIgnoreMsg"]}
                    </div>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }
        public string GenerateVerificationEmail(string code, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailVerificationTitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["EmailVerificationTitle"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailVerificationTitle"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {_localizer["EmailVerificationMsg"]}
                    </div>

                    <!-- Verification Code -->
                    <div dir='{dir}' style='font-size:28px;font-weight:700;color:#0a1628;letter-spacing:4px;text-align:center;margin:0 0 12px;padding:18px;background-color:#f8fafc;border-radius:12px;border:2px dashed #d1d5db;'>
                        {code}
                    </div>

                    <div dir='{dir}' style='font-size:12px;color:#9ca3af;text-align:center;margin-bottom:24px;'>
                        {_localizer["EmailCodeValid15Min"]}
                    </div>

                    <!-- Security Warning -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#991b1b;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#7f1d1d;'>{_localizer["EmailSecurityWarning"]}</strong>
                                {_localizer["EmailVerificationWarning"]}
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GeneratePasswordChangeEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime changeTime, string passwordResetLink, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl" ? "'Cairo', Tahoma, Arial, sans-serif" : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl" ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap" : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailPwdChangeTitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["EmailPwdChangeTitle"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailPwdChangeTitle"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailPwdChangeMsg"], user.FullName)}
                    </div>

                    <!-- Change Details -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailFullName"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{user.FullName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailChangeTime"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{changeTime:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailIPAddress"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{ipAddress}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailDevice"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{deviceName}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Warning -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#991b1b;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#7f1d1d;'>{_localizer["EmailSecurityWarning"]}</strong>
                                {_localizer["EmailPwdChangeWarningMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{passwordResetLink}' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailSecureAccountBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";
            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateEmailEnable2FA(ApplicationUser user, string code, string Enable2FALink, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["Email2FATitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["Email2FATitle"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["Email2FATitle"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {_localizer["Email2FAMsg"]}
                    </div>

                    <!-- 2FA Code -->
                    <div dir='{dir}' style='font-size:28px;font-weight:700;color:#0a1628;letter-spacing:4px;text-align:center;margin:0 0 12px;padding:18px;background-color:#f8fafc;border-radius:12px;border:2px dashed #d1d5db;'>
                        {code}
                    </div>

                    <div dir='{dir}' style='font-size:12px;color:#9ca3af;text-align:center;margin-bottom:24px;'>
                        {_localizer["EmailCodeValid15Min"]}
                    </div>

                    <!-- Security Warning -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#991b1b;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#7f1d1d;'>{_localizer["EmailSecurityTip"]}</strong>
                                {_localizer["EmailVerificationWarning"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{Enable2FALink}' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailConfirmEmailBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateInstructorApprovalEmail(ApplicationUser user, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl" ? "'Cairo', Tahoma, Arial, sans-serif" : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl" ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap" : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailInstApprovedHeader"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["EmailInstApprovedHeader"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailInstApprovedHeader"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {_localizer["EmailInstApprovedMsg"]}
                    </div>

                    <!-- Approval Details -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailFullName"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{user.FullName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailApprovalDate"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{DateTime.Now:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailNewStatus"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{_localizer["EmailCertifiedInstructor"]}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eff6ff;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #3b82f6;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#1e40af;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#1e3a8a;'>{_localizer["EmailNextSteps"]}</strong>
                                {_localizer["EmailInstApprovedNextStepsMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/instructor-dashboard' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailGoToDashboardBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";
            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GeneratePasswordResetEmail(string resetCode, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailPwdResetTitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["EmailPwdResetTitle"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailPwdResetTitle"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {_localizer["EmailPwdResetMsg"]}
                    </div>

                    <!-- Reset Code -->
                    <div dir='{dir}' style='font-size:28px;font-weight:700;color:#0a1628;letter-spacing:4px;text-align:center;margin:0 0 12px;padding:18px;background-color:#f8fafc;border-radius:12px;border:2px dashed #d1d5db;'>
                        {resetCode}
                    </div>

                    <div dir='{dir}' style='font-size:12px;color:#9ca3af;text-align:center;margin-bottom:24px;'>
                        {_localizer["EmailCodeValid10Min"]}
                    </div>

                    <!-- Security Warning -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#991b1b;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#7f1d1d;'>{_localizer["EmailSecurityNote"]}</strong>
                                {_localizer["EmailPwdResetWarning"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Note -->
                    <div dir='{dir}' style='font-size:12px;color:#9ca3af;text-align:center;padding-top:12px;border-top:1px solid #f0f2f5;'>
                        {_localizer["EmailNeverAskCode"]}
                    </div>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GeneratePasswordResetConfirmationEmail(string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailPwdChangedSuccessTitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["EmailPwdChangedSuccessTitle"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailPwdChangedSuccessTitle"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {_localizer["EmailPwdChangedSuccessMsg"]}
                    </div>

                    <!-- Success Details -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailStatus"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#059669;font-size:13px;font-weight:600;'>{_localizer["EmailPwdChangedSuccessTitle"]}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailChangeTime"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{DateTime.Now:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailAction"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{_localizer["EmailCanLoginNow"]}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f0f9ff;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #0ea5e9;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#0369a1;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#075985;'>{_localizer["EmailSecurityTip"]}</strong>
                                {_localizer["EmailPwdChangedTipMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/login' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailLoginNowBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                    <!-- Security Warning -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#991b1b;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#7f1d1d;'>{_localizer["EmailImportantNote"]}</strong>
                                {_localizer["EmailPwdChangedImportantMsg"]}
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateInstructorRejectionEmail(ApplicationUser user, string rejectionReason = "", string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl" ? "'Cairo', Tahoma, Arial, sans-serif" : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl" ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap" : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailInstRejectedHeader"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef2f2;color:#991b1b;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fecaca;display:inline-block;'>{_localizer["EmailInstRejectedHeader"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailInstRejectedHeader"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {_localizer["EmailInstRejectedMsg"]}
                    </div>

                    <!-- Rejection Details -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailFullName"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{user.FullName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailResponseDate"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{DateTime.Now:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailStatus"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#dc2626;font-size:13px;font-weight:600;'>{_localizer["EmailRejected"]}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    {(string.IsNullOrEmpty(rejectionReason) ? "" : $@"
                    <!-- Rejection Reason -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#991b1b;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#7f1d1d;'>{_localizer["EmailNotes"]}</strong>
                                {rejectionReason}
                            </td>
                        </tr>
                    </table>")}

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eff6ff;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #3b82f6;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#1e40af;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#1e3a8a;'>{_localizer["EmailFutureOptions"]}</strong>
                                {_localizer["EmailInstRejectedFutureMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/apply-again' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailApplyAgainBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";
            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateCourseApprovalEmail(ApplicationUser instructor, string courseName, string courseLink, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl" ? "'Cairo', Tahoma, Arial, sans-serif" : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl" ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap" : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailCourseApprovedHeader"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#d1fae5;color:#065f46;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #a7f3d0;display:inline-block;'>{_localizer["EmailCourseApprovedHeader"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailCourseApprovedHeader"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailCourseApprovedMsg"], courseName)}
                    </div>

                    <!-- Course Details -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailInstructorName"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{instructor.FullName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailCourseName"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{courseName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailPublishDate"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{DateTime.Now:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailStatus"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{_localizer["EmailPublishedAndAvailable"]}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eff6ff;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #3b82f6;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#1e40af;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#1e3a8a;'>{_localizer["EmailNextSteps"]}</strong>
                                {_localizer["EmailCourseApprovedNextStepsMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{courseLink}' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailViewCourseBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";
            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateInstructorNotificationEmail(ApplicationUser student, InstructorNotificationRequestDto request, ApplicationUser instructor, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailInstNotificationTitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#ede9fe;color:#5b21b6;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #c4b5fd;display:inline-block;'>{_localizer["EmailInstNotificationTitle"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {request.Title}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailInstNotificationMsg"], instructor.FullName)}
                    </div>

                    <!-- Message Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f9fafb;border:1px solid #d1d5db;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' align='{align}' style='padding:20px;font-size:14px;color:#0a1628;line-height:1.6;white-space:pre-line;'>
                                {request.Message}
                            </td>
                        </tr>
                    </table>

                    <!-- Details Grid -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailSender"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{instructor.FullName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailRecipient"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{student.FullName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailTime"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{DateTime.Now:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailType"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{_localizer["EmailInstMessageType"]}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eff6ff;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #3b82f6;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#1e40af;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#1e3a8a;'>{_localizer["EmailImportantInfo"]}</strong>
                                {_localizer["EmailInstNotificationInfoMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/dashboard/messages' target='_blank' class='btn-stack' style='background-color:#7c3aed;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailGoToMessagesBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateCourseRejectionEmail(ApplicationUser instructor, string courseName, string rejectionReason = "", string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailCourseRejectedHeader"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef2f2;color:#991b1b;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fecaca;display:inline-block;'>{_localizer["EmailCourseRejectedHeader"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailCourseRejectedHeader"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailCourseRejectedMsg"], courseName)}
                    </div>

                    <!-- Details Grid -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailInstructorName"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{instructor.FullName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailCourseName"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{courseName}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailReviewDate"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{DateTime.Now:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailStatus"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#dc2626;font-size:13px;font-weight:600;'>{_localizer["EmailRejected"]}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    {(string.IsNullOrEmpty(rejectionReason) ? "" : $@"
                    <!-- Warning / Reviewer Notes -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#991b1b;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#7f1d1d;'>{_localizer["EmailReviewerNotes"]}</strong>
                                {rejectionReason}
                            </td>
                        </tr>
                    </table>")}

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eff6ff;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #3b82f6;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#1e40af;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#1e3a8a;'>{_localizer["EmailWhatsNext"]}</strong>
                                {_localizer["EmailCourseRejectedNextStepsMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/instructor-dashboard/courses' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailEditCourseBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GeneratePaymentSuccessEmail(ApplicationUser user, List<Course> purchasedCourses,
    decimal totalAmount, string paymentMethod, DateTime paymentTime, string transactionId, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            string coursesList = "";
            foreach (var course in purchasedCourses)
            {
                coursesList += $@"
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background:#f9fafb;border:1px solid #e5e7eb;border-radius:8px;padding:12px;margin-bottom:8px;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:4px 0;'>
                                <div style='font-weight:600;color:#0a1628;font-size:13px;'>{course.Title}</div>
                                <div style='color:#6b7280;font-size:12px;'>{_localizer["EmailByLabel"]} {course.Instructor?.FullName}</div>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='font-weight:600;color:#059669;font-size:13px;white-space:nowrap;'>{course.Price:C}</td>
                        </tr>
                    </table>";
            }

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailPaymentSuccessHeader"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#d1fae5;color:#065f46;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #a7f3d0;display:inline-block;'>{_localizer["EmailPaymentSuccessHeader"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailPaymentSuccessHeader"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailPaymentSuccessHello"], user.FullName)}
                    </div>

                    <!-- Order Details Grid -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailTransactionID"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{transactionId}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailPurchaseDate"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{paymentTime:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailPaymentMethod"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{paymentMethod}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailTotalAmount"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#059669;font-size:13px;font-weight:700;'>{totalAmount:C}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Purchased Courses -->
                    <div dir='{dir}' style='font-size:14px;font-weight:700;color:#0a1628;margin-bottom:12px;text-align:{align};'>
                        {_localizer["EmailPurchasedCourses"]}
                    </div>
                    {coursesList}

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f0fdf4;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #22c55e;margin-top:24px;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#065f46;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#064e3b;'>{_localizer["EmailStartLearningNow"]}</strong>
                                {_localizer["EmailStartLearningMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/dashboard' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailGoToDashboardBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateAdminNotificationEmail(ApplicationUser user, AdminNotificationRequestDto request, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";
            var userName = string.IsNullOrWhiteSpace(user.FullName) ? user.UserName : user.FullName;

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {request.Title}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#f3f4f6;color:#374151;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #d1d5db;display:inline-block;'>{request.Title}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {request.Title}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailCourseApprovedHello"], userName)}
                    </div>

                    <!-- Message Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f9fafb;border:1px solid #d1d5db;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' align='{align}' style='padding:20px;font-size:14px;color:#0a1628;line-height:1.6;white-space:pre-line;'>
                                {request.Message}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/dashboard' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailGoToDashboardBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateAccountLockoutEmail(ApplicationUser user, DateTimeOffset? lockoutEnd, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailAccountLockedHeader"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["EmailAccountLockedHeader"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailAccountLockedHeader"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {_localizer["EmailAccountLockedMsg"]}
                    </div>

                    <!-- Lockout Details -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailAccountStatus"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#dc2626;font-size:13px;font-weight:600;'>{_localizer["EmailTemporarilyLocked"]}</td>
                                    </tr>
                                </table>
                                {(lockoutEnd.HasValue ? $@"
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailLockExpires"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{lockoutEnd.Value.LocalDateTime:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>" : "")}
                            </td>
                        </tr>
                    </table>

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f0f9ff;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #0ea5e9;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#0369a1;line-height:1.5;'>
                                <strong style='display:block;font-size:14px;font-weight:700;margin-bottom:2px;color:#075985;'>{_localizer["EmailWhatShouldYouDo"]}</strong>
                                {_localizer["EmailLockoutAdviceMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/contact' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailContactSupportBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateAccountUnlockEmail(ApplicationUser user, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl" ? "'Cairo', Tahoma, Arial, sans-serif" : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl" ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap" : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailAccountUnlockedHeader"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fef3c7;color:#92400e;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fcd34d;display:inline-block;'>{_localizer["EmailAccountUnlockedHeader"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailAccountUnlockedHeader"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {_localizer["EmailAccountUnlockedMsg"]}
                    </div>

                    <!-- Account Details -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailAccountStatus"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{_localizer["EmailActiveUnlocked"]}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailActivationTime"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{DateTime.Now:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:16px;'>
                        <tr>
                            <td align='center' style='padding-bottom:10px;'>
                                <a href='{EduLabLink()}/login' target='_blank' class='btn-stack' style='background-color:#0a1628;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:12px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailLoginNowBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";
            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateRefundConfirmationEmail(ApplicationUser user, Course course, decimal refundedAmount, DateTime refundTime, string refundId, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailRefundSuccessTitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#dbeafe;color:#1e40af;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #93c5fd;display:inline-block;'>{_localizer["EmailRefundSuccessTitle"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailRefundSuccessTitle"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailCourseApprovedHello"], user.FullName ?? user.Email)}
                        <br/>
                        {_localizer["EmailRefundProcessedMsg"]}
                    </div>

                    <!-- Details Grid -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailRefundCourse"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{course?.Title ?? "—"}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailRefundAmount"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#059669;font-size:13px;font-weight:700;'>${refundedAmount:F2}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailRefundDate"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{refundTime:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailRefundTransactionID"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{refundId}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eff6ff;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #3b82f6;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#1e40af;line-height:1.5;'>
                                {_localizer["EmailRefundBankNote"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Footer Note -->
                    <div dir='{dir}' style='font-size:12px;color:#9ca3af;text-align:center;padding-top:12px;border-top:1px solid #f0f2f5;'>
                        {_localizer["EmailRefundClosingMsg"]}
                    </div>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateRefundRejectionEmail(ApplicationUser user, Course course, string rejectionReason, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailRefundRejectedTitle"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#eef2f7;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#eef2f7;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:20px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-radius:16px;overflow:hidden;border-collapse:separate;box-shadow:0 10px 30px rgba(0,0,0,0.05);'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px 20px;border-bottom:1px solid #f0f2f5;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:40px;height:40px;background-color:#0a1628;border-radius:10px;color:#ffffff;font-weight:700;font-size:16px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:18px;font-weight:700;color:#0a1628;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#fee2e2;color:#b91c1c;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #fca5a5;display:inline-block;'>{_localizer["EmailRefundRejectedTitle"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:20px;font-weight:700;color:#0a1628;margin-bottom:8px;text-align:{align};'>
                        {_localizer["EmailRefundRejectedTitle"]}
                    </div>

                    <div dir='{dir}' style='color:#6b7280;font-size:14px;line-height:1.6;margin-bottom:24px;padding-bottom:16px;border-bottom:2px dashed #f0f2f5;text-align:{align};'>
                        {string.Format(_localizer["EmailCourseApprovedHello"], user.FullName ?? user.Email)}
                        <br/>
                        {_localizer["EmailRefundRejectedMsg"]}
                    </div>

                    <!-- Details Grid -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border-radius:12px;margin-bottom:24px;'>
                        <tr>
                            <td dir='{dir}' style='padding:6px 16px;'>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailRefundCourse"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{course?.Title ?? "—"}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #eef2f7;'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailRefundDate"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{DateTime.UtcNow:yyyy/MM/dd HH:mm}</td>
                                    </tr>
                                </table>
                                <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='{align}' dir='{dir}' style='padding:10px 0;color:#6b7280;font-size:13px;'>{_localizer["EmailRefundRejectionReason"]}</td>
                                        <td align='{oppDir}' dir='{oppDir}' style='padding:10px 0;color:#0a1628;font-size:13px;font-weight:600;'>{(string.IsNullOrEmpty(rejectionReason) ? "—" : rejectionReason)}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <!-- Info Box -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#fef2f2;border-radius:10px;margin-bottom:24px;border-{padSide}:4px solid #ef4444;'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='padding:14px 16px;font-size:13px;color:#b91c1c;line-height:1.5;'>
                                {_localizer["EmailRefundHelpMsg"]}
                            </td>
                        </tr>
                    </table>

                    <!-- Footer Note -->
                    <div dir='{dir}' style='font-size:12px;color:#9ca3af;text-align:center;padding-top:12px;border-top:1px solid #f0f2f5;'>
                        {_localizer["EmailRefundClosingMsg"]}
                    </div>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #f0f2f5;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#d1d5db;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#6b7280;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#9ca3af;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GenerateCertificateEmail(ApplicationUser user, string courseTitle, string certificateCode, string verifyLink, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var lang = HtmlLang(language);
            var dir = _localizer["EmailHtmlDir"].Value ?? HtmlDir(language);
            var isEn = language.StartsWith("en");
            var fontStack = dir == "rtl"
                ? "'Cairo', Tahoma, Arial, sans-serif"
                : "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif";
            var googleFontLink = dir == "rtl"
                ? "https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap"
                : "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap";
            var oppDir = dir == "rtl" ? "ltr" : "rtl";
            var align = isEn ? "left" : "right";
            var padSide = isEn ? "left" : "right";

            var result = $@"
<!DOCTYPE html>
<html lang='{lang}' dir='{dir}' xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>EduLab - {_localizer["EmailCertificateSubject"]}</title>
    <link href='{googleFontLink}' rel='stylesheet'>
    <style type='text/css'>
        body, table, td, a {{ font-family: {fontStack} !important; }}
        @@media only screen and (max-width:600px) {{
            .email-container {{ width:100% !important; max-width:100% !important; }}
            .resp-pad {{ padding-left:16px !important; padding-right:16px !important; }}
            .btn-stack {{ display:block !important; width:100% !important; box-sizing:border-box !important; }}
        }}
    </style>
</head>
<body style='margin:0;padding:0;background-color:#f1f5f9;font-family:{fontStack};direction:{dir};-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;'>
<table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f1f5f9;table-layout:fixed;'>
<tr>
    <td align='center' style='padding:24px 10px;' class='resp-pad'>

        <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' class='email-container' style='max-width:560px;margin:0 auto;background-color:#ffffff;border-collapse:separate;'>

            <!-- Header -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:24px 32px 16px;border-bottom:1px solid #eef2f7;' class='resp-pad'>
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td align='{align}' dir='{dir}' style='vertical-align:middle;'>
                                <table role='presentation' dir='{dir}' border='0' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td align='center' style='width:36px;height:36px;background-color:#2563eb;border-radius:8px;color:#ffffff;font-weight:700;font-size:14px;vertical-align:middle;'>EL</td>
                                        <td align='{align}' dir='{dir}' style='padding-{padSide}:10px;font-size:17px;font-weight:700;color:#0f172a;'>EduLab</td>
                                    </tr>
                                </table>
                            </td>
                            <td align='{oppDir}' dir='{oppDir}' style='vertical-align:middle;'>
                                <span style='background-color:#eff6ff;color:#2563eb;font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;border:1px solid #bfdbfe;display:inline-block;'>{_localizer["Cert_CertificateOfCompletion"]}</span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <!-- Body -->
            <tr>
                <td dir='{dir}' align='{align}' style='padding:28px 32px;' class='resp-pad'>

                    <div dir='{dir}' style='font-size:19px;font-weight:700;color:#0f172a;margin-bottom:6px;text-align:{align};'>
                        {string.Format(_localizer["EmailCertificateCongrats"], user.FullName)}
                    </div>

                    <div dir='{dir}' style='color:#475569;font-size:14px;line-height:1.7;margin-bottom:24px;text-align:{align};'>
                        {string.Format(_localizer["EmailCertificateMsg"], courseTitle)}
                    </div>

                    <!-- Certificate Summary -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color:#f8fafc;border:1px solid #e2e8f0;border-collapse:separate;margin-bottom:24px;'>
                        <tr>
                            <td align='center' dir='{dir}' style='padding:22px 16px;'>
                                <div dir='{dir}' style='font-size:12px;font-weight:700;color:#2563eb;letter-spacing:1.5px;margin-bottom:8px;'>{_localizer["Cert_CertificateOfCompletion"]}</div>
                                <div dir='{dir}' style='font-size:15px;font-weight:700;color:#0f172a;margin-bottom:4px;'>{courseTitle}</div>
                                <div dir='{dir}' style='font-size:12px;color:#64748b;'>
                                    {_localizer["Cert_CertificateId"]}: <strong style='color:#0f172a;'>{certificateCode}</strong>
                                </div>
                            </td>
                        </tr>
                    </table>

                    <!-- Button -->
                    <table role='presentation' dir='{dir}' width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom:20px;'>
                        <tr>
                            <td align='center'>
                                <a href='{verifyLink}' target='_blank' class='btn-stack' style='background-color:#2563eb;color:#ffffff;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;text-align:center;display:block;padding:13px 20px;box-sizing:border-box;'>
                                    {_localizer["EmailCertificateViewBtn"]}
                                </a>
                            </td>
                        </tr>
                    </table>

                    <div dir='{dir}' style='font-size:12px;color:#94a3b8;text-align:center;'>
                        {_localizer["EmailCertificateAttached"]}
                    </div>

                </td>
            </tr>

            <!-- Footer -->
            <tr>
                <td align='center' dir='{dir}' style='background-color:#f8fafc;padding:16px 24px;border-top:1px solid #eef2f7;'>
                    <div dir='{dir}' style='margin-bottom:8px;'>
                        <a href='{EduLabLink()}/privacy' target='_blank' style='color:#64748b;text-decoration:none;font-size:12px;'>{_localizer["EmailPrivacyPolicy"]}</a>
                        <span style='color:#cbd5e1;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/terms' target='_blank' style='color:#64748b;text-decoration:none;font-size:12px;'>{_localizer["EmailTerms"]}</a>
                        <span style='color:#cbd5e1;padding:0 4px;'>·</span>
                        <a href='{EduLabLink()}/contact' target='_blank' style='color:#64748b;text-decoration:none;font-size:12px;'>{_localizer["EmailSupport"]}</a>
                    </div>
                    <div dir='{dir}' style='color:#94a3b8;font-size:11px;'>
                        &copy; {DateTime.Now.Year} EduLab &middot; {_localizer["EmailAllRightsReserved"]}
                    </div>
                </td>
            </tr>

        </table>

    </td>
</tr>
</table>
</body>
</html>";

            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GetLocalizedText(string key, string language = "en")
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var result = _localizer[key].Value;
            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }

        public string GetFormattedText(string key, string language, params object[] args)
        {
            var originalCulture = CultureInfo.CurrentUICulture;
            CultureInfo.CurrentUICulture = new CultureInfo(language);
            var result = string.Format(_localizer[key].Value, args);
            CultureInfo.CurrentUICulture = originalCulture;
            return result;
        }
    }
}
