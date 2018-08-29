using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_SupportDocumentUpload
    {
        [Display(Name = "Request ID")]
        public string RequestRefNo {get;set;}

        [Display(Name = "Doc ID")]
        public string SupportingDocumentID {get;set;}

        public string Remarks {get;set;}

        public string Status { get; set; }

        [Display(Name = "Upload Date")]
        public string UploadedDate {get;set;}

        [Display(Name = "Uploaded By")]
        public string UploadedBy {get;set;}

        public string UploadedPath {get;set;}

        [Display(Name = "Support Document")]
        public string DocumentName {get;set;}

         [Display(Name = "Signature Required")]
        public bool SignatureRequired { get; set; }

        [Display(Name="Client Id")]
        public string ClientId { get; set; }

        [Display(Name = "Parent Id")]
        public string ParentId { get; set; }

        [Display(Name = "Approved By")]
        public string ApprovedBy { get; set; }

        public string CertifiedDocPathe { get; set; }

        public string ExpiredOn { get; set; }

        [Display(Name = "Document Name")]
        public string DocumentTitle { get; set; }

        Int64 SeqNo;
        public Int64 Seq_No
        {
            get { return SeqNo; }
            set { SeqNo = value; }
        }


    }
}