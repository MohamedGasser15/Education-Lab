namespace EduLab_MVC.Models.DTOs.Cart
{
    /// <summary>
    /// DTO for cart summary
    /// </summary>
    public class CartSummaryDto
    {
        /// <summary>
        /// Gets or sets the total number of items in the cart
        /// </summary>
        public int TotalItems { get; set; }

        /// <summary>
        /// Gets or sets the total price of all items in the cart
        /// </summary>
        public decimal TotalPrice { get; set; }
    }
}
