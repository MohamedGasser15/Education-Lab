using System;
using System.Collections.Generic;

namespace EduLab_Application.DTOs.Dashboard
{
    public class RevenueTransactionDto
    {
        public string StudentName { get; set; }
        public string CourseTitle { get; set; }
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public string Status { get; set; }
    }

    public class RevenueTopCourseDto
    {
        public string CourseTitle { get; set; }
        public int Students { get; set; }
        public decimal Revenue { get; set; }
    }

    public class RevenuePaymentDto
    {
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
    }

    public class InstructorRevenueDto
    {
        public decimal TotalRevenue { get; set; }
        public double RevenueChangePercent { get; set; }

        public int TotalSales { get; set; }
        public double SalesChangePercent { get; set; }

        public decimal AvgCoursePrice { get; set; }

        public int NewStudents { get; set; }
        public double NewStudentsChangePercent { get; set; }

        public List<decimal> MonthlyRevenueSeries { get; set; } = new List<decimal>();
        public List<int> MonthlySalesSeries { get; set; } = new List<int>();

        public List<RevenueTopCourseDto> TopCourses { get; set; } = new List<RevenueTopCourseDto>();

        public List<RevenueTransactionDto> RecentTransactions { get; set; } = new List<RevenueTransactionDto>();

        public decimal PayoutDue { get; set; }
        public decimal PayoutPending { get; set; }
        public List<RevenuePaymentDto> LastPayments { get; set; } = new List<RevenuePaymentDto>();
    }
}
