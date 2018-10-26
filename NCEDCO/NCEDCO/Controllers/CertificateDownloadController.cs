using NCEDCO.Filters;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace NCEDCO.Controllers
{
    public class CertificateDownloadController : Controller
    {
        //
        // GET: /CertificateDownload/
        B_CertificateDownload objCd = new B_CertificateDownload();
        _USession _session = new _USession();

        String UserGroupID_CustomerAdmin = System.Configuration.ConfigurationManager.AppSettings["UserGroupID_CustomerAdmin"];

        [UserFilter(Function_Id = "F_DOWNLD_INDX")]
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult getCertificateDownloadByParent()
        {
            if (_session.User_Group.Equals(UserGroupID_CustomerAdmin))
            {
                return PartialView("P_CDownloadList",
                       objCd.getCertificateDownload("%", "%", "%", "%", "%", _session.Customer_ID)); // need to be considered by Parent Id
            }
            return PartialView("P_CDownloadList",
                       objCd.getCertificateDownload("%", "%", "%", "%", "%", "%")); 
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

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        [HttpPost]
        public ActionResult BulkDownload(string IDs)
        {
            try
            {
                var strin = new JavaScriptSerializer().DeserializeObject(IDs);
                string[] arr = strin.ToString().Split(',');

                if (System.IO.File.Exists(Server.MapPath
                                  ("~/Temp/Certificates.zip")))
                {
                    System.IO.File.Delete(Server.MapPath
                                  ("~/Temp/Certificates.zip"));
                }
                ZipArchive zip = ZipFile.Open(Server.MapPath
                         ("~/Temp/Certificates.zip"), ZipArchiveMode.Create);

                for (int a = 0; a < arr.Length; a++)
                {
                    M_CDownload D = new M_CDownload();
                    List<M_SupportDocument> sD = new List<M_SupportDocument>();
                    D = objCd.getCertificateLinks(arr[a]);
                    sD = objCd.getSignedSupportDocs(arr[a]);

                    string Folder = arr[a] + "/";
                    string Support = Folder + "Supportdoc/";

                    zip.CreateEntryFromFile(Server.MapPath
                             (D.CertPath), Folder + D.CPath);
                    if (sD.Count != 0)
                    {
                        foreach (M_SupportDocument N in sD)
                        {
                            zip.CreateEntryFromFile(Server.MapPath
                                                         (N.Download_Path), Support + N.SupportingDocument_Name+".pdf");
                        }
                    }
                }
                zip.Dispose();
                return File(Server.MapPath("~/Temp/Certificates.zip"),
                      "application/zip", DateTime.Now.ToString("dd.MM.yyyy.ss") + ".zip");
                //byte[] fileBytes = System.IO.File.ReadAllBytes(Server.MapPath("~/Temp/Certificates.zip"));
                //return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, DateTime.Now.ToString("dd.MM.yyyy.ss") + ".zip");
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError(Ex);
                return View();
            }
            
        }

    }
}
