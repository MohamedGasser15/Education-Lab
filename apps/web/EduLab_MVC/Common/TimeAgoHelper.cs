using System;
using System.Globalization;
using System.Resources;
using EduLab_MVC.Resources;

namespace EduLab_MVC.Common
{
    /// <summary>
    /// Generates localized "time ago" strings based on the current UI culture.
    /// </summary>
    public static class TimeAgoHelper
    {
        private static readonly ResourceManager _rm =
            new ResourceManager("EduLab_MVC.Resources.SharedResources", typeof(SharedResources).Assembly);

        public static string GetTimeAgo(DateTime dateTime)
        {
            var culture = CultureInfo.CurrentUICulture;
            var timeSpan = DateTime.UtcNow - dateTime;

            if (timeSpan.TotalDays >= 30)
            {
                var months = (int)(timeSpan.TotalDays / 30);
                return months == 1
                    ? _rm.GetString("TimeAgoMonth", culture)
                    : string.Format(culture, _rm.GetString("TimeAgoMonths", culture) ?? "{0} months ago", months);
            }
            else if (timeSpan.TotalDays >= 1)
            {
                var days = (int)timeSpan.TotalDays;
                return days == 1
                    ? _rm.GetString("TimeAgoDay", culture)
                    : string.Format(culture, _rm.GetString("TimeAgoDays", culture) ?? "{0} days ago", days);
            }
            else if (timeSpan.TotalHours >= 1)
            {
                var hours = (int)timeSpan.TotalHours;
                return hours == 1
                    ? _rm.GetString("TimeAgoHour", culture)
                    : string.Format(culture, _rm.GetString("TimeAgoHours", culture) ?? "{0} hours ago", hours);
            }
            else if (timeSpan.TotalMinutes >= 1)
            {
                var minutes = (int)timeSpan.TotalMinutes;
                return minutes == 1
                    ? _rm.GetString("TimeAgoMinute", culture)
                    : string.Format(culture, _rm.GetString("TimeAgoMinutes", culture) ?? "{0} minutes ago", minutes);
            }
            else
            {
                return _rm.GetString("TimeAgoNow", culture) ?? "Now";
            }
        }
    }
}
