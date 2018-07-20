using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_Customer : M_CustomerParent
    {
        [Display(Name = "Modified By")]
        [Required(ErrorMessage = "Required!")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified Date")]
        [Required(ErrorMessage = "Required!")]
        public DateTime ModifiedDate { get; set; }

        [Display(Name = "Template ID")]
        public string TemplateId { get; set; }

        [Display(Name = "Reject Reason Code")]
        public string RejectCode { get; set; }

        [Display(Name = "Product Details ")]
        [Required(ErrorMessage = "Required!")]
        public string ProductDetails { get; set; }

        [Display(Name = "Export Sector")]
        [Required(ErrorMessage = "Required!")]
        public string ExportSector { get; set; }

    }
}