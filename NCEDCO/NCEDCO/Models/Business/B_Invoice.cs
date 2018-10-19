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

        public List<M_InvoiceDetails> getInvoiceDetail_Certs(string Status, String StartDate, string EndDate, string CusId, string CetrificateRateId)
        {
            try
            {

                List<M_InvoiceDetails> Requests = new List<M_InvoiceDetails>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getInvoiceDetails_CertificateResult> lst = datacontext._getInvoiceDetails_Certificate(Status,
                                                                                                                                          StartDate,
                                                                                                                                          EndDate,
                                                                                                                                          CusId,
                                                                                                                                          CetrificateRateId);

                    foreach (_getInvoiceDetails_CertificateResult result in lst)
                    {
                        M_InvoiceDetails req = new M_InvoiceDetails();

                        req.Customer_Id = result.CustomerId;
                        req.Consignee_ = result.Consignee;
                        req.Consignor_ = result.Consignor;
                        req.Created_Date = result.CreatedDate.Value.ToString();
                        req.Rate_ = result.Rates;
                        req.Request_Id = result.RequestId;
                        req.Is_SVAT = result.IsSVat;

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

        public List<M_TaxNRates> getTaxDetails(string IsActive, string IsVat)
        {
            try
            {

                List<M_TaxNRates> taxdetail = new List<M_TaxNRates>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getTaxDetailsResult> lst = datacontext._getTaxDetails(IsActive, IsVat);

                    foreach (_getTaxDetailsResult result in lst)
                    {

                        M_TaxNRates tax = new M_TaxNRates();
                        tax.RateName = result.TaxName;
                        tax.RateValue = result.TaxPercentage;
                        tax.RateID = result.TaxCode;
                        tax.Priority = Convert.ToInt32(result.TaxPriority);

                        taxdetail.Add(tax);
                    }
                }

                return taxdetail;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public string setInvoiceHeader(M_InvoiceData req)
        {

         //   InvoiceDetailSaving Check = new InvoiceDetailSaving();

            string RequestId = req.RequestId;

            try
            {
                string InvoiceNo = string.Empty;

                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {


                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        if (req.GrossTotal != 0)
                        {
                            dbContext.Transaction = dbContext.Connection.BeginTransaction();
                            B_RecordSequence seqmanager = new B_RecordSequence();
                            Int64 RequestNo = seqmanager.getNextSequence("InvoiceNo", dbContext);

                            InvoiceNo = "STM" + DateTime.Now.ToString("yy") + String.Format("{0:D9}", RequestNo);
                            dbContext._setInvoiceHeader(InvoiceNo,
                                                        req.CustomerId,
                                                        req.StartDate, 
                                                        req.EndDate, 
                                                        req.GrossTotal, 
                                                        req.InvoiceTotal, 
                                                        req.IsTaxInvoice, 
                                                        req.Createdby, 
                                                        req.PrintCount);

                            dbContext.SubmitChanges();
                            dbContext.Transaction.Commit();
                        }
                    }
                    catch (Exception ex)
                    {
                        dbContext.Transaction.Rollback();
                        ErrorLog.LogError(ex);
                    }

                    return InvoiceNo;
                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return string.Empty;
            }
        }

        public bool setInvoiceDetails(M_InvoiceData req)
        {
            try
            {
                DBLinqDataContext datacontext = new DBLinqDataContext();
                datacontext.Connection.ConnectionString = Connection_;
                datacontext._setInvoiceDetails(req.RequestId, req.Rate, req.Createdby, req.invoiceNo);
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }
        }

        public bool setInvoiceTaxDetails(M_TaxNRates req)
        {
            try
            {
                DBLinqDataContext datacontext = new DBLinqDataContext();
                datacontext.Connection.ConnectionString = Connection_;
                datacontext._setInvoiceTax(req.InvoiceId, req.RateID, req.RateValue, req.CreatedBy, req.TaxPresentage);
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }
        }

        public M_InvoiceView getInvoice_HeaderNData(string InvoiceNo)
        {
            try
            {
                M_InvoiceView req = new M_InvoiceView();
                req.InvoiceNo = InvoiceNo;
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getInvoiceHeaderResult> lst = datacontext._getInvoiceHeader(InvoiceNo);

                    foreach (_getInvoiceHeaderResult result in lst)
                    {
                        req.Customer_Name = result.CustomerName;
                        req.ClientId = result.CustomerId;
                        req.InvoicedDate = result.CreatedDate.ToString("dd/MMM/yyyy");
                        req.Address1 = result.Address1;
                        req.Address2 = result.Address2;
                        req.Address3 = result.Address3;
                        req.FromDate = result.FromDate.ToString("dd/MMM/yyyy");
                        req.ToDate = result.ToDate.ToString("dd/MMM/yyyy");
                    }

                    System.Data.Linq.ISingleResult<_getInvoiceBodyResult> bdy = datacontext._getInvoiceBody(InvoiceNo);

                    foreach (_getInvoiceBodyResult result in bdy)
                    {
                        M_InvoiceDetails In = new M_InvoiceDetails();
                        decimal value = Math.Round(result.UnitCharge, 2);
                        In.Certificate_ID = result.CertificateId;
                        In.Request_Id = result.RequestNo;
                        In.Rate_ = value;
                        In.Consignee_ = result.Consignee;
                        In.Consignor_ = result.Consignor;
                        In.Created_Date = result.CreatedDate.ToShortDateString();

                        req.InvoiceBody.Add(In);
                    }
                }
                return req;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }

        }
    }
}