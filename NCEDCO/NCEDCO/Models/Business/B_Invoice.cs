using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_Invoice
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();

        public List<M_InvoiceDetails> getAllInvoice(string Start, string End, string Status, string ParentId)
        {
            try
            {

                List<M_InvoiceDetails> Requests = new List<M_InvoiceDetails>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getAllInvoiceResult> lst = datacontext._getAllInvoice(Start, End, Status, ParentId);

                    foreach (_getAllInvoiceResult result in lst)
                    {
                        M_InvoiceDetails req = new M_InvoiceDetails();

                        req.Customer_Name = result.CustomerName;
                        req.Customer_Id = result.CustomerId;

                        Requests.Add(req);
                    }
                }

                return Requests;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }
    }
}