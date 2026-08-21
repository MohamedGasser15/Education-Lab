namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents the type of an audited operation
    /// </summary>
    public enum OperationType
    {
        Delete = 1,
        Create = 2,
        View = 3,
        Edit = 4,
        Print = 5,
        Publish = 6,
        Lock = 7,
        Unlock = 8,
        Approve = 9,
        Reject = 10,
        Login = 11
    }
}
