﻿using NCEDCO.Filters;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NCEDCO.Controllers
{
    public class SettingsController : Controller
    {
        //
        // GET: /Settings/
        B_Settings objSettings = new B_Settings();
        B_Users objUser = new B_Users();
        _USession _session = new _USession();

        [UserFilter(Function_Id = "F_OWNR.CNTCT")]
        public ActionResult EditOwnerContact()
        {
            return View(objSettings.Owner_getContactPerson());
        }

        [HttpPost]
        public JsonResult EditOwnerContact(M_ProductOwner Model)
        {
            string result = "Error";
            try
            {
                if (objSettings.Owner_ModifyContactPerson(Model))
                {
                    result = "Success";
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_OWNR.CMPNY")]
        public ActionResult EditOwnerCompany()
        {
            return View(objSettings.Owner_getCompanyDetails());
        }

        [HttpPost]
        public JsonResult EditOwnerCompany(M_ProductOwner Model)
        {
            string result = "Error";
            try
            {
                if (objSettings.Owner_ModifyCompany(Model))
                {
                    result = "Success";
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_SUPORT.DOC.V")]
        public ActionResult SupportDocument()
        {
            return View(objSettings.SDocument_getSDcouments("%","Y"));
        }

        //[UserFilter(Function_Id = "F_SUPORT.DOC.N")]
        public ActionResult NewSupportDoc(string SD,string Name)
        {
            if (SD != "")
            {
                M_SupportDocument S = new M_SupportDocument();
                S.SupportingDocument_Name = Name.Replace("_", " ");
                S.SupportingDocument_Id = SD;
                return PartialView("P_NewSupportDoc", S);
            }
            return PartialView("P_NewSupportDoc");
        }

        [HttpPost]
        public ActionResult NewSupportDoc(M_SupportDocument Model)
        {
            if (Model.SupportingDocument_Name == null)
            {
                return PartialView("P_NewSupportDoc");
            }

            string result = "Error";
            try
            {
                Model.Created_By = _session.User_Id;
                if (Model.SupportingDocument_Id == null)
                {
                    
                    if (objSettings.SDcoument_NewSDcoument(Model))
                    {
                        result = "Success";
                    }
                }
                else 
                {
                    if (objSettings.SDcoument_UpdateSDcoument(Model))
                    {
                        result = "Success";
                    }
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DeleteSupportDocument(string SDoc_ID)
        {
            ViewBag.Bag_SupportDocID = SDoc_ID;
            return PartialView("P_DeleteSupportDoc");
        }

        [HttpPost]
        public JsonResult DeleteSupportDocument(M_SupportDocument Model)
        {
            string result = "Error";
            try
            {
                if (objSettings.SDcoument_DeleteSDcoument(Model))
                {
                    result = "Success";
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_EXPRT.SECTR.V")]
        public ActionResult ExportSector()
        {
            return View(objSettings.ExportS_getExportSection("%"));
        }

        public ActionResult NewExportSector(int SD,string IsActive,string Name)
        {
            M_ExportSector Ex = new M_ExportSector();
            if (SD != 0)
            {
                Ex.IsActive = IsActive;
                Ex.ExportSectorId = SD;
                Ex.ExportSectorName = Name.Replace("_", " ");
                return PartialView("P_AddEditExportSector", Ex);
            }
            Ex.IsActive = "Y";
            return PartialView("P_AddEditExportSector",Ex);
        }

        [HttpPost]
        public ActionResult NewExportSector(M_ExportSector Model)
        {
            if (Model.ExportSectorName == null)
            {
                Model.IsActive = "Y";
                return PartialView("P_AddEditExportSector",Model);
            }

            string result = "Error";
            try
            {
                if (Model.ExportSectorId == 0)
                {
                    if (Model.IsActive == null) { Model.IsActive = "Y"; }
                    if (objSettings.ExportS_NewExportSector(Model))
                    {
                        result = "Success";
                    }
                }
                else
                {
                    if (objSettings.ExportS_UpdateExportSector(Model))
                    {
                        result = "Success";
                    }
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DeleteExportSector(string ID)
        {
            ViewBag.Export_ID = ID;
            return PartialView("P_DeleteExportSector");
        }

        [HttpPost]
        public JsonResult DeleteExportSector(M_ExportSector Model)
        {
            string result = "Error";
            try
            {
                if (objSettings.ExportS_DeleteExportSector(Model))
                {
                    result = "Success";
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_REJCT.RESN.V")]
        public ActionResult RejectReasons()
        {
            return View(objSettings.RejectR_getRejectReasons("%","Y"));
        }

        public ActionResult NewRejectReason(string Rid,string rrc , string Rname)
        {
            Rejectitem objReject = new Rejectitem();
            List<M_RejectCategory> RCategory = objReject.getReasonCategories();
            ViewBag.Bag_RejectReasonsCat = new SelectList(RCategory, "RejectCategoryId", "RejectCategoryName");

            M_Reject Ex = new M_Reject();
            if (Rid != "")
            {
                Ex.Reject_ReasonId = Rid;
                Ex.Reject_ReasonName = Rname.Replace("_", " ");
                Ex.Reject_ReasonCategory = rrc;
                return PartialView("P_NewRejectReason", Ex);
            }
            //Ex.IsActive = "Y";
            return PartialView("P_NewRejectReason");
        }

        [HttpPost]
        public ActionResult NewRejectReason(M_Reject Model)
        {
            if (Model.Reject_ReasonName == null || Model.Reject_ReasonCategory == null)
            {
                Model.IsActive = "Y";
                return PartialView("P_NewRejectReason", Model);
            }

            string result = "Error";
            try
            {
                if (Model.Reject_ReasonId == null)
                {
                    if (objSettings.RejectR_NewRejectReason(Model))
                    {
                        result = "Success";
                    }
                }
                else
                {
                    if (objSettings.RejectR_UpdateRejectReason(Model))
                    {
                        result = "Success";
                    }
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DeleteRejectReason(string ID)
        {
            ViewBag.RejectID = ID;
            return PartialView("P_DeleteRejectReason");
        }

        [HttpPost]
        public JsonResult DeleteRejectReason(M_Reject Model)
        {
            string result = "Error";
            try
            {
                if (objSettings.RejectR_DeleteRejectReason(Model))
                {
                    result = "Success";
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_SUPORT.D.4TEMP.V")]
        public ActionResult SupportDocumentForTemplate()
        {
            return View(objSettings.STemp_getSDoctemplates("Y", "%"));
        }

        public ActionResult NewSupportDocForTemplate(int id, string sid, string tempid, string isactive)
        {
            NCETemplate objTemp = new NCETemplate();
            List<M_NCETemplate> Temp = objTemp.getTemplateData("%","Y","%");
            ViewBag.Bag_NceTemplates = new SelectList(Temp, "Template_Id", "Template_Name");

            List<M_SupportDocument> Support = objSettings.SDocument_getSDcouments("%","%");
            ViewBag.Bag_SupportDoc = new SelectList(Support, "SupportingDocument_Id", "SupportingDocument_Name");
            M_SupportDocument sp = new M_SupportDocument();
            if (id != 0)
            {
                sp.Template_SupportID = id;
                sp.SupportingDocument_Id = sid;
                sp.Template_Id = tempid;
                sp.Is_Mandatory = isactive;
                return PartialView("P_NewSupportDocForTemplate", sp);
            }
            sp.Is_Mandatory = "Y";
            return PartialView("P_NewSupportDocForTemplate",sp);
        }

        [HttpPost]
        public ActionResult NewSupportDocForTemplate(M_SupportDocument Model)
        {
            if (Model.SupportingDocument_Id == null || Model.Template_Id == null)
            {
                Model.Is_Mandatory = "Y";
                return PartialView("P_NewSupportDocForTemplate", Model);
            }

            string result = "Error";
            try
            {
                if (Model.Template_SupportID == 0)
                {
                    Model.Created_By = "Admin";
                    if (objSettings.STemp_NewTemplateSupportDoc(Model))
                    {
                        result = "Success";
                    }
                }
                else
                {
                    Model.Modified_By = "Admin";
                    if (objSettings.STemp_UpdateTemplateSupportDoc(Model))
                    {
                        result = "Success";
                    }
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DeleteSupportDocForTemplate(string ID)
        {
            ViewBag.TempSupID = ID;
            return PartialView("P_DeleteSupportDocForTemplate");
        }

        [HttpPost]
        public JsonResult DeleteSupportDocForTemplate(M_SupportDocument Model)
        {
            string result = "Error";
            try
            {
                if (objSettings.STemp_DeleteRejectReason(Model))
                {
                    result = "Success";
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_SIGN.SIGNTUR")]
        public ActionResult SignatorySignature()
        {
            
            List<M_Signatory> USignatory = objUser._getSignatoryUser();
            ViewBag.Bag_SignatoryList = new SelectList(USignatory, "UserId", "UserName");

            return View();
        }

        [HttpPost]
        public JsonResult SignatorySignature(M_Signatory Model)
        {
            bool result = false;
            try
            {
                string DirectoryPath = "~/Signature/" + Model.UserId + "/" + DateTime.Now.ToString("yyyy_MM_dd");

                var pfx = Model.Signature_Path;
                var imgPath = Model.Singature_Img;

                if (pfx != null && imgPath != null && Model.UserId == null)
                {
                    if (objUser.SigantorySignatureUpload(Model, DirectoryPath + "/" + pfx.FileName.Replace(" ", "_"),
                                                                DirectoryPath + "/" + imgPath.FileName.Replace(" ", "_"),_session.User_Id))
                    {
                        if (!Directory.Exists(Server.MapPath(DirectoryPath)))
                        {
                            Directory.CreateDirectory(Server.MapPath(DirectoryPath));
                        }
                        pfx.SaveAs(Server.MapPath(DirectoryPath + "/" + pfx.FileName.Replace(" ", "_")));
                        imgPath.SaveAs(Server.MapPath(DirectoryPath + "/" + imgPath.FileName.Replace(" ", "_")));
                    }
                    result = true;
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}
