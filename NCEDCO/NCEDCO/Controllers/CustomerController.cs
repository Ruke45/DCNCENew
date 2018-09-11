﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Utility;
using NCEDCO.Filters;

namespace NCEDCO.Controllers
{
    public class CustomerController : Controller
    {
        //
        // GET: /Customer/
        B_Customer CustomerOBj = new B_Customer();
        B_Users objUser = new B_Users();
        _USession _session = new _USession();

        public ActionResult Register()
        {
            return View();
        }

        [UserFilter(Function_Id="F_CLENT_REGISTR")]
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
            string output = "Error";
            string ID = "";
            try
            {
                if (!objUser.checkUserName(Model.Admin_UserId))
                {
                    var cid = CustomerOBj.SetChildCustomerRequest(Model);

                    if (ID != null)
                    {
                        ID = cid;
                        output = "Sucsess";
                    }
                }
                
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            var result = new {  Msg = output, CID = ID };
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult CTemplateSelect(string RequestId)
        {
            if (RequestId != null)
            {
                NCETemplate Temp = new NCETemplate();
                ViewBag.Bag_CCRequestId = RequestId;
                return View(Temp.getTemplateData("%", "%", "%"));
            }// Only View Admin all template customers show -3 template 
            return HttpNotFound("Ooops, There is no page like this :/");
        }
        [UserFilter(Function_Id = "F_PARNT.REQST")]
        public ActionResult ParentCustomerRequests()
        {
            return View(CustomerOBj.getParentCustomerRequest("P"));
        }

        [UserFilter(Function_Id = "F_PARNT.REQST.DETL")]
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
                result = CustomerOBj.SetApproveCustomerParentRequest(CustomerOBj.getParentCustomerDetails(Model.Request_Id),_session.User_Id);

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
        public JsonResult ApproveCCustomer(M_CustomerRequest Model)
        {
            string result = "Error";
            try
            {
                result = CustomerOBj.SetApproveClientCustomerRequest(CustomerOBj.getChildCustomerDetails(Model.Request_Id));

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
            List<M_Reject> UCategorylist = getRejectReasons(ParentReject_Category);
            ViewBag.Bag_RejectReasons = new SelectList(UCategorylist, "Reject_ReasonId", "Reject_ReasonName");
            ViewBag.Bag_RejectingID = RejectingID;

            return PartialView("P_ParentCustomerReject");
        }

        private static List<M_Reject> getRejectReasons(string ParentReject_Category)
        {
            Rejectitem objReject = new Rejectitem();
            List<M_Reject> UCategorylist = objReject.getReasons(ParentReject_Category);
            return UCategorylist;
        }

        public ActionResult ClientRejectReasons(string RejectingID)
        {
            string ParentReject_Category = System.Configuration.ConfigurationManager.AppSettings["ParentReject_Category"].ToString();
            List<M_Reject> UCategorylist = getRejectReasons(ParentReject_Category);
            ViewBag.Bag_RejectReasons = new SelectList(UCategorylist, "Reject_ReasonId", "Reject_ReasonName");
            ViewBag.Bag_RejectingID = RejectingID;

            return PartialView("C_ChildCustomerReject");
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

        [HttpPost]
        public JsonResult RejectCCustomer(M_Reject Model)
        {
            string result = "Error";
            try
            {
                result = CustomerOBj.SetRejectCustomerChildRequest(Model);

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

        public JsonResult CheckUserName(string userName)
        {     
            bool isExits = objUser.checkUserName(userName);
            return Json(isExits, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_CLENT.REQST")]
        public ActionResult ClientCustomerRequests()
        {
            return View(CustomerOBj.getChildCustomerRequest("P"));
        }

        [UserFilter(Function_Id = "F_CLENT.REQST.DETL")]
        public ActionResult ClientCustomerRequestsDetails(string RequestID)
        {
            return View(CustomerOBj.getChildCustomerDetails(RequestID));
        }

       // [UserFilter(Function_Id = "F_CLENT.REQST.DETL")]
        public ActionResult RateNTax()
        {

            List<M_CustomerParent> par = CustomerOBj.getAllParents();
            ViewBag.ParentsIDs = new SelectList(par, "Parent_Id", "Customer_Name"); 
            //ViewBag.CustomerIDs = null;
            return View();
        }

        public ActionResult GetParentChild(string Pid)
        {
            B_CertificateRequest R = new B_CertificateRequest();
            List<M_Customer> C = R.getCustomerClients(Pid);
            ViewBag.CustomerIDs = new SelectList(C, "ClientId", "Customer_Name");

            return PartialView("P_RatesSetCustomer");
        }

        public ActionResult GetChildRates(string Cid)
        {
            List<M_TaxNRates> C = CustomerOBj.getCustomerRates(Cid,"Y");
            return PartialView("P_ChildRatesTable",C);
        }

        [HttpPost]
        public JsonResult setUpdateRate(M_TaxNRates Model)
        {
            bool result = false;
            try
            {
                result = CustomerOBj.ModifyRateData(Model);
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }


    }
}
