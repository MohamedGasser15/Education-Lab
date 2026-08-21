namespace EduLab_API.Settings
{
    /// <summary>
    /// Stripe API credentials bound from the Stripe section of the configuration
    /// </summary>
    public class StripeSettings
    {
        /// <summary>
        /// Stripe secret key used for server-side API calls
        /// </summary>
        public string SecretKey { get; set; }

        /// <summary>
        /// Stripe publishable key used by the client
        /// </summary>
        public string PublishKey { get; set; }
    }
}
