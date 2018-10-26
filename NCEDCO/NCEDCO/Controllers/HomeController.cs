using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NCEDCO.Models.Utility;
using NCEDCO.Models.Business;
using System.Configuration;
using NCEDCO.Models;
using System.Xml;
using System.IO;
using NCEDCO.Filters;

namespace NCEDCO.Controllers
{
    public class HomeController : Controller
    {
        B_Users objUser = new B_Users();
        _USession _session = new _USession();

        public ActionResult Index()
        {
            ViewBag.Message = "Modify this template to jump-start your ASP.NET MVC application.";

            return View();
        }

        public ActionResult Error()
        {
            ViewBag.Message = "Modify this template to jump-start your ASP.NET MVC application.";

            return View();
        }

        [UserFilter(Function_Id = "F_DASHBOARD")]
        public ActionResult Dashboard()
        {
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
                Session.PFX_path = "~/Signature/DesmondM/W_M_S_L_Weerasinghe_NCE.pfx";
                Session.SignatureIMG_Path = "~/Signature/DesmondM/Sachithra-Weerasinghe's_signature_in_high_res.png";

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
            return View("Index");
        }

        [ChildActionOnly]
        public ActionResult Navigation_Lord()
        {
            var _menu = new Navigation_Menu();

            string naviga = "~/App_Data/"+ _session.User_Group +"_Navigation.xml";


            var xmlData = System.Web.HttpContext.Current.Server.MapPath(naviga);
            if (xmlData == null)
            {
                throw new ArgumentNullException("xmlData");
            }
            var xmldoc = new XmlDataDocument();
            var fs = new FileStream(xmlData, FileMode.Open, FileAccess.Read);
            xmldoc.Load(fs);
            var xmlnode = xmldoc.GetElementsByTagName("Navigation");
            for (var i = 0; i <= xmlnode.Count - 1; i++)
            {
                var xmlAttributeCollection = xmlnode[i].Attributes;
                if (xmlAttributeCollection != null)
                {
                    var nodeMenu = new MenuItem()
                    {
                        Name = xmlAttributeCollection["title"].Value,
                        Action = xmlAttributeCollection["action"].Value,
                        Controller = xmlAttributeCollection["controller"].Value,
                        Link = xmlAttributeCollection["url"].Value,
                        IsParent = Convert.ToBoolean(xmlAttributeCollection["isParent"].Value),
                    };
                    if (xmlnode[i].ChildNodes.Count != 0)
                    {
                        for (var j = 0; j < xmlnode[i].ChildNodes.Count; j++)
                        {
                            var xmlNode = xmlnode[i].ChildNodes.Item(j);
                            if (xmlNode != null)
                            {
                                if (xmlNode.Attributes != null)
                                {
                                    nodeMenu.ChildMenuItems.Add(new MenuItem()
                                    {
                                        Name = xmlNode.Attributes["title"].Value,
                                        Action = xmlNode.Attributes["action"].Value,
                                        Controller = xmlNode.Attributes["controller"].Value,
                                        Link = xmlNode.Attributes["url"].Value,
                                    });

                                }
                            }
                        }
                    }
                    _menu.Items.Add(nodeMenu);
                }
            }
            return PartialView("P_Navigation", _menu);
        }

        public ActionResult Verification()
        {
            B_Settings objsting = new B_Settings();
            return View(objsting.Owner_getContactPerson());
        }

        public ActionResult VerifyID(string Ref)
        {
            B_CertificateApprove objCa = new B_CertificateApprove();
            return PartialView("P_Verifyed", objCa.getRequestDetails(Ref));
        }
    }
}
