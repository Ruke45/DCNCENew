using NCEDCO.Models.Business;
using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace NCEDCO.Filters
{
    public class UserFilter : ActionFilterAttribute
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        public string Function_Id { get; set; }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            _USession _session = new _USession();
            B_Users objU = new B_Users();

            if (_session.User_Id != "" || _session.User_Group != "")
            {
                if (!objU.checkAuthorization(_session.User_Group,Function_Id))
                {
                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary
                    {
                        {"controller", "Home"},
                        {"action", "Error"}
                    });

                }
            }
            else
            {
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary
            {
                {"controller", "Home"},
                {"action", "Login"}
            });
            }
            base.OnActionExecuting(filterContext);
        }
    }
}