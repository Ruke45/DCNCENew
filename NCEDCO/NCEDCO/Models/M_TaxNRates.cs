using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_TaxNRates
    {
        [Display(Name = "Client's Parent")]
        [Required(ErrorMessage = "Customer Name is Required! ")]
        public string ParentID { get; set; }

        [Display(Name = "Client")]
        [Required(ErrorMessage = "Customer Name is Required! ")]
        public string CustomerID { get; set; }

        [Display(Name = "Rate")]
        [Required(ErrorMessage = "Customer Name is Required! ")]
        public string RateID { get; set; }

    }
}