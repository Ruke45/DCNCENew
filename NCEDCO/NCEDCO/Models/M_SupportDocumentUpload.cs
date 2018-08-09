using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_SupportDocumentUpload
    {
        public string RequestRefNo {get;set;}
        public string SupportingDocumentID {get;set;}
        public string Remarks {get;set;}
        public string UploadedDate {get;set;}
        public string UploadedBy {get;set;}
        public string UploadedPath {get;set;}
        public string DocumentName {get;set;}
        public bool SignatureRequired { get; set; }
    }
}