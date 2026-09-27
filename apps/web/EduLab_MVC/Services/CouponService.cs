using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Coupon;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    public class CouponService : ICouponService
    {
        private readonly ILogger<CouponService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;

        public CouponService(
            ILogger<CouponService> logger,
            IAuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        public async Task<List<CouponDto>> GetAllAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync(ApiEndpoints.Coupon.Base, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<List<CouponDto>>(content) ?? new List<CouponDto>();
                }

                _logger.LogWarning("Failed to retrieve coupons from API. Status: {Status}", response.StatusCode);
                return new List<CouponDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting all coupons");
                return new List<CouponDto>();
            }
        }

        public async Task<CouponDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync(ApiEndpoints.Coupon.ById(id), cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<CouponDto>(content);
                }

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting coupon with ID {Id}", id);
                return null;
            }
        }

        public async Task<(bool Success, CouponDto? Data, string? ErrorMessage)> CreateAsync(CreateCouponDto dto, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(dto);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync(ApiEndpoints.Coupon.Base, content, cancellationToken);
                var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var coupon = JsonConvert.DeserializeObject<CouponDto>(responseContent);
                    return (true, coupon, null);
                }

                string errorMessage = "فشل إنشاء الرمز الترويجي";
                try
                {
                    var errorObj = JObject.Parse(responseContent);
                    if (errorObj["message"] != null)
                    {
                        errorMessage = errorObj["message"]!.ToString();
                    }
                }
                catch { }

                return (false, null, errorMessage);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating coupon");
                return (false, null, "حدث خطأ غير متوقع");
            }
        }

        public async Task<(bool Success, CouponDto? Data, string? ErrorMessage)> UpdateAsync(int id, UpdateCouponDto dto, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(dto);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PutAsync(ApiEndpoints.Coupon.ById(id), content, cancellationToken);
                var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var coupon = JsonConvert.DeserializeObject<CouponDto>(responseContent);
                    return (true, coupon, null);
                }

                string errorMessage = "فشل تعديل الرمز الترويجي";
                try
                {
                    var errorObj = JObject.Parse(responseContent);
                    if (errorObj["message"] != null)
                    {
                        errorMessage = errorObj["message"]!.ToString();
                    }
                }
                catch { }

                return (false, null, errorMessage);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating coupon ID {Id}", id);
                return (false, null, "حدث خطأ غير متوقع");
            }
        }

        public async Task<bool> DeleteAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync(ApiEndpoints.Coupon.ById(id), cancellationToken);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting coupon ID {Id}", id);
                return false;
            }
        }

        public async Task<bool> ToggleStatusAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PatchAsync(ApiEndpoints.Coupon.Toggle(id), null, cancellationToken);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error toggling coupon ID {Id}", id);
                return false;
            }
        }

        public async Task<ApplyCouponResultDto> ApplyCouponAsync(string code, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(new { code });
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync(ApiEndpoints.Coupon.Apply, content, cancellationToken);
                var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    return JsonConvert.DeserializeObject<ApplyCouponResultDto>(responseContent) ?? new ApplyCouponResultDto
                    {
                        Success = false,
                        Message = "تعذر قراءة استجابة الخادم"
                    };
                }

                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "تعذر تطبيق الرمز الترويجي"
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error applying coupon {Code}", code);
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "حدث خطأ أثناء تطبيق الرمز الترويجي"
                };
            }
        }

        public async Task<bool> RemoveCouponAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync(ApiEndpoints.Coupon.Remove, null, cancellationToken);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error removing coupon");
                return false;
            }
        }
    }
}
