namespace EduLab_Seeder.Data
{
    /// <summary>
    /// A verified, streamable video (URL) plus its real duration in seconds.
    /// </summary>
    internal sealed record SeedVideo(string Url, int DurationSeconds);

    /// <summary>
    /// Pool of reliable, publicly hosted videos that are ALL at least 5 minutes long
    /// and actually stream (verified via HTTP 206/200 video/mp4 range requests).
    /// Sources: Blender open movies on Internet Archive + a NASA public-domain clip.
    /// Lectures cycle through this pool; the free-preview section uses every entry
    /// exactly once so all 10 preview videos differ from each other.
    /// </summary>
    internal static class VideoSeedData
    {
        private static string Nasa(string id) =>
            $"https://images-assets.nasa.gov/video/{id}/{id}~mobile.mp4";

        private const string NasaEarthViews =
            "jsc2021m000138_4K_Earth_Views_Extended_Cut_for_Earth_Day_%202021_210422-4KMP4";

        public static readonly SeedVideo[] Pool =
        {
            new("https://archive.org/download/BigBuckBunny_124/Content/big_buck_bunny_720p_surround.mp4", 634),
            new("https://archive.org/download/Sintel/sintel-2048-surround.mp4", 888),
            new("https://archive.org/download/Sintel/sintel-2048-surround_512kb.mp4", 888),
            new("https://archive.org/download/Sintel/sintel-2048-stereo.mp4", 888),
            new("https://archive.org/download/Sintel/sintel-2048-stereo_512kb.mp4", 888),
            new("https://archive.org/download/ElephantsDream/ed_1024_512kb.mp4", 654),
            new("https://archive.org/download/ElephantsDream/ed_1024.mp4", 654),
            new("https://archive.org/download/ElephantsDream/ed_hd.mp4", 654),
            new("https://archive.org/download/ElephantsDream/ed_hd_512kb.mp4", 654),
            new(Nasa(NasaEarthViews), 570)
        };
    }
}