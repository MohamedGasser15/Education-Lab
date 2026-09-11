using EduLab_Application.ServiceInterfaces;
using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for sending Push Notifications to mobile devices via Firebase Cloud Messaging (FCM)
    /// </summary>
    public class PushNotificationService : IPushNotificationService
    {
        private readonly ILogger<PushNotificationService> _logger;
        private readonly IConfiguration _configuration;
        private readonly bool _isFirebaseInitialized;

        public bool IsFirebaseInitialized => _isFirebaseInitialized;

        public PushNotificationService(
            ILogger<PushNotificationService> logger,
            IConfiguration configuration)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));

            try
            {
                if (FirebaseApp.DefaultInstance == null)
                {
                    var configuredPath = _configuration["Firebase:CredentialPath"] ?? "firebase-key.json";
                    var jsonContent = _configuration["Firebase:CredentialJson"];
                    GoogleCredential? credential = null;

                    if (!string.IsNullOrWhiteSpace(jsonContent))
                    {
                        credential = GoogleCredential.FromJson(jsonContent);
                        _logger.LogInformation("FirebaseApp initialized from Firebase:CredentialJson configuration.");
                    }
                    else
                    {
                        string? finalPath = null;
                        var candidates = new[]
                        {
                            configuredPath,
                            Path.Combine(AppDomain.CurrentDomain.BaseDirectory, configuredPath),
                            Path.Combine(Directory.GetCurrentDirectory(), configuredPath),
                            Path.Combine(Directory.GetCurrentDirectory(), "apps", "api", "EduLab_API", configuredPath),
                            Path.Combine(Directory.GetCurrentDirectory(), "EduLab_API", configuredPath),
                            Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "..", "..", "..", configuredPath),
                            Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "firebase-key.json"),
                            Path.Combine(Directory.GetCurrentDirectory(), "firebase-key.json"),
                            Path.Combine(Directory.GetCurrentDirectory(), "apps", "api", "EduLab_API", "firebase-key.json")
                        };

                        foreach (var candidate in candidates)
                        {
                            try
                            {
                                var fullCandidate = Path.GetFullPath(candidate);
                                if (File.Exists(fullCandidate))
                                {
                                    finalPath = fullCandidate;
                                    break;
                                }
                            }
                            catch { }
                        }

                        if (finalPath != null)
                        {
                            credential = GoogleCredential.FromFile(finalPath);
                            _logger.LogInformation("FirebaseApp successfully initialized with credential file at: {Path}", finalPath);
                        }
                        else
                        {
                            var envCredentials = Environment.GetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS");
                            if (!string.IsNullOrEmpty(envCredentials) && File.Exists(envCredentials))
                            {
                                credential = GoogleCredential.FromFile(envCredentials);
                                _logger.LogInformation("FirebaseApp initialized using GOOGLE_APPLICATION_CREDENTIALS: {Path}", envCredentials);
                            }
                        }
                    }

                    if (credential == null)
                    {
                        try
                        {
                            var assembly = typeof(PushNotificationService).Assembly;
                            var resourceName = "EduLab_Application.firebase-key.json";
                            using var stream = assembly.GetManifestResourceStream(resourceName);
                            if (stream != null)
                            {
                                credential = GoogleCredential.FromStream(stream);
                                _logger.LogInformation("FirebaseApp successfully initialized from Embedded Resource: {Resource}", resourceName);
                            }
                        }
                        catch (Exception resEx)
                        {
                            _logger.LogWarning(resEx, "Failed to load embedded Firebase credentials.");
                        }
                    }

                    if (credential != null)
                    {
                        FirebaseApp.Create(new AppOptions
                        {
                            Credential = credential
                        });
                        _isFirebaseInitialized = true;
                    }
                    else
                    {
                        _logger.LogWarning("Firebase credentials not found. Push notifications will run in simulation mode.");
                        _isFirebaseInitialized = false;
                    }
                }
                else
                {
                    _isFirebaseInitialized = true;
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Failed to initialize FirebaseApp. Push notifications will run in simulation mode.");
                _isFirebaseInitialized = false;
            }
        }

        /// <inheritdoc />
        public async Task<bool> SendPushNotificationAsync(
            string deviceToken,
            string title,
            string body,
            Dictionary<string, string>? data = null,
            CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(deviceToken))
            {
                _logger.LogWarning("Cannot send push notification: Device token is empty.");
                return false;
            }

            try
            {
                if (!_isFirebaseInitialized || FirebaseMessaging.DefaultInstance == null)
                {
                    _logger.LogInformation("[Simulated FCM Push] Token: {Token}, Title: {Title}, Body: {Body}",
                        deviceToken, title, body);
                    return true;
                }

                var message = new Message
                {
                    Token = deviceToken,
                    Notification = new FirebaseAdmin.Messaging.Notification
                    {
                        Title = title,
                        Body = body
                    },
                    Data = data,
                    Android = new AndroidConfig
                    {
                        Priority = Priority.High,
                        Notification = new AndroidNotification
                        {
                            ChannelId = "education_lab_channel",
                            Sound = "default",
                            DefaultSound = true,
                            DefaultVibrateTimings = true
                        }
                    },
                    Apns = new ApnsConfig
                    {
                        Aps = new Aps
                        {
                            Alert = new ApsAlert
                            {
                                Title = title,
                                Body = body
                            },
                            Sound = "default",
                            Badge = 1
                        }
                    }
                };

                var response = await FirebaseMessaging.DefaultInstance.SendAsync(message, cancellationToken);
                _logger.LogInformation("Successfully sent push notification to token {Token}. MessageId: {MessageId}",
                    deviceToken, response);
                return true;
            }
            catch (FirebaseMessagingException ex)
            {
                _logger.LogError(ex, "Firebase error sending push notification to token {Token}: {ErrorCode}",
                    deviceToken, ex.ErrorCode);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error sending push notification to token {Token}", deviceToken);
                return false;
            }
        }

        /// <inheritdoc />
        public async Task<int> SendMulticastPushNotificationAsync(
            List<string> deviceTokens,
            string title,
            string body,
            Dictionary<string, string>? data = null,
            CancellationToken cancellationToken = default)
        {
            if (deviceTokens == null || !deviceTokens.Any())
            {
                return 0;
            }

            var validTokens = deviceTokens.Where(t => !string.IsNullOrWhiteSpace(t)).Distinct().ToList();
            if (!validTokens.Any()) return 0;

            try
            {
                if (!_isFirebaseInitialized || FirebaseMessaging.DefaultInstance == null)
                {
                    _logger.LogInformation("[Simulated FCM Multicast Push] Tokens Count: {Count}, Title: {Title}, Body: {Body}",
                        validTokens.Count, title, body);
                    return validTokens.Count;
                }

                var message = new MulticastMessage
                {
                    Tokens = validTokens,
                    Notification = new FirebaseAdmin.Messaging.Notification
                    {
                        Title = title,
                        Body = body
                    },
                    Data = data,
                    Android = new AndroidConfig
                    {
                        Priority = Priority.High,
                        Notification = new AndroidNotification
                        {
                            ChannelId = "education_lab_channel",
                            Sound = "default",
                            DefaultSound = true,
                            DefaultVibrateTimings = true
                        }
                    },
                    Apns = new ApnsConfig
                    {
                        Aps = new Aps
                        {
                            Alert = new ApsAlert
                            {
                                Title = title,
                                Body = body
                            },
                            Sound = "default",
                            Badge = 1
                        }
                    }
                };

                var response = await FirebaseMessaging.DefaultInstance.SendEachForMulticastAsync(message, cancellationToken);
                _logger.LogInformation("Multicast push sent: {SuccessCount} success, {FailureCount} failure out of {TotalCount}",
                    response.SuccessCount, response.FailureCount, validTokens.Count);

                return response.SuccessCount;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending multicast push notification");
                return 0;
            }
        }
    }
}