using NCEDCO.Models.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NCEDCO.Controllers
{
    public class CancelDocumentController : Controller
    {
        //
        // GET: /CancelDocument/
        B_CancelDocument objCncl = new B_CancelDocument();

        public ActionResult Index()
        {
            return View(objCncl.getDocumentCancelList("%", "A", "20180801", "20180905", "SDID1","%"));
        }

    }
}
