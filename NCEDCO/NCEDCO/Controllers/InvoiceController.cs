using NCEDCO.Models;
using NCEDCO.Models.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NCEDCO.Controllers
{
    public class InvoiceController : Controller
    {
        //
        // GET: /Invoice/
        B_Customer CustomerOBj = new B_Customer();
        B_Invoice objInv = new B_Invoice();
        public ActionResult Index()
        {
            List<M_CustomerParent> par = CustomerOBj.getAllParents();
            ViewBag.ParentsIDs = new SelectList(par, "Parent_Id", "Customer_Name"); 

            return View();
        }

        public ActionResult getAllPendingInvoice(DateTime S, DateTime E, string P)
        {
            return PartialView("P_InvoiceCustomers"
                , objInv.getAllInvoice(S.ToString("yyyyMMdd"), E.ToString("yyyyMMdd"), "A", P));
        }
    }
}
