﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Utility
{
    public class Rejectitem
    {
      string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
      public List<M_Reject> getReasons(string RejectCode)
      {
          try
          {

              List<M_Reject> lstreason = new List<M_Reject>();
              using (DBLinqDataContext datacontext = new DBLinqDataContext())
              {
                  datacontext.Connection.ConnectionString = Connection_;
                  System.Data.Linq.ISingleResult<_getRejectReasonsResult> lst = datacontext._getRejectReasons(RejectCode);

                  foreach (_getRejectReasonsResult result in lst)
                  {
                      M_Reject r = new M_Reject();
                      r.Reject_ReasonId = result.RejectCode;
                      r.Reject_ReasonName = result.ReasonName;
                      lstreason.Add(r);

                  }
              }

              return lstreason;
          }
          catch (Exception ex)
          {
              ErrorLog.LogError(ex);
              return null;
          }
      }

      public List<M_RejectCategory> getReasonCategories()
      {
          try
          {

              List<M_RejectCategory> lstreason = new List<M_RejectCategory>();
              using (DBLinqDataContext datacontext = new DBLinqDataContext())
              {
                  datacontext.Connection.ConnectionString = Connection_;
                  System.Data.Linq.ISingleResult<_getRejectReasonCategoriesResult> lst = datacontext._getRejectReasonCategories();

                  foreach (_getRejectReasonCategoriesResult result in lst)
                  {
                      M_RejectCategory r = new M_RejectCategory();
                      r.RejectCategoryId = result.RejectReasonsCategory;
                      r.RejectCategoryName = result.CategoryDescription;
                      lstreason.Add(r);

                  }
              }

              return lstreason;
          }
          catch (Exception ex)
          {
              ErrorLog.LogError(ex);
              return null;
          }
      }
    }
}