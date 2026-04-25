using System.Reflection.Metadata;

namespace EduLab_MVC.Models.ViewModels
{
    public class BlogListViewModel
    {
        public List<Blog> Blogs { get; set; }
        public int CurrentPage { get; set; }
        public int TotalPages { get; set; }
    }
    public class Blog
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Summary { get; set; }
        public string Content { get; set; }
        public string Category { get; set; }
        public string ImageUrl { get; set; }
        public DateTime Date { get; set; }
        public string ReadTime { get; set; }
        public int Views { get; set; }
        public string AuthorName { get; set; }
        public string AuthorAvatarUrl { get; set; }
        public List<string> Tags { get; set; } = new List<string>();
    }
}
