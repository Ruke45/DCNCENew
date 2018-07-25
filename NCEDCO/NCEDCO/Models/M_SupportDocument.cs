using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_SupportDocument
    {
        String UserId;

        public string User_Id
        {
            get { return UserId; }
            set { UserId = value; }
        }

        String SupportingDocumentId;
        [Display(Name = "Supporting Document Id")]
        [Required(ErrorMessage = "Required!")]
        public string SupportingDocument_Id
        {
            get { return SupportingDocumentId; }
            set { SupportingDocumentId = value; }
        }

        String SupportingDocumentName;
        [Display(Name = "Supporting Document Name")]
        [Required(ErrorMessage = "Required!")]
        public string SupportingDocument_Name
        {
            get { return SupportingDocumentName; }
            set { SupportingDocumentName = value; }
        }


        String CreatedBy;
        [Display(Name = "Created By")]
        public string Created_By
        {
            get { return CreatedBy; }
            set { CreatedBy = value; }
        }

        DateTime CreatedDate;
        [Display(Name = "Created Date")]
        public DateTime Created_Date
        {
            get { return CreatedDate; }
            set { CreatedDate = value; }
        }

        String IsActive;
        [Display(Name = "Is Active")]
        [Required(ErrorMessage = "Required!")]
        public string Is_Active
        {
            get { return IsActive; }
            set { IsActive = value; }
        }

        String ModifiedBy;
        [Display(Name = "Modified By")]
        public string Modified_By
        {
            get { return ModifiedBy; }
            set { ModifiedBy = value; }
        }

        String RequestID;

        public string Request_ID
        {
            get { return RequestID; }
            set { RequestID = value; }
        }

        String DownloadPath;

        public string Download_Path
        {
            get { return DownloadPath; }
            set { DownloadPath = value; }
        }
        String Status;

        public string Status_
        {
            get { return Status; }
            set { Status = value; }
        }
        string IsDownloaded;
        public string Is_Downloaded
        {
            get { return IsDownloaded; }
            set { IsDownloaded = value; }
        }
        string RequestBy;
        public string Request_By
        {
            get { return RequestBy; }
            set { RequestBy = value; }
        }

        string ApprovedDate;
        public string Approved_Date
        {
            get { return ApprovedDate; }
            set { ApprovedDate = value; }
        }

        string ApprovedBY;
        public string Approved_BY
        {
            get { return ApprovedBY; }
            set { ApprovedBY = value; }
        }


        string Consignor;
        public string Consignor_
        {
            get { return Consignor; }
            set { Consignor = value; }
        }
        string Consignee;
        public string Consignee_
        {
            get { return Consignee; }
            set { Consignee = value; }
        }
        string RequestDate;
        public string Request_Date
        {
            get { return RequestDate; }
            set { RequestDate = value; }
        }

        string CertificateRequestId;
        public string Certificate_RequestId
        {
            get { return CertificateRequestId; }
            set { CertificateRequestId = value; }
        }
    }
}