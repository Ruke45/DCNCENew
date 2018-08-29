using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_SupportDocApprove
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();

        public string setSupportingDocSignRequestINCertRequest(M_SupportDocumentUpload hdr)
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
                        long No = Convert.ToInt64(seqmanager.getNextSequence("SupportingDocSignRq"));
                        if (No == 0)
                        {
                            return null;
                        }
                        string Doc_No = "SDR" + No.ToString();
                        datacontext._setSupportingDocApproveFrmCRquest(Doc_No,
                                                                    hdr.SupportingDocumentID,
                                                                    hdr.ClientId,
                                                                    hdr.UploadedBy,
                                                                    hdr.Status,
                                                                    hdr.UploadedPath,
                                                                    hdr.DocumentName,
                                                                    hdr.ApprovedBy,
                                                                    Convert.ToDateTime(hdr.UploadedDate),
                                                                    hdr.CertifiedDocPathe,
                                                                    Convert.ToDateTime(hdr.ExpiredOn),
                                                                    hdr.RequestRefNo);
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

        public List<M_SupportDocumentUpload> getPendingSDRequests(string ClientId,string Status)
        {
            try
            {

                List<M_SupportDocumentUpload> lstSD = new List<M_SupportDocumentUpload>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getPendingSDocApprovalsResult> lst = datacontext._getPendingSDocApprovals(Status,ClientId);

                    foreach (_getPendingSDocApprovalsResult result in lst)
                    {
                        M_SupportDocumentUpload SD = new M_SupportDocumentUpload();
                        SD.RequestRefNo = result.RequestID;
                        SD.SupportingDocumentID = result.SupportingDocID;
                        SD.DocumentName = result.SupportingDocumentName;
                        SD.ClientId = result.CustomerID + " : " + result.CustomerName;
                        SD.UploadedDate = result.RequestDate.Value.ToString("dd/MMM/yyyy");
                        SD.UploadedBy = result.RequestBy;
                        SD.ParentId = result.ParentName;
                        SD.UploadedPath = result.UploadPath;
                        SD.DocumentTitle = result.UploadDocName;
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

        public bool ApproveSupportingDoc(M_SupportDocumentUpload SD)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setUpdateSDApproveReq(SD.RequestRefNo,
                                                       SD.ApprovedBy, 
                                                       SD.CertifiedDocPathe,
                                                       SD.DocumentName,
                                                       Convert.ToDateTime(SD.ExpiredOn));
                    datacontext.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }

        public M_SupportDocumentUpload getSDocbyID(string RequestId)
        {
            try
            {

                M_SupportDocumentUpload SD = new M_SupportDocumentUpload();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    var result = datacontext._getPendingSDoc_byID(RequestId).SingleOrDefault();
                    if (result != null)
                    {
                        SD.RequestRefNo = result.RequestID;
                        SD.SupportingDocumentID = result.SupportingDocID;
                        SD.DocumentName = result.SupportingDocumentName;
                        SD.ClientId = result.CustomerID + " : " + result.CustomerName;
                        SD.UploadedDate = result.RequestDate.Value.ToString("dd/MMM/yyyy");
                        SD.UploadedBy = result.RequestBy;
                        SD.ParentId = result.ParentName;
                        SD.UploadedPath = result.UploadPath;
                        SD.DocumentTitle = result.UploadDocName;

                    }
                }

                return SD;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }
    }
}