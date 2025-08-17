using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.Utitlites
{
    public static class RoleExtensions
    {
        public static DateTime GetCreationTime(this string roleId)
        {
            if (Guid.TryParse(roleId, out var guid))
            {
                var bytes = guid.ToByteArray();
                var dateBytes = new byte[8];
                Array.Copy(bytes, dateBytes, 8);
                var ticks = BitConverter.ToInt64(dateBytes, 0);

                if (ticks >= DateTime.MinValue.Ticks && ticks <= DateTime.MaxValue.Ticks)
                {
                    return new DateTime(ticks);
                }
            }

            return DateTime.Now; // fallback آمن لو Ticks خارج المدى
        }

    }
}
