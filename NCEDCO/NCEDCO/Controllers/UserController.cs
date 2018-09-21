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

    }
}
