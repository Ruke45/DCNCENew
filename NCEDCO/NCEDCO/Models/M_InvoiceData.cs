using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_InvoiceData
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string CustomerId { get; set; }
        public string Start { get; set; }
        public string End { get; set; }
        public string Status { get; set; }
        public string SupportingDocStatus { get; set; }
        public string CertificateRateId { get; set; }
        public string SupDocCertificateRateId { get; set; }
        public string InvoiceRateId { get; set; }
        public string OtherRateId { get; set; }
        public string SupDocOtherRateId { get; set; }
        public string SupDocInvoiceRateId { get; set; }
        public string AttachSheetId { get; set; }
        public decimal Rate { get; set; }
        public decimal GrossTotal { get; set; }
        public string invoiceNo { get; set; }
    }
}