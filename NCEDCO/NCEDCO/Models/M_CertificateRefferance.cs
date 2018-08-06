using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_CertificateRefferance
    {
        public string RequestId { get; set; }
        public string Consignee { get; set; }
        public string CustomeID { get; set; }
        public string ParentCustomerID { get; set; }
        public Int64 SeqNo { get; set; }
        public string TemplateName { get; set; }

    }
}