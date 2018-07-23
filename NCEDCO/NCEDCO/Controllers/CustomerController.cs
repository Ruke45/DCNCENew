using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Utility;

namespace NCEDCO.Controllers
{
    public class CustomerController : Controller
    {
        //
        // GET: /Customer/
        B_Customer CustomerOBj = new B_Customer();

        public ActionResult Register()
        {
            return View();
        }

        public ActionResult CRegister()
        {
            ExportSector objExport = new ExportSector();
            List<M_ExportSector> ExportList = objExport.getAllExportSector("Y");
            ViewBag.Bag_ExportSectors = new SelectList(ExportList, "ExportSectorId", "ExportSectorName");

            return View();
        }

        [HttpPost]
        public JsonResult Register(M_CustomerParentRequest Model)
        {
            string result = "Error";
            try
            {
                result =  CustomerOBj.SetCustomerParentRequest(Model);

                if (result != null)
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

        [HttpPost]
        public JsonResult CRegister(M_Customer Model)
        {
            string result = "Error";
            try
            {
                result = CustomerOBj.SetChildCustomerRequest(Model);

                if (result != null)
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

        public ActionResult CTemplateSelect(string RequestId)
        {
            NCETemplate Temp = new NCETemplate();
            ViewBag.Bag_CCRequestId = RequestId;
            return View(Temp.getTemplateData("%","%","%")); // Only View Admin all template customers show -3 template 
        }
        //[UserFilter(Function_Id = "TINDX")]
        public ActionResult ParentCustomerRequests()
        {
            return View(CustomerOBj.getParentCustomerRequest("P"));
        }

        public ActionResult ParentCustomerRequestsDetails(string RequestId)
        {
            return View(CustomerOBj.getParentCustomerDetails(RequestId));
        }

        //[UserFilter(Function_Id = "TINDX")]
        [HttpPost]
        public JsonResult ApprovePCustomer(M_CustomerParentRequest Model)
        {
            string result = "Error";
            try
            {

                result = CustomerOBj.SetApproveCustomerParentRequest(CustomerOBj.getParentCustomerDetails(Model.Request_Id));

                if (result != null)
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

        public ActionResult RejectReasons(string RejectingID)
        {
            string ParentReject_Category = System.Configuration.ConfigurationManager.AppSettings["ParentReject_Category"].ToString();
            Rejectitem objReject = new Rejectitem();
            List<M_Reject> UCategorylist = objReject.getReasons(ParentReject_Category);
            ViewBag.Bag_RejectReasons = new SelectList(UCategorylist, "Reject_ReasonId", "Reject_ReasonName");
            ViewBag.Bag_RejectingID = RejectingID;

            return PartialView("P_ParentCustomerReject");
        }

        [HttpPost]
        public JsonResult RejectPCustomer(M_Reject Model)
        {
            string result = "Error";
            try
            {

                result = CustomerOBj.SetRejectCustomerParentRequest(Model);

                if (result != null)
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

        public ActionResult ShowTemplate(string TemplateId,string RequestId)
        {
            NCETemplate Temp = new NCETemplate();
            ViewBag.Bag_CCTRequestId = RequestId; // Only View Admin all template customers show -3 template 

            return PartialView("P_ShowSingleTemplate", Temp.getTemplateData(TemplateId, "%"));
        }

        [HttpPost]
        public JsonResult SetClientTemplate(M_NCETemplate Model)
        {
            string result = "Error";
            try
            {

                result = CustomerOBj.SetChildTemplate(Model);

                if (result != null)
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
