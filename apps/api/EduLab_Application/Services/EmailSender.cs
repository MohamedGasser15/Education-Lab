using EduLab_Application.ServiceInterfaces;
using Microsoft.Extensions.Configuration;
using MailKit.Net.Smtp;
using MimeKit;
using MimeKit.Text;


namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for sending emails using SMTP
    /// </summary>
    public class EmailSender : IEmailSender
    {
        private readonly string _host;
        private readonly int _port;
        private readonly string _username;
        private readonly string _password;

        public EmailSender(IConfiguration config)
        {
            _host = config["GoogleSMTP:Host"];
            _port = config.GetValue<int>("GoogleSMTP:Port");
            _username = config["GoogleSMTP:Username"];
            _password = config["GoogleSMTP:Password"];
        }

        /// <summary>
        /// Sends an email to the specified recipient
        /// </summary>
        /// <param name="email">Recipient email address</param>
        /// <param name="subject">Email subject</param>
        /// <param name="htmlMessage">HTML content of the email</param>
        public async Task SendEmailAsync(string email, string subject, string htmlMessage)
        {
            var emailMessage = new MimeMessage();

            // Set From address
            emailMessage.From.Add(new MailboxAddress("EducationLab", "edulab152@gmail.com"));

            // Set To address
            emailMessage.To.Add(MailboxAddress.Parse(email));

            // Set subject and body
            emailMessage.Subject = subject;
            emailMessage.Body = new TextPart(TextFormat.Html)
            {
                Text = htmlMessage
            };

            using var client = new SmtpClient();

            // Connect to Google's SMTP server
            await client.ConnectAsync(_host, _port, MailKit.Security.SecureSocketOptions.StartTls);

            // Authenticate with credentials
            await client.AuthenticateAsync(_username, _password);

            // Send email
            await client.SendAsync(emailMessage);

            // Disconnect
            await client.DisconnectAsync(true);
        }

        /// <summary>
        /// Sends an email with an attached file to the specified recipient
        /// </summary>
        /// <param name="email">Recipient email address</param>
        /// <param name="subject">Email subject</param>
        /// <param name="htmlMessage">HTML content of the email</param>
        /// <param name="attachmentPath">Path of the file to attach</param>
        /// <param name="attachmentName">Name of the attached file</param>
        public async Task SendEmailWithAttachmentAsync(string email, string subject, string htmlMessage, string attachmentPath, string attachmentName)
        {
            var emailMessage = new MimeMessage();

            emailMessage.From.Add(new MailboxAddress("EducationLab", "edulab152@gmail.com"));
            emailMessage.To.Add(MailboxAddress.Parse(email));
            emailMessage.Subject = subject;

            var body = new TextPart(TextFormat.Html)
            {
                Text = htmlMessage
            };

            var multipart = new Multipart("mixed");
            multipart.Add(body);

            if (File.Exists(attachmentPath))
            {
                var contentType = MimeTypes.GetMimeType(attachmentName);
                var attachment = new MimePart(contentType)
                {
                    Content = new MimeContent(File.OpenRead(attachmentPath), ContentEncoding.Default),
                    ContentDisposition = new ContentDisposition(ContentDisposition.Attachment),
                    ContentTransferEncoding = ContentEncoding.Base64,
                    FileName = attachmentName
                };
                multipart.Add(attachment);
            }

            emailMessage.Body = multipart;

            using var client = new SmtpClient();

            await client.ConnectAsync(_host, _port, MailKit.Security.SecureSocketOptions.StartTls);
            await client.AuthenticateAsync(_username, _password);
            await client.SendAsync(emailMessage);
            await client.DisconnectAsync(true);
        }
    }
}
