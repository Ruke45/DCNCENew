using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_CertificateRequest
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();

        public List<M_SupportDocument> getTemplateSupportingDocs(string ClientId, string TemplateId)
        {
            try
            {

                List<M_SupportDocument> lstSD = new List<M_SupportDocument>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getSupportingDOCforRequestResult> lst = datacontext._getSupportingDOCforRequest(ClientId,TemplateId);

                    foreach (_getSupportingDOCforRequestResult result in lst)
                    {
                        M_SupportDocument SD = new M_SupportDocument();
                        SD.SupportingDocument_Id = result.SupportingDocumentId;
                        SD.SupportingDocument_Name = result.SupportingDocumentName;
                        SD.Is_Mandatory = result.IsMandatory;
                        SD.Template_Id = result.TemplateId;
                        lstSD.Add(SD);

                    }
                }

                return lstSD;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public List<M_CertificateRefferance> getRefferenceCRequest(string PCID)
        {
            try
            {

                List<M_CertificateRefferance> lstSD = new List<M_CertificateRefferance>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<getCustomerConsigneesReffResult> lst = datacontext.getCustomerConsigneesReff(PCID);

                    foreach (getCustomerConsigneesReffResult result in lst)
                    {
                        M_CertificateRefferance SD = new M_CertificateRefferance();
                        SD.Consignee = result.Consignee;
                        SD.RequestId = result.RequestId;
                        SD.TemplateName = result.TemplateName;
                        SD.SeqNo = result.SeqNo;
                        lstSD.Add(SD);

                    }
                }

                return lstSD;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public List<M_Customer> getCustomerClients(string PCID)
        {
            try
            {

                List<M_Customer> lstSD = new List<M_Customer>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<getCustomerClientListResult> lst = datacontext.getCustomerClientList(PCID);

                    foreach (getCustomerClientListResult result in lst)
                    {
                        M_Customer SD = new M_Customer();
                        SD.TemplateId = result.TemplateId;
                        SD.Customer_Name = result.CustomerName;
                        SD.ClientId = result.CustomerId;
                        lstSD.Add(SD);

                    }
                }

                return lstSD;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public M_Cerificate getCleintNTemplate(string CustomerId, string ParentId)
        {
            try
            {

                M_Cerificate Cu = new M_Cerificate();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    var lst = datacontext.getClientTemplateNName(CustomerId,ParentId).SingleOrDefault();
                    if (lst != null)
                    {
                        Cu.Consignor_Exporter = lst.CustomerName.Replace("<br />", "\r\n");
                        Cu.TemplateId = lst.TemplateId;
                        Cu.Client_Id = lst.CustomerId;
                        Cu.ClientContact_Name = lst.ContactPersonName;
                        Cu.ClientContact_Designation = lst.ContactPersonDesignation;
                        Cu.ClientContact_Telephone = lst.ContactPersonDirectPhoneNumber;
 
                    }
                }

                return Cu;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public string setCertificateRequest(M_Cerificate hdr)
        {

            try
            {
                string certificatereqno = string.Empty;
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();

                        B_RecordSequence CParentId = new B_RecordSequence();
                        Int64 RequestNo = CParentId.getNextSequence("CertificateRequestNo", dbContext);
                        certificatereqno = "CRN" + RequestNo.ToString();
                        dbContext._setCertifcateRequestHeader(certificatereqno,
                                                                hdr.TemplateId,
                                                                hdr.Client_Id,
                                                                hdr.Createdby,
                                                                hdr.Status,
                                                                hdr.Consignor_Exporter,
                                                                hdr.Consignee,
                                                                hdr.InvoiceNo,
                                                                Convert.ToDateTime(hdr.InvoiceDate),
                                                                hdr.CountyOfOrigin,
                                                                hdr.PortOfLoading,
                                                                hdr.PortOfDischarge,
                                                                hdr.Vessel,
                                                                hdr.PlaceOfDelivery,
                                                                hdr.TotalInvoiceValue,
                                                                hdr.TotalQuantity,
                                                                hdr.OtherComments,
                                                                hdr.Remarks,
                                                                hdr.SealRequired.ToString());



                         dbContext._setCertificateRequestDetails(certificatereqno,
                                                                hdr.Goods_Item,
                                                                hdr.ShippingMarks,
                                                                hdr.PackageType,
                                                                hdr.SummaryDescription,
                                                                hdr.QtyNUnit,
                                                                hdr.HSCode,
                                                                hdr.Createdby);

                         if (hdr.AddAsReff)
                        {
                            dbContext._setReffrennceRequest(hdr.Consignee, hdr.Client_Id, certificatereqno, hdr.ParentId, hdr.CTemplateName);
                        }
                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();
                        return certificatereqno;
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError(ex);
                        dbContext.Transaction.Rollback();
                        return null;
                    }
                    finally
                    {
                        dbContext.Connection.Close();

                    }

                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public bool setSupportingDocumentFRequest(M_SupportDocumentUpload usr)
        {

            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setSupportingDocUpload(usr.RequestRefNo, usr.SupportingDocumentID, usr.Remarks, usr.UploadedBy, usr.UploadedPath, usr.DocumentName, usr.SignatureRequired.ToString());
                    return true;
                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }

        public M_Cerificate getSavedCertificateRequest(string RequestId)
        {
            try
            {

                M_Cerificate Cu = new M_Cerificate();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    var lst = datacontext._getSavedCertificateRequest(RequestId).SingleOrDefault();
                    if (lst != null)
                    {
                        Cu.Consignor_Exporter = lst.Consignor.Replace("<br />", "\r\n");
                        Cu.Consignee = lst.Consignee.Replace("<br />", "\r\n");
                        Cu.TemplateId = lst.TemplateId;
                        Cu.Client_Id = lst.CustomerId;
                        Cu.CountyOfOrigin = lst.CountryCode;
                        Cu.Goods_Item = lst.GoodItem;
                        Cu.HSCode = lst.HSCode;
                        Cu.InvoiceDate = lst.InvoiceDate.Value.ToString("yyyy/MM/dd");
                        //Cu.InvoiceNo = lst.InvoiceNo;
                        Cu.OtherComments = lst.OtherComments;
                        Cu.PackageType = lst.PackageType;
                        Cu.PlaceOfDelivery = lst.PlaceOfDelivery;
                        Cu.PortOfDischarge = lst.PortOfDischarge;
                        Cu.PortOfLoading = lst.LoadingPort;
                        Cu.QtyNUnit = lst.Quantity;
                        Cu.Remarks = lst.OtherDetails;
                        Cu.SealRequired = Convert.ToBoolean(lst.SealRequired);
                        Cu.ShippingMarks = lst.ShippingMark;
                        Cu.SummaryDescription = lst.SummaryDesc;
                        Cu.TotalInvoiceValue = lst.TotalInvoiceValue;
                        Cu.TotalQuantity = lst.TotalQuantity;
                        Cu.Vessel = lst.Vessel;
                    }
                }

                return Cu;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public bool setWebBasedCertificateCreation(string RequestId, string CertificatePath, string CertificateName)
        {

            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = ConfigurationManager.ConnectionStrings["DocMgmtDBConnectionString"].ToString();
                    datacontext._setWebBasedCertificateCreation(RequestId, CertificatePath, CertificateName);
                    return true;
                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }

        public string setUploadBasedCertificateRequest(M_Cerificate EmR,string Filename)
        {

            try
            {

                string certificatereqno = string.Empty;
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();

                        B_RecordSequence CParentId = new B_RecordSequence();
                        Int64 RequestNo = CParentId.getNextSequence("CertificateRequestNo", dbContext);
                        certificatereqno = "CRN" + RequestNo.ToString();
                        dbContext._setUploadBasedCRequests(certificatereqno,
                                                            EmR.Client_Id,
                                                            "P",
                                                            EmR.Createdby,
                                                            EmR.CertificateUploadPath + certificatereqno +"/"+ Filename,
                                                            EmR.InvoiceNo,
                                                            EmR.SealRequired.ToString());
                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();
                        return certificatereqno;



                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError(ex);
                        dbContext.Transaction.Rollback();
                        return null;
                    }
                    finally
                    {
                        dbContext.Connection.Close();

                    }

                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public string setSupportingDocSignRequest(M_SupportDocumentUpload Model)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext.Connection.Open();

                    try
                    {
                        B_RecordSequence seqmanager = new B_RecordSequence();
                        datacontext.Transaction = datacontext.Connection.BeginTransaction();
                        string Doc_No = "SDR" + seqmanager.getNextSequence("SupportingDocSignRq", datacontext);
                        datacontext._setSupportingDocApproveRequest(Doc_No,
                                                                    Model.SupportingDocumentID,
                                                                    Model.ClientId,
                                                                    Model.UploadedBy,
                                                                    Model.Status,
                                                                    Model.UploadedPath + "/" + Doc_No + "/" + Model.DocumentName,
                                                                    Model.DocumentName);
                        datacontext.SubmitChanges();
                        datacontext.Transaction.Commit();
                        return Doc_No;
                    }
                    catch (Exception Ex)
                    {
                        ErrorLog.LogError(Ex);
                        datacontext.Transaction.Rollback();
                        return null;
                    }
                    finally
                    {
                        datacontext.Connection.Close();

                    }
                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public List<M_Cerificate> getAllPendingCertificateRequest(string ClientId)
        {
            try
            {

                List<M_Cerificate> lstSD = new List<M_Cerificate>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<getAllPendingCertificateRequestsResult> lst = datacontext.getAllPendingCertificateRequests(ClientId);

                    foreach (getAllPendingCertificateRequestsResult result in lst)
                    {
                        M_Cerificate SD = new M_Cerificate();
                        SD.CertificateType = result.CertificateType;
                        SD.CertificateUploadPath = result.CertificatePath;
                        SD.Client_Id = result.CustomerId;
                        SD.ClientContact_Company = result.CustomerName;
                        SD.Ctype = result.CType;
                        SD.RequestReff = result.RequestId;
                        SD.RequestDate = result.RequestDate;
                        SD.ClientContact_Email = result.ContactPersonEmail;
                        SD.InvoiceNo = result.InvoiceNo;
                        SD.Status = result.Status;
                        SD.TemplateId = result.TemplateId;
                        SD.SealRequired = Convert.ToBoolean(result.SealRequired);
                        SD.Createdby = result.Createdby;
                        SD.SummaryDescription = result.SummaryDesc;
                        SD.ParentId = result.ParentCustomer;
                        lstSD.Add(SD);
                    }
                }

                return lstSD;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }
        }


        public bool UpdateSupportingDocCertified(M_SupportDocumentUpload SD)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setUpdateSupportingDocUpload(SD.Seq_No, SD.UploadedPath, SD.DocumentName);
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