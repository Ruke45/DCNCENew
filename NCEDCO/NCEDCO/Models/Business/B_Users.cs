﻿using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_Users
    {
        static string DECKey = ConfigurationManager.AppSettings["DecKey"];
        static string Substrings = ConfigurationManager.AppSettings["Substrings"].ToString();
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
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
    }
}