﻿using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_Settings
    {

        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();

        public M_ProductOwner Owner_getContactPerson()
        {
            try
            {

                M_ProductOwner details = new M_ProductOwner();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getOwnerContactResult> lst = datacontext._getOwnerContact();

                    foreach (_getOwnerContactResult result in lst)
                    {
                        details.Contact_Person = result.Name;
                        details.Telephone_ = result.TelephoneNo;
                        details.Fax_ = result.FaxNo;
                        details.Email_ = result.Email;
                        details.Web_ = result.WebAddress;
                    }
                }

                return details;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public M_ProductOwner Owner_getCompanyDetails()
        {
            try
            {

                M_ProductOwner details = new M_ProductOwner();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getOwnerCompanyResult> lst = datacontext._getOwnerCompany();

                    foreach (_getOwnerCompanyResult result in lst)
                    {
                        details.Organization = result.OrganizationName;
                        details.PO_BOX = result.PostBox;
                        details.Address1 = result.Address1;
                        details.Address2 = result.Address2;
                        details.Address3 = result.Address3;
                    }
                }

                return details;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }


        public bool Owner_ModifyContactPerson(M_ProductOwner odo)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext.Connection.Open();
                    datacontext._setUpdateOwnerContact(odo.Contact_Person, odo.Telephone_, odo.Email_, odo.Web_, odo.Fax_);
                    datacontext.SubmitChanges();

                }
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }
        }

        public bool Owner_ModifyCompany(M_ProductOwner odo)
        {
            try
            {
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext.Connection.Open();
                    datacontext._setUpdateOwnerCompany(odo.Organization, odo.PO_BOX, odo.Address1, odo.Address2, odo.Address3);
                    datacontext.SubmitChanges();

                }
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }
        }

        public List<M_SupportDocument> SDocument_getSDcouments(string supportingDocumentId, string createdBy)
        {
            try
            {

                List<M_SupportDocument> lstSD = new List<M_SupportDocument>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getSupportDocumentResult> lst = datacontext._getSupportDocument(supportingDocumentId, createdBy);

                    foreach (_getSupportDocumentResult result in lst)
                    {
                        M_SupportDocument SD = new M_SupportDocument();
                        SD.SupportingDocument_Id = result.SupportingDocumentId;
                        SD.SupportingDocument_Name = result.SupportingDocumentName;
                        SD.Created_By = result.CreatedBy;
                        SD.Created_Date = result.CreatedDate;
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

        public bool SDcoument_NewSDcoument(M_SupportDocument sd)
        {
            string SupDocID = string.Empty;
            try
            {

                using(DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    B_RecordSequence seqmanager = new B_RecordSequence();
                    Int64 sdid = seqmanager.getNextSequence("SupDocID", datacontext);
                    SupDocID = "SDID" + sdid.ToString();
                    datacontext._setSupportingDocuments(SupDocID, sd.SupportingDocument_Name,"ADMIN","Y");
                    datacontext.SubmitChanges();

                }
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }

        public bool SDcoument_UpdateSDcoument(M_SupportDocument sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setUpdateSupportingDocuments(sd.SupportingDocument_Id, sd.SupportingDocument_Name, "ADMIN");
                    datacontext.SubmitChanges();

                }
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }

        public bool SDcoument_DeleteSDcoument(M_SupportDocument sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setDeleteSupportingDocuments(sd.SupportingDocument_Id);
                    datacontext.SubmitChanges();

                }
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }
    }
}