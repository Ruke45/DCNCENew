using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Net.Mail;

namespace NCEDCO.Models.Utility
{
    public class MailSender
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        public int SendEmail(string To, string Subject, string Body, string Attachment_Path)
        {
            try
            {
                string DECKey = System.Configuration.ConfigurationManager.AppSettings["DecKey"];
                List<M_Parameters> Eb = getEmailSendParamters();

                string EBCR_EMAIL = Eb[0].Parameter_Value;

                string DecryptID = DECKey.Substring(10);
                string EBCRE_PASS = Encrypt_Decrypt.Decrypt(Eb[1].Parameter_Value, DecryptID);

                string EBCRM_SMTP = Eb[2].Parameter_Value;
                int EBCRM_SMTP_PORT = Convert.ToInt32(Eb[3].Parameter_Value);

                if (EBCR_EMAIL.Equals("") || EBCRE_PASS.Equals("") || EBCRM_SMTP.Equals("") || EBCRM_SMTP_PORT.Equals(0))
                {
                    return 2;
                }
                MailMessage mail = new MailMessage();
                SmtpClient SmtpServer = new SmtpClient(EBCRM_SMTP);//"smtp.live.com"
                mail.From = new System.Net.Mail.MailAddress(EBCR_EMAIL);
                mail.To.Add(To);
                mail.Subject = Subject;
                mail.IsBodyHtml = true;
                mail.Body = Body;

                //System.Net.Mail.Attachment attachment;
                //attachment = new System.Net.Mail.Attachment(Attachment_Path);
                //mail.Attachments.Add(attachment);

                SmtpServer.Port = EBCRM_SMTP_PORT;
                SmtpServer.Credentials = new System.Net.NetworkCredential(EBCR_EMAIL, EBCRE_PASS);
                SmtpServer.EnableSsl = true;

                SmtpServer.Send(mail);
                return 1;
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError("Mail Send Faild (MailSendManager->SendEmail())", Ex);
                return 0;
            }

        }

        private List<M_Parameters> getEmailSendParamters()
        {
            try
            {
                List<M_Parameters> ParaList = new List<M_Parameters>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<DCISgeMailParametersResult> lst = datacontext.DCISgeMailParameters();
                    foreach (DCISgeMailParametersResult result in lst)
                    {
                        M_Parameters Para = new M_Parameters(result.ParameterCode, result.ParameterValue);
                        ParaList.Add(Para);
                    }
                }
                return ParaList;

            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }

        }
    }
}