using NCEDCO.Models;
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
    public class CancelDocumentController : Controller
    {
        //
        // GET: /CancelDocument/
        B_CancelDocument objCncl = new B_CancelDocument();
        _USession _session = new _USession();

        public ActionResult Index()
        {
            return View(objCncl.getDocumentCancelList("%", "A", "20180801", "20180905", "SDID1","%"));
        }

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
                ErrorLog.LogError(Ex);
                return Content("Can't Access the Location of the File");
            }
        }

        public ActionResult Cancel_Doc(string Ref,string Client,string Doctype)
        {
            ViewBag.Ref_ID = Ref;
            ViewBag.Doc_ID = Doctype;
            ViewBag.Client_ID = Client;
            return PartialView("P_CancelDocument");

        }
        [HttpPost]
        public JsonResult Cancel_Doc(M_CancelDocument Model)
        {
            Model.CanceledBy = _session.User_Id;
            Model.InvoicNo = "SDID1";// should come from the app config InvoiceID for Invoice
            bool re = objCncl.setCertificateCancelation(Model);
            //var result = new { Msg = output, CID = ID };
            return Json(re, JsonRequestBehavior.AllowGet);
        }

    }
}
