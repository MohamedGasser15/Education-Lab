using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.Utitlites.Attributes
{
    public class CustomPasswordAttribute : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var password = value as string;

            if (string.IsNullOrWhiteSpace(password))
                return new ValidationResult("كلمة المرور مطلوبة");

            if (password.Length < 8)
                return new ValidationResult("كلمة المرور يجب أن تكون 8 أحرف أو أكثر");

            if (!password.Any(char.IsUpper))
                return new ValidationResult("كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل");

            if (!password.Any(char.IsDigit))
                return new ValidationResult("كلمة المرور يجب أن تحتوي على رقم واحد على الأقل");

            return ValidationResult.Success;
        }
    }
}
