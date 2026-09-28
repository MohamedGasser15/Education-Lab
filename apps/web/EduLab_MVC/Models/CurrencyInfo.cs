namespace EduLab_MVC.Models
{
    public class CurrencyInfo
    {
        public string Code { get; set; } = "USD";
        public string Name { get; set; } = "US Dollar";
        public string NameAr { get; set; } = "دولار أمريكي";
        public string SymbolEn { get; set; } = "$";
        public string SymbolAr { get; set; } = "$";
        public decimal ExchangeRate { get; set; } = 1.0m;
        public string FlagEmoji { get; set; } = "🇺🇸";
        public int DecimalPlaces { get; set; } = 2;
        public bool IsLive { get; set; } = true;
        public DateTime? LastSyncTime { get; set; }

        public string GetSymbol(bool isArabic) => isArabic ? SymbolAr : SymbolEn;
        public string GetDisplayName(bool isArabic) => isArabic ? NameAr : Name;
    }
}
