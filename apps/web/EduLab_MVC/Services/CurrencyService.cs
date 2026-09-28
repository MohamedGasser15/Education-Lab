using EduLab_MVC.Models;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net.Http;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    public class CurrencyService : ICurrencyService
    {
        public const string CurrencyCookieName = "EduLab.PreferredCurrency";
        private const string CacheKeyLiveRates = "EduLab_Live_Exchange_Rates_USD";
        private const string LiveApiUrl = "https://open.er-api.com/v6/latest/USD";

        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IMemoryCache _memoryCache;
        private readonly ILogger<CurrencyService> _logger;
        private static readonly Dictionary<string, CurrencyInfo> _currencies = InitializeDefaultCurrencies();
        private static readonly SemaphoreSlim _syncSemaphore = new(1, 1);
        private static DateTime? _lastLiveSyncUtc = null;
        private CurrencyInfo? _currentCurrencyCached;

        public CurrencyService(
            IHttpContextAccessor httpContextAccessor,
            IConfiguration configuration,
            IHttpClientFactory httpClientFactory,
            IMemoryCache memoryCache,
            ILogger<CurrencyService> logger)
        {
            _httpContextAccessor = httpContextAccessor;
            _configuration = configuration;
            _httpClientFactory = httpClientFactory;
            _memoryCache = memoryCache;
            _logger = logger;

            ApplyCachedRates();
        }

        private static Dictionary<string, CurrencyInfo> InitializeDefaultCurrencies()
        {
            return new Dictionary<string, CurrencyInfo>(StringComparer.OrdinalIgnoreCase)
            {
                // Global Base & Major Currencies
                ["USD"] = new CurrencyInfo { Code = "USD", Name = "US Dollar", NameAr = "دولار أمريكي", SymbolEn = "$", SymbolAr = "$", ExchangeRate = 1.0m, FlagEmoji = "🇺🇸", DecimalPlaces = 2 },
                ["EUR"] = new CurrencyInfo { Code = "EUR", Name = "Euro", NameAr = "يورو", SymbolEn = "€", SymbolAr = "€", ExchangeRate = 0.88m, FlagEmoji = "🇪🇺", DecimalPlaces = 2 },
                ["GBP"] = new CurrencyInfo { Code = "GBP", Name = "British Pound", NameAr = "جنيه إسترليني", SymbolEn = "£", SymbolAr = "£", ExchangeRate = 0.75m, FlagEmoji = "🇬🇧", DecimalPlaces = 2 },
                ["CAD"] = new CurrencyInfo { Code = "CAD", Name = "Canadian Dollar", NameAr = "دولار كندي", SymbolEn = "$", SymbolAr = "$", ExchangeRate = 1.36m, FlagEmoji = "🇨🇦", DecimalPlaces = 2 },
                ["AUD"] = new CurrencyInfo { Code = "AUD", Name = "Australian Dollar", NameAr = "دولار أسترالي", SymbolEn = "$", SymbolAr = "$", ExchangeRate = 1.50m, FlagEmoji = "🇦🇺", DecimalPlaces = 2 },
                ["CHF"] = new CurrencyInfo { Code = "CHF", Name = "Swiss Franc", NameAr = "فرنك سويسري", SymbolEn = "CHF", SymbolAr = "CHF", ExchangeRate = 0.85m, FlagEmoji = "🇨🇭", DecimalPlaces = 2 },
                ["JPY"] = new CurrencyInfo { Code = "JPY", Name = "Japanese Yen", NameAr = "ين ياباني", SymbolEn = "¥", SymbolAr = "¥", ExchangeRate = 145.0m, FlagEmoji = "🇯🇵", DecimalPlaces = 0 },
                ["CNY"] = new CurrencyInfo { Code = "CNY", Name = "Chinese Yuan", NameAr = "يوان صيني", SymbolEn = "¥", SymbolAr = "¥", ExchangeRate = 7.15m, FlagEmoji = "🇨🇳", DecimalPlaces = 2 },
                ["TRY"] = new CurrencyInfo { Code = "TRY", Name = "Turkish Lira", NameAr = "ليرة تركية", SymbolEn = "₺", SymbolAr = "₺", ExchangeRate = 34.0m, FlagEmoji = "🇹🇷", DecimalPlaces = 2 },
                ["INR"] = new CurrencyInfo { Code = "INR", Name = "Indian Rupee", NameAr = "روبية هندية", SymbolEn = "₹", SymbolAr = "₹", ExchangeRate = 83.5m, FlagEmoji = "🇮🇳", DecimalPlaces = 2 },
                ["BRL"] = new CurrencyInfo { Code = "BRL", Name = "Brazilian Real", NameAr = "ريال برازيلي", SymbolEn = "R$", SymbolAr = "R$", ExchangeRate = 5.50m, FlagEmoji = "🇧🇷", DecimalPlaces = 2 },
                ["RUB"] = new CurrencyInfo { Code = "RUB", Name = "Russian Ruble", NameAr = "روبل روسي", SymbolEn = "₽", SymbolAr = "₽", ExchangeRate = 92.0m, FlagEmoji = "🇷🇺", DecimalPlaces = 2 },
                ["KRW"] = new CurrencyInfo { Code = "KRW", Name = "South Korean Won", NameAr = "وون كوري", SymbolEn = "₩", SymbolAr = "₩", ExchangeRate = 1350m, FlagEmoji = "🇰🇷", DecimalPlaces = 0 },
                ["MYR"] = new CurrencyInfo { Code = "MYR", Name = "Malaysian Ringgit", NameAr = "رينغيت ماليزي", SymbolEn = "RM", SymbolAr = "RM", ExchangeRate = 4.30m, FlagEmoji = "🇲🇾", DecimalPlaces = 2 },
                ["IDR"] = new CurrencyInfo { Code = "IDR", Name = "Indonesian Rupiah", NameAr = "روبية إندونيسية", SymbolEn = "Rp", SymbolAr = "Rp", ExchangeRate = 15300m, FlagEmoji = "🇮🇩", DecimalPlaces = 0 },
                ["SEK"] = new CurrencyInfo { Code = "SEK", Name = "Swedish Krona", NameAr = "كرونة سويدية", SymbolEn = "kr", SymbolAr = "kr", ExchangeRate = 10.3m, FlagEmoji = "🇸🇪", DecimalPlaces = 2 },
                ["NOK"] = new CurrencyInfo { Code = "NOK", Name = "Norwegian Krone", NameAr = "كرونة نرويجية", SymbolEn = "kr", SymbolAr = "kr", ExchangeRate = 10.6m, FlagEmoji = "🇳🇴", DecimalPlaces = 2 },

                // Arab & Middle East Currencies
                ["EGP"] = new CurrencyInfo { Code = "EGP", Name = "Egyptian Pound", NameAr = "جنيه مصري", SymbolEn = "E£", SymbolAr = "ج.م", ExchangeRate = 51.50m, FlagEmoji = "🇪🇬", DecimalPlaces = 0 },
                ["SAR"] = new CurrencyInfo { Code = "SAR", Name = "Saudi Riyal", NameAr = "ريال سعودي", SymbolEn = "SR", SymbolAr = "ر.س", ExchangeRate = 3.75m, FlagEmoji = "🇸🇦", DecimalPlaces = 2 },
                ["AED"] = new CurrencyInfo { Code = "AED", Name = "UAE Dirham", NameAr = "درهم إماراتي", SymbolEn = "AED", SymbolAr = "د.إ", ExchangeRate = 3.67m, FlagEmoji = "🇦🇪", DecimalPlaces = 2 },
                ["KWD"] = new CurrencyInfo { Code = "KWD", Name = "Kuwaiti Dinar", NameAr = "دينار كويتي", SymbolEn = "KD", SymbolAr = "د.ك", ExchangeRate = 0.31m, FlagEmoji = "🇰🇼", DecimalPlaces = 3 },
                ["QAR"] = new CurrencyInfo { Code = "QAR", Name = "Qatari Riyal", NameAr = "ريال قطري", SymbolEn = "QR", SymbolAr = "ر.ق", ExchangeRate = 3.64m, FlagEmoji = "🇶🇦", DecimalPlaces = 2 },
                ["BHD"] = new CurrencyInfo { Code = "BHD", Name = "Bahraini Dinar", NameAr = "دينار بحريني", SymbolEn = "BD", SymbolAr = "د.ب", ExchangeRate = 0.38m, FlagEmoji = "🇧🇭", DecimalPlaces = 3 },
                ["OMR"] = new CurrencyInfo { Code = "OMR", Name = "Omani Rial", NameAr = "ريال عماني", SymbolEn = "OMR", SymbolAr = "ر.ع", ExchangeRate = 0.38m, FlagEmoji = "🇴🇲", DecimalPlaces = 3 },
                ["JOD"] = new CurrencyInfo { Code = "JOD", Name = "Jordanian Dinar", NameAr = "دينار أردني", SymbolEn = "JD", SymbolAr = "د.أ", ExchangeRate = 0.71m, FlagEmoji = "🇯🇴", DecimalPlaces = 2 },
                ["MAD"] = new CurrencyInfo { Code = "MAD", Name = "Moroccan Dirham", NameAr = "درهم مغربي", SymbolEn = "MAD", SymbolAr = "د.م", ExchangeRate = 9.80m, FlagEmoji = "🇲🇦", DecimalPlaces = 2 },
                ["DZD"] = new CurrencyInfo { Code = "DZD", Name = "Algerian Dinar", NameAr = "دينار جزائري", SymbolEn = "DZD", SymbolAr = "د.ج", ExchangeRate = 133m, FlagEmoji = "🇩🇿", DecimalPlaces = 0 },
                ["TND"] = new CurrencyInfo { Code = "TND", Name = "Tunisian Dinar", NameAr = "دينار تونسي", SymbolEn = "TND", SymbolAr = "د.ت", ExchangeRate = 3.08m, FlagEmoji = "🇹🇳", DecimalPlaces = 2 },
                ["LYD"] = new CurrencyInfo { Code = "LYD", Name = "Libyan Dinar", NameAr = "دينار ليبي", SymbolEn = "LYD", SymbolAr = "د.ل", ExchangeRate = 4.80m, FlagEmoji = "🇱🇾", DecimalPlaces = 2 },
                ["IQD"] = new CurrencyInfo { Code = "IQD", Name = "Iraqi Dinar", NameAr = "دينار عراقي", SymbolEn = "IQD", SymbolAr = "د.ع", ExchangeRate = 1310m, FlagEmoji = "🇮🇶", DecimalPlaces = 0 },
                ["LBP"] = new CurrencyInfo { Code = "LBP", Name = "Lebanese Pound", NameAr = "ليرة لبنانية", SymbolEn = "LBP", SymbolAr = "ل.ل", ExchangeRate = 89500m, FlagEmoji = "🇱🇧", DecimalPlaces = 0 },
                ["SDG"] = new CurrencyInfo { Code = "SDG", Name = "Sudanese Pound", NameAr = "جنيه سوداني", SymbolEn = "SDG", SymbolAr = "ج.س", ExchangeRate = 600m, FlagEmoji = "🇸🇩", DecimalPlaces = 0 }
            };
        }

        private void ApplyCachedRates()
        {
            if (_memoryCache.TryGetValue(CacheKeyLiveRates, out Dictionary<string, decimal>? cached) && cached != null)
            {
                lock (_currencies)
                {
                    foreach (var (code, rate) in cached)
                    {
                        if (_currencies.TryGetValue(code, out var cur))
                        {
                            cur.ExchangeRate = rate;
                            cur.IsLive = true;
                            cur.LastSyncTime = _lastLiveSyncUtc;
                        }
                    }
                }
            }
        }

        public async Task<Dictionary<string, decimal>> GetLiveRatesAsync()
        {
            if (_memoryCache.TryGetValue(CacheKeyLiveRates, out Dictionary<string, decimal>? cached) && cached != null)
            {
                return cached;
            }

            if (!await _syncSemaphore.WaitAsync(TimeSpan.FromSeconds(2)))
            {
                lock (_currencies)
                {
                    return _currencies.ToDictionary(k => k.Key, v => v.Value.ExchangeRate, StringComparer.OrdinalIgnoreCase);
                }
            }

            try
            {
                if (_memoryCache.TryGetValue(CacheKeyLiveRates, out Dictionary<string, decimal>? doubleCheck) && doubleCheck != null)
                {
                    return doubleCheck;
                }

                var client = _httpClientFactory.CreateClient();
                client.Timeout = TimeSpan.FromSeconds(5);
                var response = await client.GetAsync(LiveApiUrl);

                if (response.IsSuccessStatusCode)
                {
                    var jsonString = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonSerializer.Deserialize<LiveRatesApiResponse>(jsonString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

                    if (apiResponse?.Rates != null && apiResponse.Rates.Count > 0)
                    {
                        var freshRates = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase);

                        lock (_currencies)
                        {
                            foreach (var (code, cur) in _currencies)
                            {
                                if (code.Equals("USD", StringComparison.OrdinalIgnoreCase))
                                {
                                    freshRates["USD"] = 1.0m;
                                    cur.ExchangeRate = 1.0m;
                                    continue;
                                }

                                if (apiResponse.Rates.TryGetValue(code, out var liveRate) && liveRate > 0)
                                {
                                    var rounded = Math.Round(liveRate, 4);
                                    freshRates[code] = rounded;
                                    cur.ExchangeRate = rounded;
                                    cur.IsLive = true;
                                    cur.LastSyncTime = DateTime.UtcNow;
                                }
                                else
                                {
                                    freshRates[code] = cur.ExchangeRate;
                                }
                            }
                        }

                        _lastLiveSyncUtc = DateTime.UtcNow;
                        _memoryCache.Set(CacheKeyLiveRates, freshRates, TimeSpan.FromMinutes(45));
                        _logger.LogInformation("Successfully synced {Count} live currency rates from {Url}", freshRates.Count, LiveApiUrl);
                        return freshRates;
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Live exchange rate sync skipped. Using cached rates.");
            }
            finally
            {
                _syncSemaphore.Release();
            }

            lock (_currencies)
            {
                return _currencies.ToDictionary(k => k.Key, v => v.Value.ExchangeRate, StringComparer.OrdinalIgnoreCase);
            }
        }

        public DateTime? GetLastRatesSyncTime() => _lastLiveSyncUtc;

        public IReadOnlyList<CurrencyInfo> GetSupportedCurrencies()
        {
            if (!_memoryCache.TryGetValue(CacheKeyLiveRates, out _))
            {
                _ = Task.Run(GetLiveRatesAsync);
            }

            lock (_currencies)
            {
                return _currencies.Values.Select(c => new CurrencyInfo
                {
                    Code = c.Code,
                    Name = c.Name,
                    NameAr = c.NameAr,
                    SymbolEn = c.SymbolEn,
                    SymbolAr = c.SymbolAr,
                    ExchangeRate = c.ExchangeRate,
                    FlagEmoji = c.FlagEmoji,
                    DecimalPlaces = c.DecimalPlaces,
                    IsLive = c.IsLive,
                    LastSyncTime = _lastLiveSyncUtc
                }).ToList();
            }
        }

        public string GetCurrentCurrencyCode()
        {
            return GetCurrentCurrency().Code;
        }

        public CurrencyInfo GetCurrentCurrency()
        {
            if (_currentCurrencyCached != null)
            {
                return _currentCurrencyCached;
            }

            var context = _httpContextAccessor.HttpContext;
            string targetCode = "USD";

            if (context != null)
            {
                if (context.Request.Cookies.TryGetValue(CurrencyCookieName, out var cookieCurrency) &&
                    !string.IsNullOrWhiteSpace(cookieCurrency) &&
                    _currencies.ContainsKey(cookieCurrency.Trim()))
                {
                    targetCode = cookieCurrency.Trim().ToUpperInvariant();
                }
                else
                {
                    var countryCode = context.Request.Headers["CF-IPCountry"].FirstOrDefault()
                                   ?? context.Request.Headers["X-Country-Code"].FirstOrDefault()
                                   ?? context.Request.Headers["CloudFront-Viewer-Country"].FirstOrDefault();

                    if (!string.IsNullOrWhiteSpace(countryCode))
                    {
                        var geo = MapCountryToCurrency(countryCode.Trim());
                        if (geo != null && _currencies.ContainsKey(geo))
                        {
                            targetCode = geo;
                        }
                    }
                    else
                    {
                        var currentCulture = CultureInfo.CurrentUICulture.Name;
                        var cultureCurrency = MapCultureToCurrency(currentCulture);
                        if (cultureCurrency != null && _currencies.ContainsKey(cultureCurrency))
                        {
                            targetCode = cultureCurrency;
                        }
                    }
                }
            }

            lock (_currencies)
            {
                if (_currencies.TryGetValue(targetCode, out var info))
                {
                    _currentCurrencyCached = info;
                    return info;
                }
                _currentCurrencyCached = _currencies["USD"];
                return _currentCurrencyCached;
            }
        }

        public decimal ConvertFromUsd(decimal usdAmount, string? targetCurrencyCode = null)
        {
            var target = string.IsNullOrWhiteSpace(targetCurrencyCode)
                ? GetCurrentCurrency()
                : (_currencies.TryGetValue(targetCurrencyCode, out var c) ? c : GetCurrentCurrency());

            return Math.Round(usdAmount * target.ExchangeRate, target.DecimalPlaces, MidpointRounding.AwayFromZero);
        }

        public decimal ConvertToUsd(decimal amount, string sourceCurrencyCode)
        {
            if (string.IsNullOrWhiteSpace(sourceCurrencyCode) ||
                !_currencies.TryGetValue(sourceCurrencyCode, out var source) ||
                source.ExchangeRate <= 0)
            {
                return amount;
            }

            return Math.Round(amount / source.ExchangeRate, 2, MidpointRounding.AwayFromZero);
        }

        public string FormatPrice(decimal usdAmount, string? targetCurrencyCode = null, bool? isArabic = null)
        {
            var target = string.IsNullOrWhiteSpace(targetCurrencyCode)
                ? GetCurrentCurrency()
                : (_currencies.TryGetValue(targetCurrencyCode, out var c) ? c : GetCurrentCurrency());

            bool arabic = isArabic ?? CultureInfo.CurrentUICulture.Name.StartsWith("ar", StringComparison.OrdinalIgnoreCase);
            decimal converted = ConvertFromUsd(usdAmount, target.Code);

            string formatPattern = target.DecimalPlaces == 0 ? "N0" : $"N{target.DecimalPlaces}";
            string formattedNumber = converted.ToString(formatPattern, CultureInfo.InvariantCulture);
            string symbol = target.GetSymbol(arabic);

            // Clean, standard positioning:
            if (target.Code == "USD" && !arabic)
            {
                return $"${formattedNumber}";
            }
            if (target.Code == "EUR" && !arabic)
            {
                return $"€{formattedNumber}";
            }
            if (target.Code == "GBP" && !arabic)
            {
                return $"£{formattedNumber}";
            }

            return $"{formattedNumber} {symbol}";
        }

        public void SetPreferredCurrency(string currencyCode)
        {
            if (string.IsNullOrWhiteSpace(currencyCode) || !_currencies.ContainsKey(currencyCode))
            {
                return;
            }

            _currentCurrencyCached = null;

            var context = _httpContextAccessor.HttpContext;
            if (context != null)
            {
                context.Response.Cookies.Append(CurrencyCookieName, currencyCode.ToUpperInvariant(), new CookieOptions
                {
                    Expires = DateTimeOffset.UtcNow.AddYears(1),
                    IsEssential = true,
                    SameSite = SameSiteMode.Lax,
                    HttpOnly = false
                });
            }
        }

        private static string? MapCountryToCurrency(string countryCode)
        {
            return countryCode.ToUpperInvariant() switch
            {
                "EG" => "EGP",
                "SA" => "SAR",
                "AE" => "AED",
                "KW" => "KWD",
                "QA" => "QAR",
                "BH" => "BHD",
                "OM" => "OMR",
                "JO" => "JOD",
                "MA" => "MAD",
                "DZ" => "DZD",
                "TN" => "TND",
                "LY" => "LYD",
                "IQ" => "IQD",
                "LB" => "LBP",
                "SD" => "SDG",
                "GB" => "GBP",
                "US" => "USD",
                "CA" => "CAD",
                "AU" => "AUD",
                "CH" => "CHF",
                "JP" => "JPY",
                "CN" => "CNY",
                "TR" => "TRY",
                "IN" => "INR",
                "BR" => "BRL",
                "RU" => "RUB",
                "KR" => "KRW",
                "MY" => "MYR",
                "ID" => "IDR",
                "SE" => "SEK",
                "NO" => "NOK",
                "DE" or "FR" or "IT" or "ES" or "NL" or "BE" or "AT" or "IE" or "PT" or "GR" or "FI" => "EUR",
                _ => null
            };
        }

        private static string? MapCultureToCurrency(string cultureName)
        {
            if (string.IsNullOrWhiteSpace(cultureName)) return null;

            if (cultureName.EndsWith("-EG", StringComparison.OrdinalIgnoreCase)) return "EGP";
            if (cultureName.EndsWith("-SA", StringComparison.OrdinalIgnoreCase)) return "SAR";
            if (cultureName.EndsWith("-AE", StringComparison.OrdinalIgnoreCase)) return "AED";
            if (cultureName.EndsWith("-KW", StringComparison.OrdinalIgnoreCase)) return "KWD";
            if (cultureName.EndsWith("-QA", StringComparison.OrdinalIgnoreCase)) return "QAR";
            if (cultureName.EndsWith("-BH", StringComparison.OrdinalIgnoreCase)) return "BHD";
            if (cultureName.EndsWith("-OM", StringComparison.OrdinalIgnoreCase)) return "OMR";
            if (cultureName.EndsWith("-JO", StringComparison.OrdinalIgnoreCase)) return "JOD";
            if (cultureName.EndsWith("-MA", StringComparison.OrdinalIgnoreCase)) return "MAD";
            if (cultureName.EndsWith("-DZ", StringComparison.OrdinalIgnoreCase)) return "DZD";
            if (cultureName.EndsWith("-TN", StringComparison.OrdinalIgnoreCase)) return "TND";
            if (cultureName.EndsWith("-GB", StringComparison.OrdinalIgnoreCase)) return "GBP";
            if (cultureName.EndsWith("-US", StringComparison.OrdinalIgnoreCase)) return "USD";
            if (cultureName.EndsWith("-CA", StringComparison.OrdinalIgnoreCase)) return "CAD";
            if (cultureName.EndsWith("-AU", StringComparison.OrdinalIgnoreCase)) return "AUD";
            if (cultureName.EndsWith("-TR", StringComparison.OrdinalIgnoreCase)) return "TRY";
            if (cultureName.EndsWith("-IN", StringComparison.OrdinalIgnoreCase)) return "INR";
            if (cultureName.EndsWith("-JP", StringComparison.OrdinalIgnoreCase)) return "JPY";

            return null;
        }

        private class LiveRatesApiResponse
        {
            [JsonPropertyName("result")]
            public string? Result { get; set; }

            [JsonPropertyName("base_code")]
            public string? BaseCode { get; set; }

            [JsonPropertyName("rates")]
            public Dictionary<string, decimal>? Rates { get; set; }
        }
    }
}
