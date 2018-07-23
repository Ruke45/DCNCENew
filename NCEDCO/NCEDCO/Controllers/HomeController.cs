using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NCEDCO.Models.Utility;
using NCEDCO.Models.Business;
using System.Configuration;
using NCEDCO.Models;

namespace NCEDCO.Controllers
{
    public class HomeController : Controller
    {
        B_Users objUser = new B_Users();

        public ActionResult Index()
        {
            ViewBag.Message = "Modify this template to jump-start your ASP.NET MVC application.";

            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your app description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        public ActionResult Login()
        {

            return View();
        }
        [HttpPost]
        public JsonResult Login(M_Login login)
        {
            string result = "Error";
            var loggedU = objUser.getUserLogin(login);
            if (loggedU != null)
            {
                _USession Session = new _USession();
                Session.Customer_ID = loggedU.Customer_ID;
                Session.User_Id = loggedU.User_ID;
                Session.User_Group = loggedU.UserGroup_ID;
                Session.Person_Name = loggedU.Person_Name;

                result = "Succes";
            }
            else
            {
                result = "Failed";
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public ActionResult Logout()
        {
            Session.Abandon();
            Session.Clear();
            Session.RemoveAll();
            return View();
        }
    }
}
