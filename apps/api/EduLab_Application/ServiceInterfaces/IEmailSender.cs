using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for sending emails
    /// </summary>
    public interface IEmailSender
    {
        /// <summary>
        /// Sends an email to the specified recipient
        /// </summary>
        /// <param name="email">Recipient email address</param>
        /// <param name="subject">Email subject</param>
        /// <param name="htmlMessage">HTML content of the email</param>
        Task SendEmailAsync(string email, string subject, string htmlMessage);

        /// <summary>
        /// Sends an email with an attached file to the specified recipient
        /// </summary>
        /// <param name="email">Recipient email address</param>
        /// <param name="subject">Email subject</param>
        /// <param name="htmlMessage">HTML content of the email</param>
        /// <param name="attachmentPath">Path of the file to attach</param>
        /// <param name="attachmentName">Name of the attached file</param>
        Task SendEmailWithAttachmentAsync(string email, string subject, string htmlMessage, string attachmentPath, string attachmentName);
    }
}