using NCEDCO.Models.Business;
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

    }
}
