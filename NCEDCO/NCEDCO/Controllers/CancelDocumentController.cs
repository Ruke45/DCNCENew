﻿using NCEDCO.Filters;
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

        [UserFilter(Function_Id = "F_CANCL_INDX")]
        public ActionResult Index()
        {
            return View(objCncl.getDocumentCancelList("%", "A", DateTime.Now.AddDays(-30).ToString("yyyyMMdd"), 
                                                      DateTime.Now.ToString("yyyyMMdd"), "SDID1", "%"));
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

        [UserFilter(Function_Id = "F_CANCL_DOC")]
        [HttpPost]
        public JsonResult Cancel_Doc(M_CancelDocument Model)
        {
            Model.CanceledBy = _session.User_Id;
            Model.InvoicNo = "SDID1";// should come from the app config InvoiceID for Invoice
            bool re = objCncl.setCertificateCancelation(Model);
            //var result = new { Msg = output, CID = ID };
            return Json(re, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_CANCL_CANCLED")]
        public ActionResult Canceled()
        {
            ViewBag.Fdate = DateTime.Now.AddDays(-30).ToString("dd/MMM/yyyy");
            ViewBag.Tdate = DateTime.Now.ToString("dd/MMM/yyyy");
            return View(objCncl.getCancelCertificate(DateTime.Now.AddDays(-30).ToString("yyyyMMdd"),
                                                     DateTime.Now.ToString("yyyyMMdd"), "%", "%"));
        }

        [UserFilter(Function_Id = "F_CANCL_CANCLED")]
        [AllowAnonymous]
        public ActionResult CanceledD(DateTime fdate,DateTime tdate)
        {
            ViewBag.Fdate = fdate.ToString("dd/MMM/yyyy");
            ViewBag.Tdate = tdate.ToString("dd/MMM/yyyy");
            return View("Canceled", objCncl.getCancelCertificate(fdate.ToString("yyyyMMdd"), tdate.ToString("yyyyMMdd"), "%", "%"));
        }

    }
}
