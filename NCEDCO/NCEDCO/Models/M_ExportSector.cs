using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_ExportSector
    {
        [Display(Name = "Export Sector Id")]
        [Required(ErrorMessage = "Required!")]
        public string ExportSectorId { get; set; }

        [Display(Name = "Export Sector Name")]
        [Required(ErrorMessage = "Required!")]
        public string ExportSectorName { get; set; }

        [Display(Name = "Active")]
        [Required(ErrorMessage = "Required!")]
        public string IsActive { get; set; }
    }
}