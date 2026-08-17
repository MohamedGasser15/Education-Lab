using SkiaSharp;
using Svg.Skia.TypefaceProviders;
using System;
using System.Collections.Concurrent;
using System.IO;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Resolves the 'Cairo' and 'Inter' font families to the bundled static TTF files
    /// so certificates render with the exact design fonts on any server (no OS font dependency).
    /// </summary>
    public class CertificateTypefaceProvider : ITypefaceProvider
    {
        private static readonly ConcurrentDictionary<string, SKTypeface> Cache = new(StringComparer.OrdinalIgnoreCase);

        private readonly string _fontsPath;

        public CertificateTypefaceProvider(string fontsPath)
        {
            _fontsPath = fontsPath;
        }

        public SKTypeface FromFamilyName(string fontFamily, SKFontStyleWeight fontWeight, SKFontStyleWidth fontWidth, SKFontStyleSlant fontStyle)
        {
            return Resolve(fontFamily?.Trim('\'', '"') ?? string.Empty, (int)fontWeight, _fontsPath);
        }

        /// <summary>
        /// Resolves a family + weight to the bundled static TTF (cached). Null if the family is not handled.
        /// </summary>
        public static SKTypeface Resolve(string family, int weight, string fontsPath)
        {
            return ResolveWithSource(family, weight, fontsPath).Typeface;
        }

        /// <summary>
        /// Resolves a family + weight to the bundled static TTF and the file actually used.
        /// When the requested file is missing, unreadable, or contains a different family than expected
        /// (e.g. a broken or misnamed upload on a server), it falls back to the bundled Cairo-Bold.ttf
        /// (covers Arabic + Latin) and finally to the OS default typeface.
        /// </summary>
        public static (SKTypeface Typeface, string Path) ResolveWithSource(string family, int weight, string fontsPath)
        {
            var fileName = GetFontFileName(family, weight);
            if (!string.IsNullOrEmpty(fileName))
            {
                var path = Path.Combine(fontsPath, fileName);
                if (File.Exists(path))
                {
                    var typeface = LoadCached(path);
                    if (typeface != null && MatchesFamily(typeface, family))
                        return (typeface, path);
                }
            }

            var fallbackPath = Path.Combine(fontsPath, "Cairo-Bold.ttf");
            if (File.Exists(fallbackPath))
            {
                var typeface = LoadCached(fallbackPath);
                if (typeface != null)
                    return (typeface, fallbackPath);
            }

            return (SKTypeface.Default, null);
        }

        private static SKTypeface LoadCached(string path)
        {
            return Cache.GetOrAdd(path, p =>
            {
                try
                {
                    return SKTypeface.FromStream(new SKFileStream(p));
                }
                catch
                {
                    return null;
                }
            });
        }

        private static bool MatchesFamily(SKTypeface typeface, string family)
        {
            var name = typeface.FamilyName ?? string.Empty;
            return name.Contains(family, StringComparison.OrdinalIgnoreCase);
        }

        public static string GetFontFileName(string family, int weight)
        {
            if (family.Equals("Cairo", StringComparison.OrdinalIgnoreCase))
            {
                if (weight <= 500) return "Cairo-Regular.ttf";
                if (weight == 600) return "Cairo-SemiBold.ttf";
                if (weight == 700) return "Cairo-Bold.ttf";
                return "Cairo-ExtraBold.ttf";
            }

            if (family.Equals("Inter", StringComparison.OrdinalIgnoreCase))
            {
                if (weight >= 700) return "Inter-700.ttf";
                return "Inter-600.ttf";
            }

            return null;
        }
    }
}
