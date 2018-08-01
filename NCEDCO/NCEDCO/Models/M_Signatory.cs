using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_Signatory : M_Users
    {
        
        private HttpPostedFileBase SignaturePath { get; set; }
        [Display(Name = "Signatrue PFX Path")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.Upload)]
        public HttpPostedFileBase Signature_Path
        {
            get { return SignaturePath; }
            set { SignaturePath = value; }
        }

        private HttpPostedFileBase SingatureImg { get; set; }
        [Display(Name = "Signatrue Image Path")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.Upload)]
        public HttpPostedFileBase Singature_Img
        {
            get { return SingatureImg; }
            set { SingatureImg = value; }
        }
    }
}