using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Utility
{
    public class Navigation_Menu
    {
        public Navigation_Menu()
        {
            Items = new List<MenuItem>();
        }

        public List<MenuItem> Items;
    }

    public class MenuItem
    {
        public MenuItem()
        {
            this.ChildMenuItems = new List<MenuItem>();
        }

        public string Name { get; set; }

        public string Action { get; set; }
        public string Controller { get; set; }
        public string Link { get; set; }
        public Nullable<int> ParentItemId { get; set; }
        public bool IsParent { get; set; }
        public virtual ICollection<MenuItem> ChildMenuItems { get; set; }
    }
}