using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_ProductOwner
    {
        string ContactPerson;
        [Display(Name = "Contact Person")]
        [Required(ErrorMessage = "Required!")]
        public string Contact_Person
        {
            get { return ContactPerson; }
            set { ContactPerson = value; }
        }

        string Email;
        [Display(Name = "Email")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.EmailAddress)]
        public string Email_
        {
            get { return Email; }
            set { Email = value; }
        }

        string Web;
        [Display(Name = "Web")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.Url)]
        public string Web_
        {
            get { return Web; }
            set { Web = value; }
        }

        string Fax;
        [Display(Name = "Fax")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.PhoneNumber)]
        public string Fax_
        {
            get { return Fax; }
            set { Fax = value; }
        }

        string Telephone;
        [Display(Name = "Telephone")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.PhoneNumber)]
        public string Telephone_
        {
            get { return Telephone; }
            set { Telephone = value; }
        }

        [Display(Name = "Name Of Organization")]
        [Required(ErrorMessage = "Required!")]
        public string Organization { get; set; }

        [Display(Name = "PO Box")]
        [Required(ErrorMessage = "Required!")]
        public string PO_BOX { get; set; }

        [Display(Name = "Address 1")]
        [Required(ErrorMessage = "Required!")]
        public string Address1 { get; set; }

        [Display(Name = "Address 2")]
        [Required(ErrorMessage = "Required!")]
        public string Address2 { get; set; }

        [Display(Name = "Address 3")]
        [Required(ErrorMessage = "Required!")]
        public string Address3 { get; set; }

      
    }
}