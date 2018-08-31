using NCEDCO.Models.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NCEDCO.Controllers
{
    public class CertificateDownloadController : Controller
    {
        //
        // GET: /CertificateDownload/
        B_CertificateDownload objCd = new B_CertificateDownload();

        public ActionResult Index()
        {

            return View();
        }

        public ActionResult getCertificateDownloadByParent()
        {       
            return PartialView("P_CDownloadList",
                   objCd.getCertificateDownload("%","%","%","%","%","PC3"));
        }

    }
}
