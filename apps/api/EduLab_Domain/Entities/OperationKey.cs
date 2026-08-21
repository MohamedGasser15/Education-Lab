using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents a localization key for an audited operation
    /// </summary>
    public class OperationKey
    {
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id { get; set; }
        public string Key { get; set; }
    }
}
