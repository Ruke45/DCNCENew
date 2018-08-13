using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_CertificateApprove
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        public bool ApproveCertificate(M_CertificateApprove usr)
        {
           try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext.Connection.Open();
                    try
                    {
                        datacontext.Transaction = datacontext.Connection.BeginTransaction();
                        datacontext._setCertificateApproval(usr.Certificate_Id,
                                                            usr.Request_Id,
                                                            usr.Expiry_Date,
                                                            usr.Created_By,
                                                            usr.Is_Downloaded,
                                                            usr.Certificate_Path,
                                                            usr.Certificate_Name,
                                                            usr.Is_Valid);
                        datacontext.SubmitChanges();
                        datacontext.Transaction.Commit();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError(ex);
                        datacontext.Transaction.Rollback();
                        return false;
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
                return false;
            }

        }

        public bool RejectCertificate(string RequestID, string RejectedBy, string ReasonCode)
        {

            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setCertificateReject(RequestID, RejectedBy, ReasonCode);
                    return true;
                }
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }

        public bool RejectUBCertificate(string RequestID, string RejectedBy, string ReasonCode)
        {

            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setRejectUBCertificate(RejectedBy, RequestID, ReasonCode);
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