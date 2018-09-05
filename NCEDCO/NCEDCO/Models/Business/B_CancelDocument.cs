using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_CancelDocument
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();

        public List<M_CancelDocument> getDocumentCancelList(string CustomerId,
                                          string Status, string fromdate, string todate, string InvoiceSupDocId, string refNo)
        {
            try
            {
                List<M_CancelDocument> DocList = new List<M_CancelDocument>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {


                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getAllCertificateCancelDetailsResult> lst = datacontext._getAllCertificateCancelDetails(CustomerId,
                                                                                                          Status, fromdate, todate, InvoiceSupDocId, refNo);
                    foreach (_getAllCertificateCancelDetailsResult result in lst)
                    {
                        M_CancelDocument SRH = new M_CancelDocument();

                        SRH.Client = result.CustomerName;
                        SRH.ApprovedDate = result.CreatedDate.Value.ToString("dd/MMM/yyyy");
                        SRH.Dtype = result.docTypes;
                        SRH.Ref_No = result.CertificateId;
                        SRH.InvoicNo = result.Invoice;
                        SRH.Parent = result.Parent;

                        DocList.Add(SRH);

                    }
                }
                return DocList;

            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }

        }
    }

}