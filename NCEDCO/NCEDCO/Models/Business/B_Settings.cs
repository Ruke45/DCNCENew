using NCEDCO.Models.Utility;
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

        public List<M_ExportSector> ExportS_getExportSection(string IsActive)
        {
            try
            {

                List<M_ExportSector> lstGroup = new List<M_ExportSector>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getExportSectorResult> lst = datacontext._getExportSector(IsActive);
                    foreach (_getExportSectorResult result in lst)
                    {
                        M_ExportSector grp = new M_ExportSector();
                        grp.ExportSectorId = Convert.ToInt32(result.ExportId);
                        grp.ExportSectorName = result.ExportSector;
                        grp.IsActive = result.Status;
                        lstGroup.Add(grp);

                    }
                }

                return lstGroup;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public bool ExportS_NewExportSector(M_ExportSector sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setNewExportSector(sd.ExportSectorName, sd.IsActive);
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

        public bool ExportS_UpdateExportSector(M_ExportSector sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setUpdateExportSector(sd.ExportSectorId, sd.ExportSectorName, sd.IsActive);
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

        public bool ExportS_DeleteExportSector(M_ExportSector sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setDeleteExportSector(sd.ExportSectorId);
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

        public List<M_Reject> RejectR_getRejectReasons(string RCategory,string IsActive)
        {
            try
            {

                List<M_Reject> lstR = new List<M_Reject>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getRejectReasons_ListResult> lst = datacontext._getRejectReasons_List(RCategory,IsActive);

                    foreach (_getRejectReasons_ListResult result in lst)
                    {
                        M_Reject R = new M_Reject();
                        R.Reject_ReasonCategory = result.Category;
                        R.Reject_ReasonName = result.ReasonName;
                        R.Reject_ReasonId = result.RejectCode;
                        R.Createdby = result.CreatedBy;
                        R.CreatedDate = Convert.ToDateTime(result.CreatedDate);
                        lstR.Add(R);

                    }
                }

                return lstR;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public bool RejectR_NewRejectReason(M_Reject sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    B_RecordSequence seqmanager = new B_RecordSequence();
                    Int64 rr = seqmanager.getNextSequence("RejectCode", datacontext);
                    string rrc = "RRC" + rr.ToString();
                    datacontext._setNewRejectReason(rrc,sd.Reject_ReasonCategory,sd.Reject_ReasonName,sd.Createdby,"Y");
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

        public bool RejectR_UpdateRejectReason(M_Reject sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setUpdateRejectReason(sd.Reject_ReasonId,sd.Reject_ReasonName,sd.Reject_ReasonCategory);
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

        public bool RejectR_DeleteRejectReason(M_Reject sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setDeleteRejectReason(sd.Reject_ReasonId);
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

        public List<M_SupportDocument> STemp_getSDoctemplates(string IsActive, string TemplateId)
        {
            try
            {

                List<M_SupportDocument> lstR = new List<M_SupportDocument>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getTemplateSupportDoc_ListResult> lst = datacontext._getTemplateSupportDoc_List(IsActive,TemplateId);

                    foreach (_getTemplateSupportDoc_ListResult result in lst)
                    {
                        M_SupportDocument t = new M_SupportDocument();
                        t.SupportingDocument_Id = result.SupportingDocumentId;
                        t.SupportingDocument_Name = result.SupportingDocumentName;
                        t.Template_Id = result.TemplateId;
                        t.Template_Name = result.TemplateName;
                        t.Template_SupportID = result.TemplateSupportingDocument;
                        t.Is_Mandatory = result.IsMandatory;
                        lstR.Add(t);

                    }
                }

                return lstR;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public bool STemp_NewTemplateSupportDoc(M_SupportDocument sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    int count = 0;
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_CheckTemplateSupportDocResult> lst = datacontext._CheckTemplateSupportDoc(sd.SupportingDocument_Id, sd.Template_Id);
                    foreach(_CheckTemplateSupportDocResult i in lst)
                    {
                        count = Convert.ToInt32(i.Count_);
                    }
                    
                    if (count == 0)
                    {
                        datacontext._setTemplateSupportingDocument(sd.SupportingDocument_Id, sd.Template_Id, sd.Created_By, sd.Is_Mandatory);
                        datacontext.SubmitChanges();
                    }
                    

                }
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }

        public bool STemp_UpdateTemplateSupportDoc(M_SupportDocument sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    int count = 0;
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_CheckTemplateSupportDocResult> lst = datacontext._CheckTemplateSupportDoc(sd.SupportingDocument_Id, sd.Template_Id);
                    foreach (_CheckTemplateSupportDocResult i in lst)
                    {
                        count = Convert.ToInt32(i.Count_);
                    }

                    if (count == 0)
                    {
                        datacontext._setUpdateTemplateSupportDoc(sd.Template_SupportID, sd.Template_Id, sd.SupportingDocument_Id, sd.Is_Mandatory,sd.Modified_By);
                        datacontext.SubmitChanges();
                    }


                }
                return true;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return false;
            }

        }

        public bool STemp_DeleteRejectReason(M_SupportDocument sd)
        {
            try
            {

                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {

                    datacontext.Connection.ConnectionString = Connection_;
                    datacontext._setDeleteTemplateSupportDoc(sd.Template_SupportID);
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