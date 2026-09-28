using EduLab_MVC.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface ICurrencyService
    {
        CurrencyInfo GetCurrentCurrency();
        string GetCurrentCurrencyCode();
        decimal ConvertFromUsd(decimal usdAmount, string? targetCurrencyCode = null);
        decimal ConvertToUsd(decimal amount, string sourceCurrencyCode);
        string FormatPrice(decimal usdAmount, string? targetCurrencyCode = null, bool? isArabic = null);
        IReadOnlyList<CurrencyInfo> GetSupportedCurrencies();
        void SetPreferredCurrency(string currencyCode);
        Task<Dictionary<string, decimal>> GetLiveRatesAsync();
        DateTime? GetLastRatesSyncTime();
    }
}
