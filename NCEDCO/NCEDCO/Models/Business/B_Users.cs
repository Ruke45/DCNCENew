﻿using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Transactions;
using System.Web.Mvc;

namespace NCEDCO.Models.Business
{
    public class B_Users
    {
        static string DECKey = ConfigurationManager.AppSettings["DecKey"];
        static string Substrings = ConfigurationManager.AppSettings["Substrings"].ToString();
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        string Group_Singatory = ConfigurationManager.AppSettings["UserGroupID_SAdmin"].ToString();

        string Password = DECKey.Substring(Convert.ToInt32(Substrings));

        public M_Login getUserLogin(M_Login Usr)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    M_Login usr = new M_Login();
                    string pass = Encrypt_Decrypt.Encrypt(Usr.Password_, Password);

                    System.Data.Linq.ISingleResult<_getUserloginResult> loggedUser = datacontext._getUserlogin(Usr.User_ID, pass);
                    foreach (_getUserloginResult result in loggedUser)
                    {
                        if (result.UserId.Equals(Usr.User_ID) && result.Password.Equals(pass))
                        {
                            usr.User_ID = result.UserId;
                            usr.UserGroup_ID = result.UserGroupID;

                            usr.Is_Active = result.IsActive;
                            // usr.Is_Vat = result.IsVat;
                            usr.PassowordExpiry_Date = result.PassowordExpiryDate.ToString();
                            usr.Person_Name = result.PersonName;
                            usr.Customer_ID = result.ParentCustomerId;
                            if (usr.Is_Active == "N")
                            {
                                return null;
                            }
                            else
                            {
                                return usr;
                            }
                        }
                    }
                    return null;
                }

            }
            catch (Exception ex)
            {
                // Console.WriteLine(ex.Message.ToString());
                ErrorLog.LogError(ex);
                return null;
            }


        }


        public bool checkUserName(string UserName)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;

                    System.Data.Linq.ISingleResult<_getUserNameResult> ckuser = datacontext._getUserName(UserName);
                    foreach (_getUserNameResult result in ckuser)
                    {
                        if (result.UserID.Equals(UserName))
                        {
                            return true;
                        }
                        else return false;
                    }
                }
                return false;

            }
            catch (Exception ex)
            {
                // Console.WriteLine(ex.Message.ToString());
                ErrorLog.LogError(ex);
                return true;
            }


        }

        public bool checkAuthorization(string UserGroupId,string FunctionId)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;

                    System.Data.Linq.ISingleResult<_getUserGroupFunctionResult> ckuser = datacontext._getUserGroupFunction(FunctionId,UserGroupId);
                    foreach (_getUserGroupFunctionResult result in ckuser)
                    {
                        if (result.GroupId.Equals(UserGroupId))
                        {
                            return true;
                        }
                        else return false;
                    }
                }
                return false;

            }
            catch (Exception ex)
            {
                // Console.WriteLine(ex.Message.ToString());
                ErrorLog.LogError(ex);
                return true;
            }


        }

        public List<M_Signatory>  _getSignatoryUser()
        {
            try
            {
                List<M_Signatory> list = new List<M_Signatory>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;

                    System.Data.Linq.ISingleResult<_getSignatoryUsersResult> ckuser = datacontext._getSignatoryUsers(Group_Singatory);
                    foreach (_getSignatoryUsersResult result in ckuser)
                    {
                        M_Signatory s = new M_Signatory();
                        s.UserId = result.UserID;
                        s.UserName = result.PersonName;
                        list.Add(s);
                    }
                }
                return list;

            }
            catch (Exception ex)
            {
                // Console.WriteLine(ex.Message.ToString());
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public bool SigantorySignatureUpload(M_Signatory Model,string pfxpath, string Imgpath,string Createdby)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    var result = datacontext._getUserSignatureDetails(Model.UserId).FirstOrDefault();
                    
                    if (result == null)
                    {
                        datacontext._setSignatorySignatureDetails(Model.UserId, pfxpath, Imgpath, Createdby );
                        datacontext.SubmitChanges();
                        return true;
                    }
                    else 
                    {
                        if (result.UserID.Equals(Model.UserId))
                        {
                            datacontext._setUpdateUserSignatureDetails(Model.UserId, pfxpath, Imgpath, Createdby);
                            datacontext.SubmitChanges();
                            return true;
                        }
                    }
                }
                return false;
            }
            catch (Exception ex)
            {
                // Console.WriteLine(ex.Message.ToString());
                ErrorLog.LogError(ex);
                return false;
            }
            
        }

        public List<M_Users> getBackEndUsers()
        {
            try
            {

                List<M_Users> lstUser = new List<M_Users>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getBackendSystemUsersResult> lst = datacontext._getBackendSystemUsers();
                    foreach (_getBackendSystemUsersResult result in lst)
                    {
                        M_Users usr = new M_Users();
                        usr.UserId = result.UserID;
                        usr.UserGroup = result.UserGroupID;
                        usr.UserName = result.PersonName;
                        usr.IsActive = result.IsActive;
                        usr.Email = result.Email;
                        usr.Designation = result.Designation;
                        lstUser.Add(usr);

                    }
                }

                return lstUser;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }
 
    }
}