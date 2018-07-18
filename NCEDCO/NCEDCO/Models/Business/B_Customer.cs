using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_Customer
    {
        static string DECKey = System.Configuration.ConfigurationManager.AppSettings["DecKey"];
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        string Password = DECKey.Substring(12);

        public string SetCustomerParentRequest(M_CustomerParentRequest pr)
        {
            try
            {
                string PRequesNo = string.Empty;
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();

                        B_RecordSequence CParentId = new B_RecordSequence();
                        Int64 RequestNo = CParentId.getNextSequence("ParentRequestNo", dbContext);
                        PRequesNo = "PCRN" + RequestNo.ToString();
                        dbContext.DCISsetParentCustomerRequest(PRequesNo,
                                                                pr.Customer_Name,
                                                                pr.Telephone,
                                                                pr.Email,
                                                                pr.Fax,
                                                                "P",
                                                                pr.Address1,
                                                                pr.Address2,
                                                                pr.Address3,
                                                                "",
                                                                pr.IsVat,
                                                                pr.Admin_UserId,
                                                                pr.Admin_Password,
                                                                pr.ContactPersonName,
                                                                pr.ContactPersonDesignation,
                                                                pr.ContactPersonDirectPhone,
                                                                pr.ContactPersonMobile,
                                                                pr.ContactPersonEmail,
                                                                pr.IsNCEMember,
                                                                pr.Admin_Name);

                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();
                        return PRequesNo;
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError("B_Customer",ex);
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

        public List<M_CustomerParentRequest> getParentCustomerRequest(string Status)
        {
            try
            {
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    List<M_CustomerParentRequest> PList = new List<M_CustomerParentRequest>();


                dbContext.Connection.ConnectionString = Connection_;
                System.Data.Linq.ISingleResult<DCISgetParentCustomerRequestListResult> lst = dbContext.DCISgetParentCustomerRequestList(Status);
                foreach(DCISgetParentCustomerRequestListResult result in lst){
                    M_CustomerParentRequest M = new M_CustomerParentRequest();
                    M.Address1 = result.Address1;
                    M.Address2 = result.Address2;
                    M.Address3 = result.Address3;
                    M.Admin_Name = result.AdminName;
                    M.Admin_UserId = result.AdminUserId;
                    M.ContactPersonDesignation = result.ContactPersonDesignation;
                    M.ContactPersonEmail = result.ContactPersonEmail;
                    M.Customer_Name = result.CustomerName;
                    M.Email = result.Email;
                    M.Telephone = result.Telephone;
                    M.Request_Id = result.RequestId;
                    M.ContactPersonName = result.ContactPersonName;
                    M.CreatedDate = result.CreatedDate;

                    PList.Add(M);
                }

                return PList;

                }

            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                // Console.WriteLine(ex.Message.ToString());
                return null;
            }

        }

        public M_CustomerParentRequest getParentCustomerDetails(string RequestId)
        {
            try
            {

                M_CustomerParentRequest req = new M_CustomerParentRequest();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<DCISgetParentCustomerRequestDetailsResult> lst = datacontext.DCISgetParentCustomerRequestDetails(RequestId);

                    foreach (DCISgetParentCustomerRequestDetailsResult r in lst)
                    {
                        req.Address1 = r.Address1;
                        req.Address2 = r.Address2;
                        req.Address3 = r.Address3;
                        req.Admin_Name = r.AdminName;
                        req.Admin_UserId = r.AdminUserId;
                        req.ContactPersonDesignation = r.ContactPersonDesignation;
                        req.ContactPersonDirectPhone = r.ContactPersonDirectPhoneNumber;
                        req.ContactPersonEmail = r.ContactPersonEmail;
                        req.ContactPersonMobile = r.ContactPersonMobile;
                        req.ContactPersonName = r.ContactPersonName;
                        req.CreatedDate = r.CreatedDate;
                        req.Customer_Name = r.CustomerName;
                        req.Email = r.Email;
                        req.Fax = r.Fax;
                        req.Request_Id = r.RequestId;
                        req.Telephone = r.Telephone;
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