using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public class OperationKey
    {
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id { get; set; }
        public string Key { get; set; }
    }
}
