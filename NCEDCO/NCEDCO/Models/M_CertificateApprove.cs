using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_CertificateApprove
    {
        string RequestId;
        [Display(Name = "Request Ic")]
        public string Request_Id
        {
            get { return RequestId; }
            set { RequestId = value; }
        }

        string CertificateId;
        [Display(Name = "Certificate Id/Reff")]
        public string Certificate_Id
        {
            get { return CertificateId; }
            set { CertificateId = value; }
        }
        DateTime CreatedDate;
        [Display(Name = "Issued Date")]
        public DateTime Created_Date
        {
            get { return CreatedDate; }
            set { CreatedDate = value; }
        }
        DateTime ExpiryDate;
        [Display(Name = "Expire On")]
        public DateTime Expiry_Date
        {
            get { return ExpiryDate; }
            set { ExpiryDate = value; }
        }
        string CreatedBy;
        [Display(Name = "Issued By")]
        public string Created_By
        {
            get { return CreatedBy; }
            set { CreatedBy = value; }
        }
        string IsDownloaded;
        [Display(Name = "Is Downloaded")]
        public string Is_Downloaded
        {
            get { return IsDownloaded; }
            set { IsDownloaded = value; }
        }
        string CertificatePath;
        public string Certificate_Path
        {
            get { return CertificatePath; }
            set { CertificatePath = value; }
        }
        string CertificateName;
        [Display(Name = "Certificate Name")]
        public string Certificate_Name
        {
            get { return CertificateName; }
            set { CertificateName = value; }
        }
        string IsValid;
        [Display(Name = "Is Valid")]
        public string Is_Valid
        {
            get { return IsValid; }
            set { IsValid = value; }
        }
    }
}