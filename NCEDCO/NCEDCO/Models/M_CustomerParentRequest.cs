using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_CustomerParentRequest : M_CustomerParent
    {
        System.Data.Linq.ISingleResult<DCISgetParentCustomerRequestListResult> ParentCustomerList;

        public System.Data.Linq.ISingleResult<DCISgetParentCustomerRequestListResult> Parent_Customerlist
        {
            get { return ParentCustomerList; }
            set { ParentCustomerList = value; }
        } 
    }
}