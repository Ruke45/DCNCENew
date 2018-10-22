using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_InvoiceView : M_Customer
    {
        public string InvoiceNo { get; set; }
        public string InvoicedDate { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string IsTaxInvoice { get; set; }
        public string GrossTotal { get; set; }
        public string InvoiceTotal { get; set; }

        public List<M_InvoiceDetails> InvoiceBody = new List<M_InvoiceDetails>();
        public List<M_TaxNRates> InvoicTaxs = new List<M_TaxNRates>();
    }
}