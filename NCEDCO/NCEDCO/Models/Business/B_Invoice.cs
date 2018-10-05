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

        //CertificateManager CM;
        //CustometTaxDetailManager tax;
        //InvoiceDetailSavingManager InvoicesaveManager;
        //InvoiceDetailSaving invoice;


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

        public void setInvoiceHeader()
        {
        }

        public bool setInvoiceRate(M_SupportDocument M)
        {
            try
            {
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {
                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext._setInvoiceRate(M.ClientID_,M.Invoice_No,M.SupportingDocument_Name,M.Rate_Id,M.Rate_,M.Created_By);
                    return true;
                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }
        }
    }
}