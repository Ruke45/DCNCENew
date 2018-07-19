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
    }
}
