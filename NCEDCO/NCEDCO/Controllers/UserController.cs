using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NCEDCO.Controllers
{
    public class UserController : Controller
    {
        //
        // GET: /User/
        B_Users objUsr = new B_Users();

        public ActionResult Index()
        {
            return View(objUsr.getBackEndUsers());
        }

        public ActionResult NewUser()
        {
            List<M_UGroup> UCategorylist = objUsr._getUserGroups();
            ViewBag.UGroups = new SelectList(UCategorylist, "GroupId", "GroupName");
            return PartialView("P_NewUser");
        }

        [HttpPost]
        public JsonResult AddNewUser(M_Users Model)
        {
            string result = "Error";
            try
            {
                result = objUsr.setNewUser(Model,"Admin");
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult EditUser(string id)
        {
            List<M_UGroup> UCategorylist = objUsr._getUserGroups();
            ViewBag.UGroups = new SelectList(UCategorylist, "GroupId", "GroupName");
            return PartialView("P_EditUser",objUsr._getUserInfo(id));
        }

        [HttpPost]
        public JsonResult UpdateUser(M_Users Model)
        {
            bool result = false;
            try
            {
                result = objUsr.Edit_User(Model, "Admin");
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ResetPasswrd(string Uid)
        {
            return PartialView("P_ResetP", objUsr._getUserInfo(Uid));
        }

        [HttpPost]
        public JsonResult ResetP(M_Users Model)
        {
            bool result = false;
            try
            {
                result = objUsr.ResetPassword(Model);
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

    }
}
