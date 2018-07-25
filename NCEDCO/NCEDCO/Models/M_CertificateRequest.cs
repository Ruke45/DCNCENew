using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_CertificateRequest
    {
        string RequestID;
        [Display(Name = "Request ID")]
        [Required(ErrorMessage = "Customer Name is Required! ")]
        public string Request_ID
        {
            get { return RequestID; }
            set { RequestID = value; }
        }

        
        string CustomerID;
        [Display(Name = "Client ID")]
        [Required(ErrorMessage = "Customer ID is Required! ")]
        public string Customer_ID
        {
            get { return CustomerID; }
            set { CustomerID = value; }
        }

        string CustomerName;
        [Display(Name = "Client Name")]
        [Required(ErrorMessage = "Client Name is Required! ")]
        public string Customer_Name
        {
            get { return CustomerName; }
            set { CustomerName = value; }
        }

        DateTime RecivedDate;

        public DateTime Recived_Date
        {
            get { return RecivedDate; }
            set { RecivedDate = value; }
        }
        int NoOfAttachmments;

        public int No_Of_Attachmments
        {
            get { return NoOfAttachmments; }
            set { NoOfAttachmments = value; }
        }

        string Status;

        public string Status_
        {
            get { return Status; }
            set { Status = value; }
        }

        DateTime CreatedDate;
        [Display(Name = "Created Date")]
        public DateTime Created_Date
        {
            get { return CreatedDate; }
            set { CreatedDate = value; }
        }

        DateTime ModifiedDate;
        [Display(Name = "Modified Date")]
        public DateTime Modified_Date
        {
            get { return ModifiedDate; }
            set { ModifiedDate = value; }
        }
        string CreatedBy;
        [Display(Name = "Created By")]
        public string Created_By
        {
            get { return CreatedBy; }
            set { CreatedBy = value; }
        }

        string ModifiedBy;
        [Display(Name = "Modified By")]
        public string Modified_By
        {
            get { return ModifiedBy; }
            set { ModifiedBy = value; }
        }
        string IndexNo; //For Ignored Emails.

        public string Index_No
        {
            get { return IndexNo; }
            set { IndexNo = value; }
        }

        string UploadPath;

        public string Upload_Path
        {
            get { return UploadPath; }
            set { UploadPath = value; }
        }

        string InvoiceNo;
        [Display(Name = "Invoice No")]
        [Required(ErrorMessage = "Invoice No is Required! ")]
        public string Invoice_No
        {
            get { return InvoiceNo; }
            set { InvoiceNo = value; }
        }

        string SealRequired;
        [Display(Name = "Seal is Required")]
        public string Seal_Required
        {
            get { return SealRequired; }
            set { SealRequired = value; }
        }

        public M_CertificateRequest() {}

        public M_CertificateRequest(DateTime ReciveDate, string ReqNo, string CID, string CName)
        {
            this.Customer_ID = CID;
            this.Customer_Name = CName;
            this.Recived_Date = ReciveDate;
            this.Request_ID = ReqNo;
        }

        public M_CertificateRequest(string RequestId, string CustomerId, string CustomerName, DateTime RequestDate,
            string Status, DateTime CreatedDate, string CreatedBy)
        {
            this.Request_ID = RequestId;
            this.Customer_ID = CustomerId;
            this.Customer_Name = CustomerName;
            this.Recived_Date = RequestDate;
            this.Status_ = Status;
            this.Created_Date = CreatedDate;
            this.Created_By = CreatedBy;
        }// For Upload Based Certificate Requests
    }
}