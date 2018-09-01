using NCEDCO.Filters;
using NCEDCO.Models.Business;
using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
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
                   objCd.getCertificateDownload("%","%","%","%","%","%"));
        }

        //[UserFilter(Function_Id = "F_CERT_APRUV")]
        [HttpGet]
        public ActionResult ViewPDF(String ID)
        {
            try
            {
                WebClient user = new WebClient();

                string p = Server.MapPath(ID.ToString());

                Byte[] FileBuffer = user.DownloadData(p);
                if (FileBuffer != null)
                {
                    return File(FileBuffer, "application/pdf");
                }
                else
                {
                    return Content("No file");
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError("Certificate Download View", Ex);
                return Content("Can't Access the Location of the File");
            }
        }

        public ActionResult getCertificateSupportDocs(string Cid)
        {
            return PartialView("P_CSupportdocDownload",
                        objCd.getCertificateSupportDocs(Cid));
        }

    }
}
