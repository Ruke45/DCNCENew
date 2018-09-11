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
        [Required(ErrorMessage = "Required! ")]
        public string ParentID { get; set; }

        [Display(Name = "Client")]
        [Required(ErrorMessage = "Required! ")]
        public string CustomerID { get; set; }

        [Display(Name = "Rate")]
        [Required(ErrorMessage = "Required! ")]
        public string RateID { get; set; }

        [Display(Name = "Rate Name")]
        [Required(ErrorMessage = "Required! ")]
        public string RateName { get; set; }

        [Display(Name = "Rate Value")]
        [Required(ErrorMessage = "Required! ")]
        public decimal RateValue { get; set; }

        [Display(Name = "Pay Type")]
        [Required(ErrorMessage = "Required! ")]
        public string PayType { get; set; }
    }
}