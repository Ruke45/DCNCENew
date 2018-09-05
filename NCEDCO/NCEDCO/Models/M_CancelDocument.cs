using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_CancelDocument
    {
        [Display(Name = "From")]
        [Required(ErrorMessage = "Required!")]
        public DateTime From { get; set; }

        [Display(Name = "To")]
        [Required(ErrorMessage = "Required!")]
        public DateTime To { get; set; }

        [Display(Name = "Ref No")]
        [Required(ErrorMessage = "Required!")]
        public string Ref_No { get; set; }

        [Display(Name = "Client")]
        [Required(ErrorMessage = "Required!")]
        public string Client { get; set; }

        [Display(Name = "Parent Customer")]
        [Required(ErrorMessage = "Required!")]
        public string Parent { get; set; }

        [Display(Name = "Approve Date")]
        [Required(ErrorMessage = "Required!")]
        public string ApprovedDate { get; set; }

        [Display(Name = "Doc Type")]
        [Required(ErrorMessage = "Required!")]
        public string Dtype { get; set; }

        [Display(Name = "Invoice No")]
        [Required(ErrorMessage = "Required!")]
        public string InvoicNo { get; set; }

    }
}