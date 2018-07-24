using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_CustomerRequest : M_Customer
    {
        private string ParentCustomerId { get; set; }

        [Display(Name = "Parent Customer Id")]
        [Required(ErrorMessage = "Required!")]
        public string Parent_CustomerId
        {
            get { return ParentCustomerId; }
            set { ParentCustomerId = value; }
        }

        private string ParentCustomerName { get; set; }

        [Display(Name = "Parent Customer Name")]
        [Required(ErrorMessage = "Required!")]
        public string Parent_CustomerName
        {
            get { return ParentCustomerName; }
            set { ParentCustomerName = value; }
        }

        private string TemplateName { get; set; }

        [Display(Name = "Template Name")]
        [Required(ErrorMessage = "Required!")]
        public string Template_Name
        {
            get { return TemplateName; }
            set { TemplateName = value; }
        }

        private string TemplateID { get; set; }

        [Display(Name = "Template Id")]
        [Required(ErrorMessage = "Required!")]
        public string Template_ID
        {
            get { return TemplateID; }
            set { TemplateID = value; }
        }

        private string ExportSectorName { get; set; }

        [Display(Name = "Export Sector")]
        [Required(ErrorMessage = "Required!")]
        public string ExportSector_Name
        {
            get { return ExportSectorName; }
            set { ExportSectorName = value; }
        }
    }
}