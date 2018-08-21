using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_SupportDocumentUpload
    {
        public string RequestRefNo {get;set;}
        public string SupportingDocumentID {get;set;}
        public string Remarks {get;set;}
        public string Status { get; set; }
        public string UploadedDate {get;set;}
        public string UploadedBy {get;set;}
        public string UploadedPath {get;set;}
        [Display(Name = "Support Document")]
        public string DocumentName {get;set;}

        public bool SignatureRequired { get; set; }
        [Display(Name="Client Id")]
        public string ClientId { get; set; }

        public string ApprovedBy { get; set; }
        public string CertifiedDocPathe { get; set; }
        public string ExpiredOn { get; set; }
        public string DocumentTitle { get; set; }
        Int64 SeqNo;
        public Int64 Seq_No
        {
            get { return SeqNo; }
            set { SeqNo = value; }
        }


    }
}