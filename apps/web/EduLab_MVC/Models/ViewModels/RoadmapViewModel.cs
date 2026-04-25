using System.Collections.Generic;

namespace EduLab_MVC.Models.ViewModels
{
    public class RoadmapViewModel
    {
        public string Id { get; set; }
        public string Title { get; set; }
        public string Subtitle { get; set; }
        public string Description { get; set; }
        public string HeroGradient { get; set; }
        public string ThemeColor { get; set; }
        public string BadgeText { get; set; }
        public List<RoadmapStep> Steps { get; set; }
    }

    public class RoadmapStep
    {
        public string Number { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Icon { get; set; }
        public List<string> Tags { get; set; }
        public string ColorClass { get; set; }
        public bool IsFinal { get; set; }
    }
}
