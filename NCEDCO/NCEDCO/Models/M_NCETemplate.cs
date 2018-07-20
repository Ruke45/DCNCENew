using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_NCETemplate
    {
        string TemplateName;

        public string Template_Name
        {
            get { return TemplateName; }
            set { TemplateName = value; }
        }
        string TemplateId;

        public string Template_Id
        {
            get { return TemplateId; }
            set { TemplateId = value; }
        }
        string CreatedBy;

        public string Created_By
        {
            get { return CreatedBy; }
            set { CreatedBy = value; }
        }

        string IsActive;

        public string Is_Active
        {
            get { return IsActive; }
            set { IsActive = value; }
        }
        string ModifiedBy;

        public string Modified_By
        {
            get { return ModifiedBy; }
            set { ModifiedBy = value; }
        }
        string ImgUrl;

        public string Img_Url
        {
            get { return ImgUrl; }
            set { ImgUrl = value; }
        }
        string Description;

        public string Description_
        {
            get { return Description; }
            set { Description = value; }
        }

        string ClientID;

        public string ClientID_
        {
            get { return ClientID; }
            set { ClientID = value; }
        }
    }
}