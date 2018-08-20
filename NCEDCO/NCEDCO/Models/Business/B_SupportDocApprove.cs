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
    }
}