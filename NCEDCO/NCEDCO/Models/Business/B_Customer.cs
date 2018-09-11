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
        static string DECKey = ConfigurationManager.AppSettings["DecKey"];
        static string Substrings = ConfigurationManager.AppSettings["Substrings"].ToString();
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        string Password = DECKey.Substring(Convert.ToInt32(Substrings));

        /*------Email Subjects---------*/
        string Parent_Approved = ConfigurationManager.AppSettings["Parent_Approved"].ToString();
        string Parent_Rejected = ConfigurationManager.AppSettings["Parent_Rejected"].ToString();

        public string SetCustomerParentRequest(M_CustomerParentRequest pr)
        {
            try
            {
                string PRequesNo = string.Empty;
                string EncriptPass = Encrypt_Decrypt.Encrypt(pr.Admin_Password, Password);
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
                                                                EncriptPass,
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
                        req.Admin_Password = r.AdminPassword;
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
                        req.IsNCEMember = r.NCEMember;
                        req.IsVat = r.IsSVat;
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

        public string SetApproveCustomerParentRequest(M_CustomerParentRequest pr,string createdby)
        {
            try
            {
                string ParentCID = string.Empty;
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();

                        B_RecordSequence CParentId = new B_RecordSequence();
                        Int64 RequestNo = CParentId.getNextSequence("ParentCustomerId", dbContext);
                        ParentCID = "PC" + RequestNo.ToString();
                        dbContext.DCISsetApproveParentCustomer( pr.Request_Id,
                                                                ParentCID,
                                                                pr.Customer_Name,
                                                                pr.Telephone,
                                                                pr.Email,
                                                                pr.Fax,
                                                                "A",
                                                                pr.Address1,
                                                                pr.Address2,
                                                                pr.Address3,
                                                                createdby,
                                                                pr.IsVat,
                                                                pr.ContactPersonName,
                                                                pr.ContactPersonDesignation,
                                                                pr.ContactPersonDirectPhone,
                                                                pr.ContactPersonMobile,
                                                                pr.ContactPersonEmail,
                                                                pr.IsNCEMember);

                        dbContext.DCISsetUpdateParentCustomerReq("A", pr.Request_Id);
                        dbContext.DCISsetApprovedPCUser(pr.Admin_UserId, pr.Admin_Name, pr.Admin_Password, ParentCID);
                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();

                        MailSender Mail = new MailSender();
                        Mail.SendEmail(pr.ContactPersonEmail, "NCE Registration Approval", Parent_Approved + "  Your Customer Code is : " + ParentCID, " ");

                        return ParentCID;

                        //Email Send function needed
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError("B_Customer", ex);
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

        public string SetRejectCustomerParentRequest(M_Reject pr)
        {
            string result = "Error";
            try
            {           
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();
                        dbContext.DCISsetCustomerParentReject(pr.Rejecting_ID);
                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();

                        MailSender Mail = new MailSender();
                        Mail.SendEmail(pr.Email_, "NCE Registration Approval", Parent_Rejected," ");
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError("B_Customer", ex);
                        dbContext.Transaction.Rollback();
                        return result;
                    }
                    finally
                    {
                        dbContext.Connection.Close();

                    }

                }
                return result;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return result;
            }
        }

        public string SetChildCustomerRequest(M_Customer pr)
        {
            try
            {
                string PCRequesNo = string.Empty;
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();

                        B_RecordSequence CParentId = new B_RecordSequence();
                        Int64 RequestNo = CParentId.getNextSequence("CustomerRequestNo", dbContext);
                        PCRequesNo = "CCRN" + RequestNo.ToString();
                        dbContext._setParentChildCustomerRequest(PCRequesNo,
                                                                pr.Customer_Name,
                                                                pr.Telephone,
                                                                pr.Email,
                                                                pr.Fax,
                                                                "P",
                                                                pr.Address1,
                                                                pr.Address2,
                                                                pr.Address3,
                                                                "CLIENT",// User Session Parent User ID Here
                                                                pr.IsVat,
                                                                pr.ContactPersonName,
                                                                pr.ContactPersonDesignation,
                                                                pr.ContactPersonDirectPhone,
                                                                pr.ContactPersonMobile,
                                                                pr.ContactPersonEmail,
                                                                pr.IsNCEMember,
                                                                "PC3", // User Session Parent Customer ID Here
                                                                pr.ProductDetails,
                                                                pr.ExportSectorId);

                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();
                        return PCRequesNo;
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError("B_Customer", ex);
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

        public string SetChildTemplate(M_NCETemplate pr)
        {
            try
            {
                string result = "Error";
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();

                        dbContext._setCutomerClientTemplate(pr.ClientID_,pr.Template_Id);
                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();

                        //MailSender Mail = new MailSender();
                        //Mail.SendEmail(pr.ContactPersonEmail, "NCE Registration Approval", Parent_Approved + "  Your Customer Code is : " + ParentCID, " ");

                        return result = "Sucess";

                        //Email Send function needed
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError("B_Customer", ex);
                        dbContext.Transaction.Rollback();
                        return result;
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
                return "Exception";
            }

        }

        public List<M_CustomerRequest> getChildCustomerRequest(string Status)
        {
            try
            {
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    List<M_CustomerRequest> PList = new List<M_CustomerRequest>();


                    dbContext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getClientCustomerRequestListResult> lst = dbContext._getClientCustomerRequestList(Status);
                    foreach (_getClientCustomerRequestListResult result in lst)
                    {
                        M_CustomerRequest M = new M_CustomerRequest();
                        M.Address1 = result.Address1;
                        M.Address2 = result.Address2;
                        M.Address3 = result.Address3;
                        M.ContactPersonDesignation = result.ContactPersonDesignation;
                        M.ContactPersonEmail = result.ContactPersonEmail;
                        M.Customer_Name = result.Name;
                        M.Email = result.Email;
                        M.Telephone = result.Telephone;
                        M.Request_Id = result.RequestId;
                        M.ContactPersonName = result.ContactPersonName;
                        M.CreatedDate = Convert.ToDateTime(result.CreatedDate);

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

        public M_CustomerRequest getChildCustomerDetails(string RequestId)
        {
            try
            {

                M_CustomerRequest req = new M_CustomerRequest();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getClientCustomerRequestDetailsResult> lst = datacontext._getClientCustomerRequestDetails(RequestId);

                    foreach (_getClientCustomerRequestDetailsResult r in lst)
                    {
                        req.Address1 = r.Address1;
                        req.Address2 = r.Address2;
                        req.Address3 = r.Address3;
                        req.ContactPersonDesignation = r.ContactPersonDesignation;
                        req.ContactPersonDirectPhone = r.ContactPersonDirectPhoneNumber;
                        req.ContactPersonEmail = r.ContactPersonEmail;
                        req.ContactPersonMobile = r.ContactPersonMobile;
                        req.ContactPersonName = r.ContactPersonName;
                        req.CreatedDate = Convert.ToDateTime(r.CreatedDate);
                        req.Customer_Name = r.Name; // Child Customer
                        req.Email = r.Email;
                        req.Fax = r.Fax;
                        req.Request_Id = r.RequestId;
                        req.Telephone = r.Telephone;
                        req.IsNCEMember = r.NCEMember;
                        req.IsVat = r.SVat;
                        req.ProductDetails = r.Productdetails;
                        req.ExportSectorId = Convert.ToInt32(r.ExportSector);
                        req.ExportSector_Name = r.ExportSectorName;
                        req.Template_ID = r.TemplateId;
                        req.Template_Name = r.TemplateName;
                        req.Parent_CustomerId = r.ParentCustomerId;
                        req.Parent_CustomerName = r.CustomerName;
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

        public string SetApproveClientCustomerRequest(M_CustomerRequest pr)
        {
            try
            {
                string ChildCID = string.Empty;
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();

                        B_RecordSequence ChildID = new B_RecordSequence();
                        Int64 RequestNo = ChildID.getNextSequence("CustomerID", dbContext);
                        ChildCID = "CC" + RequestNo.ToString();
                        dbContext._setApproveChildCustomer(pr.Request_Id,
                                                                pr.Parent_CustomerId,
                                                                ChildCID,
                                                                pr.Customer_Name,
                                                                pr.Telephone,
                                                                pr.Email,
                                                                pr.Fax,
                                                                "A",
                                                                pr.Address1,
                                                                pr.Address2,
                                                                pr.Address3,
                                                                "ADMIN",
                                                                pr.IsVat,
                                                                pr.ContactPersonName,
                                                                pr.ContactPersonDesignation,
                                                                pr.ContactPersonDirectPhone,
                                                                pr.ContactPersonMobile,
                                                                pr.ContactPersonEmail,
                                                                pr.IsNCEMember,
                                                                pr.ProductDetails,
                                                                pr.ExportSector,
                                                                pr.Template_ID);

                        dbContext._setUpdateClientCustomerReq("A", pr.Request_Id);

                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();

                        //MailSender Mail = new MailSender();
                        //Mail.SendEmail(pr.ContactPersonEmail, "NCE Client Customer Registration Approval", Parent_Approved + "  Your Client Customer Code is : " + ParentCID, " ");

                        return ChildCID;

                        //Email Send function needed
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError("B_Customer", ex);
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

        public string SetRejectCustomerChildRequest(M_Reject pr)
        {
            string result = "Error";
            try
            {
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    dbContext.Connection.ConnectionString = Connection_;
                    dbContext.Connection.Open();

                    try
                    {
                        dbContext.Transaction = dbContext.Connection.BeginTransaction();
                        dbContext._setCustomerChildReject(pr.Rejecting_ID);
                        dbContext.SubmitChanges();
                        dbContext.Transaction.Commit();

                        //MailSender Mail = new MailSender();
                        //Mail.SendEmail(pr.Email_, "NCE Registration Approval", Parent_Rejected, " ");
                    }
                    catch (Exception ex)
                    {
                        ErrorLog.LogError("B_Customer", ex);
                        dbContext.Transaction.Rollback();
                        return result;
                    }
                    finally
                    {
                        dbContext.Connection.Close();

                    }

                }
                return result;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return result;
            }
        }

        public List<M_CustomerParent> getAllParents()
        {
            try
            {
                using (DBLinqDataContext dbContext = new DBLinqDataContext())
                {

                    List<M_CustomerParent> PList = new List<M_CustomerParent>();


                    dbContext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getAllParentCustomersResult> lst = dbContext._getAllParentCustomers();
                    foreach (_getAllParentCustomersResult result in lst)
                    {
                        M_CustomerParent M = new M_CustomerParent();
                        M.Customer_Name = result.CustomerName;
                        M.Parent_Id = result.ParentCustomerId;

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

        public List<M_TaxNRates> getCustomerRates(string CustometId, string Status)
        {
            try
            {

                List<M_TaxNRates> Requests = new List<M_TaxNRates>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getCustomerRateDetailsResult> lst = datacontext._getCustomerRateDetails(CustometId, Status);

                    foreach (_getCustomerRateDetailsResult result in lst)
                    {
                        M_TaxNRates req = new M_TaxNRates();
                        req.RateID = result.RateId;
                        req.RateName = result.RateName;
                        req.RateValue = result.Rates;
                        req.PayType = result.PaidType;
                        req.CustomerID = result.CustomerId;

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

        public bool ModifyRateData(M_TaxNRates req)
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
                        datacontext._ModifyCustomerRate(req.CustomerID, req.RateID, req.RateValue);

                        datacontext.SubmitChanges();
                        datacontext.Transaction.Commit();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        datacontext.Transaction.Rollback();
                        ErrorLog.LogError(ex);
                        return false;
                    }
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