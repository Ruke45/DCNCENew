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
                        SRH.ApprovedDate = result.Approve_Date.Value.ToString("dd/MMM/yyyy");
                        SRH.Dtype = result.docTypes;
                        SRH.Ref_No = result.Ref_;
                        SRH.InvoicNo = result.Invoice;
                        SRH.Parent = result.Parent;
                        SRH.ApprovedBy = result.Approved_by;
                        SRH.IsDownloaded = result.IsDownloaded;
                        SRH.Path = result.Path_;
                        SRH.RequestId = result.Req_id;
                        SRH.ClientId = result.CustomerId;

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

        public bool setCertificateCancelation(M_CancelDocument req)
        {

            try
            {
                string remark = null;
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {
                    dbContext.Connection.ConnectionString = Connection_;

                    remark = "Canceled With the Certificate : " + req.Ref_No;
                    dbContext._setDocumentCancelation(req.Ref_No, req.Client, "Canceled", req.CanceledBy, req.Dtype);
                    if (req.Dtype.Equals("CO"))
                    {
                        System.Data.Linq.ISingleResult<_getSupportingDocUsingCertificateIdResult> lst = dbContext._getSupportingDocUsingCertificateId(
                                                                                                            req.Ref_No, req.InvoicNo);
                        foreach (_getSupportingDocUsingCertificateIdResult result in lst)
                        {
                            dbContext._setDocumentCancelation(result.RequestID, req.Client, remark, req.CanceledBy, result.DocType);

                        }
                    }


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