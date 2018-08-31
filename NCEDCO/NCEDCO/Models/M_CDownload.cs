using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_CDownload
    {
        [Display(Name = "Req ID")]
        public string RequestID { get; set; }

        [Display(Name = "Req By")]
        public string RequestBy { get; set; }

        [Display(Name = "Req Date")]
        public string RequestDate { get; set; }

        [Display(Name = "Approv Date")]
        public string ApproveDate { get; set; }

        [Display(Name = "Ref No")]
        public string RefNo { get; set; }

        [Display(Name = "Client Name")]
        public string ClientName { get; set; }

        [Display(Name = "Invoice No")]
        public string InvoiceNo { get; set; }

        [Display(Name = "Printed")]
        public string IsPrinted { get; set; }

        [Display(Name = "Stamped")]
        public string IsStamped { get; set; }

        [Display(Name = "Approv By")]
        public string ApprovedBy { get; set; }

        [Display(Name = "C Type")]
        public string ReqType { get; set; }

        [Display(Name = "Downloaded")]
        public string IsDownloaded { get; set; }

        [Display(Name = "Certificate Path")]
        public string CertPath { get; set; }

        [Display(Name = "Parent Name")]
        public string ParentN { get; set; }

    }
}