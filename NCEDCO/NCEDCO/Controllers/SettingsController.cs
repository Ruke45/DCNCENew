﻿using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
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

        public ActionResult SupportDocument()
        {
            return View(objSettings.SDocument_getSDcouments("%","Y"));
        }

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
        //[ValidateAntiForgeryToken]
        //[HandleError]
        public ActionResult NewSupportDoc(M_SupportDocument Model)
        {
            if (Model.SupportingDocument_Name == null)
            {
                return PartialView("P_NewSupportDoc");
            }

            string result = "Error";
            try
            {
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
        //[ValidateAntiForgeryToken]
        //[HandleError]
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
    }
}
