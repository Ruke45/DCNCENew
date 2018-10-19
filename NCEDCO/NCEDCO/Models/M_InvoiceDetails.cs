using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_InvoiceDetails
    {
        string TemplateId;

        [Display(Name = "Certificate Templete")]
        public string Template_Id
        {
            get { return TemplateId; }
            set { TemplateId = value; }
        }

        string RequestId;
        [Display(Name = "Request ID")]
        public string Request_Id
        {
            get { return RequestId; }
            set { RequestId = value; }
        }

        string CertificateID;
        [Display(Name = "Certificate ID")]
        public string Certificate_ID
        {
            get { return CertificateID; }
            set { CertificateID = value; }
        }

        string CustomerId;
        [Display(Name = "Customer ID")]
        public string Customer_Id
        {
            get { return CustomerId; }
            set { CustomerId = value; }
        }
        string CreatedDate;
        [Display(Name = "Created Date")]
        public string Created_Date
        {
            get { return CreatedDate; }
            set { CreatedDate = value; }
        }
        string Status;
        [Display(Name = "Status")]
        public string Status_
        {
            get { return Status; }
            set { Status = value; }
        }
        string CustomerName;
        [Display(Name = "Customer Name")]
        public string Customer_Name
        {
            get { return CustomerName; }
            set { CustomerName = value; }
        }
        string Consignor;
        [Display(Name = "Consignor")]
        public string Consignor_
        {
            get { return Consignor; }
            set { Consignor = value; }
        }
        string Consignee;
        [Display(Name = "Consignee")]
        public string Consignee_
        {
            get { return Consignee; }
            set { Consignee = value; }
        }

        decimal Rate;
        [Display(Name = "Rate")]
        public decimal Rate_
        {
            get { return Rate; }
            set { Rate = value; }
        }

        string ParentId;
        [Display(Name = "Client/Parent")]
        public string Parent_Id
        {
            get { return ParentId; }
            set { ParentId = value; }
        }

        DateTime From;
        [Display(Name = "From")]
        public DateTime From_
        {
            get { return From; }
            set { From = value; }
        }

        DateTime To;
        [Display(Name = "To")]
        public DateTime To_
        {
            get { return To; }
            set { To = value; }
        }
        string IsSVAT;
        [Display(Name = "Is SVAT")]
        public string Is_SVAT
        {
            get { return IsSVAT; }
            set { IsSVAT = value; }
        }
    }
}