using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Templates
{
    public class M_Column_with_HS_code : M_Cerificate
    {
        [Display(Name = "Port Of Discharge")]
        [Required(ErrorMessage = "Required!")]
        public string PortOfDischarge { get; set; }

        [Display(Name = "Place Of Delivery")]
        [Required(ErrorMessage = "Required!")]
        public string PlaceOfDelivery { get; set; }


    }
}