USE [master]
GO
/****** Object:  Database [NCEDCO]    Script Date: 11/8/2018 11:37:47 AM ******/
CREATE DATABASE [NCEDCO]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NCEDCO', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\NCEDCO.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'NCEDCO_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\NCEDCO_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [NCEDCO] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NCEDCO].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NCEDCO] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NCEDCO] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NCEDCO] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NCEDCO] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NCEDCO] SET ARITHABORT OFF 
GO
ALTER DATABASE [NCEDCO] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [NCEDCO] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [NCEDCO] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NCEDCO] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NCEDCO] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NCEDCO] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NCEDCO] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NCEDCO] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NCEDCO] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NCEDCO] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NCEDCO] SET  ENABLE_BROKER 
GO
ALTER DATABASE [NCEDCO] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NCEDCO] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NCEDCO] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NCEDCO] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NCEDCO] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NCEDCO] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NCEDCO] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NCEDCO] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [NCEDCO] SET  MULTI_USER 
GO
ALTER DATABASE [NCEDCO] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NCEDCO] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NCEDCO] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NCEDCO] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [NCEDCO]
GO
/****** Object:  StoredProcedure [dbo].[_CheckTemplateSupportDoc]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[_CheckTemplateSupportDoc](@SupportingDocid varchar(20),@TemplateId varchar(20))
as begin
Select Count(TemplateSupportingDocument) as Count_ from tblTemplateSupportingDocument
where SupportingDocumentId like @SupportingDocid
and TemplateId like @TemplateId
End

GO
/****** Object:  StoredProcedure [dbo].[_getAllCertificateCancelDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_getAllCertificateCancelDetails] 
	(@CustomerId varchar(20), @Status varchar(1), @startdate varchar(8), @enddate varchar(8),@invoiceSupDoc varchar(20),@refNo varchar(20))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@refNo ='%')
	SELECT
	A.CertificateId as Ref_,C.CustomerName,A.CreatedDate as Approve_Date,'CO' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.CreatedBy as Approved_by,a.CertificatePath as Path_,a.IsDownloaded,a.RequestId as Req_id,C.CustomerId
	FROM tblCertificate A,tblCertifcateRequestHeader B,tblCustomer C , tblCustomerParent P
	WHERE A.RequestId=B.RequestId
	AND P.ParentCustomerId = C.ParentCustomerId
	AND C.CustomerId like @CustomerId
	AND A.CertificateId NOT in (SELECT DocumentId FROM tblCancelledcertificate )
	AND B.RequestId NOT in (SELECT RequestNo FROM tblInvoiceDetail)
	AND B.CustomerId=C.CustomerId
	AND convert(varchar,A.CreatedDate,112) >=@startdate
	and convert(varchar,A.CreatedDate,112) <=@enddate

	UNION

	SELECT
	A.CertificateId as Ref_,C.CustomerName,A.CreatedDate as Approve_Date,'CO' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.CreatedBy as Approved_by,a.CertificatePath as Path_,a.IsDownloaded,a.RequestId as Req_id,C.CustomerId
	FROM 
	tblCertificate A,tblUploadBasedCertificateRequest B,tblCustomer C , tblCustomerParent P
	WHERE A.RequestId=B.RequestId
	AND B.RequestId NOT in (SELECT RequestNo FROM tblInvoiceDetail)
	AND A.CertificateId NOT in (SELECT DocumentId FROM tblCancelledcertificate)
	AND B.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND C.CustomerId like @CustomerId
	AND convert(varchar,A.CreatedDate,112) >=@startdate
	and convert(varchar,A.CreatedDate,112) <=@enddate
	
	UNION
	
	SELECT
	A.RequestID as Ref_,C.CustomerName,A.ApprovedDate as Approve_Date,'Other Document' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.ApprovedBy as Approved_by,a.DownloadPath as Path_,a.IsDownloaded,a.CertificateRequestId as Req_id,C.CustomerId
	FROM tblSupportingDocApproveRequest A,tblCustomer C, tblCustomerParent P
	WHERE A.Status=@Status
	AND A.SupportingDocID!=@invoiceSupDoc
	AND A.RequestId NOT in (SELECT SupportingDocName FROM tblInvoiceRate)
	AND A.RequestID NOT in (SELECT DocumentId FROM tblCancelledcertificate)
	AND A.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND C.CustomerId like @CustomerId
	AND convert(varchar,A.ApprovedDate,112) >=@startdate
	and convert(varchar,A.ApprovedDate,112) <=@enddate
	
	UNION
	
	SELECT A.RequestID as Ref_,C.CustomerName,A.ApprovedDate as Approve_Date,'Invoice' As docTypes,'Invoice' As Invoice, P.CustomerName as Parent, a.ApprovedBy as Approved_by,a.DownloadPath as Path_,a.IsDownloaded,a.CertificateRequestId as Req_id,C.CustomerId
	FROM tblSupportingDocApproveRequest A,tblCustomer C, tblCustomerParent P
	WHERE A.Status=@Status
	AND A.SupportingDocID=@invoiceSupDoc
	AND A.RequestId NOT in (SELECT SupportingDocName FROM tblInvoiceRate)
	AND A.RequestID NOT in(SELECT DocumentId FROM tblCancelledcertificate)
	AND A.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND C.CustomerId like @CustomerId
	AND convert(varchar,A.ApprovedDate,112) >=@startdate
	and convert(varchar,A.ApprovedDate,112) <=@enddate

	UNION

	SELECT A.CertificateId as Ref_,C.CustomerName,A.CreatedDate as Approve_Date,'CO' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.CreatedBy as Approved_by,a.CertificatePath as Path_,a.IsDownloaded,a.RequestId as Req_id,C.CustomerId
	FROM tblCertificate A,tblCertifcateRequestHeader B,tblCustomer C, tblCustomerParent P
	WHERE A.RequestId=B.RequestId
	AND C.CustomerId like @CustomerId
	AND A.CertificateId NOT In (SELECT DocumentId FROM tblCancelledcertificate)
	AND B.RequestId  in (SELECT D.RequestNo FROM tblInvoiceDetail D)
	AND B.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND convert(varchar,A.CreatedDate,112) >=@startdate
	and convert(varchar,A.CreatedDate,112) <=@enddate

	UNION

	SELECT A.CertificateId as Ref_,C.CustomerName,A.CreatedDate as Approve_Date,'CO' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.CreatedBy as Approved_by,a.CertificatePath as Path_,a.IsDownloaded,a.RequestId as Req_id,C.CustomerId
	FROM tblCertificate A,tblUploadBasedCertificateRequest B,tblCustomer C, tblCustomerParent P
	WHERE A.RequestId=B.RequestId
	AND B.RequestId  in(SELECT D.RequestNo FROM tblInvoiceDetail D)
	AND A.CertificateId NOT in(SELECT D.DocumentId FROM tblCancelledcertificate D)
	AND B.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND C.CustomerId like @CustomerId
	AND convert(varchar,A.CreatedDate,112) >=@startdate
	and convert(varchar,A.CreatedDate,112) <=@enddate
	
	UNION
	
	SELECT A.RequestID as Ref_,C.CustomerName,A.ApprovedDate as Approve_Date,'Other Document' As docTypes,'Invoice' As Invoice, P.CustomerName as Parent, a.ApprovedBy as Approved_by,a.DownloadPath as Path_,a.IsDownloaded,a.CertificateRequestId as Req_id,C.CustomerId
	FROM tblSupportingDocApproveRequest A,tblCustomer C, tblCustomerParent P
	WHERE A.Status=@Status
	AND A.SupportingDocID!=@invoiceSupDoc
	AND A.RequestId  in (SELECT SupportingDocName FROM tblInvoiceRate)
	AND A.RequestID NOT in (SELECT DocumentId FROM tblCancelledcertificate)
	AND A.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND C.CustomerId like @CustomerId
	AND convert(varchar,A.ApprovedDate,112) >=@startdate
	and convert(varchar,A.ApprovedDate,112) <=@enddate

	UNION

	SELECT A.RequestID as Ref_,C.CustomerName,A.ApprovedDate as Approve_Date,'Invoice' As docTypes,'Invoice' As Invoice, P.CustomerName as Parent, a.ApprovedBy as Approved_by,a.DownloadPath as Path_,a.IsDownloaded,a.CertificateRequestId as Req_id,C.CustomerId
	FROM tblSupportingDocApproveRequest A,tblCustomer C,tblCustomerParent P
	WHERE A.Status=@Status
	AND A.SupportingDocID=@invoiceSupDoc
	AND A.RequestId  in(SELECT SupportingDocName FROM tblInvoiceRate)
	AND A.RequestID NOT in(SELECT DocumentId FROM tblCancelledcertificate)
    AND A.CustomerId=C.CustomerId
	AND C.ParentCustomerId =C.ParentCustomerId
	AND C.CustomerId like @CustomerId
	AND convert(varchar,A.ApprovedDate,112) >=@startdate
	and convert(varchar,A.ApprovedDate,112) <=@enddate

	else ----/----------------------/

	SELECT A.CertificateId as Ref_,C.CustomerName,A.CreatedDate as Approve_Date,'CO' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.CreatedBy as Approved_by,a.CertificatePath as Path_,a.IsDownloaded,a.RequestId as Req_id,C.CustomerId
	FROM tblCertificate A,tblCertifcateRequestHeader B,tblCustomer C, tblCustomerParent P
	WHERE A.RequestId=B.RequestId
	AND A.CertificateId=@refNo
	AND A.CertificateId NOT in(SELECT DocumentId FROM tblCancelledcertificate )
	AND B.RequestId NOT in (SELECT RequestNo FROM tblInvoiceDetail)
	AND B.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId

	UNION
	
	SELECT A.CertificateId as Ref_,C.CustomerName,A.CreatedDate as Approve_Date,'CO' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.CreatedBy as Approved_by,a.CertificatePath as Path_,a.IsDownloaded,a.RequestId as Req_id,C.CustomerId
	FROM tblCertificate A,tblUploadBasedCertificateRequest B,tblCustomer C, tblCustomerParent P
	WHERE A.RequestId=B.RequestId
	AND B.RequestId NOT in(SELECT RequestNo FROM tblInvoiceDetail)
	AND A.CertificateId NOT in (SELECT DocumentId FROM tblCancelledcertificate)
	AND B.CustomerId=C.CustomerId
	AND P.ParentCustomerId = C.ParentCustomerId
	AND A.CertificateId=@refNo
	
	UNION
	
	SELECT A.RequestID as Ref_,C.CustomerName,A.ApprovedDate as Approve_Date,'Other Document' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.ApprovedBy as Approved_by,a.DownloadPath as Path_,a.IsDownloaded,a.CertificateRequestId as Req_id,C.CustomerId
	FROM tblSupportingDocApproveRequest A,tblCustomer C, tblCustomerParent P
	WHERE A.Status=@Status
	AND A.SupportingDocID!=@invoiceSupDoc
	AND A.RequestId NOT in(SELECT SupportingDocName FROM tblInvoiceRate)
	AND A.RequestID NOT in(SELECT DocumentId FROM tblCancelledcertificate)
	AND A.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND A.RequestID=@refNo
	
	UNION

	SELECT A.RequestID as Ref_,C.CustomerName,A.ApprovedDate as Approve_Date,'Invoice' As docTypes,'Invoice' As Invoice, P.CustomerName as Parent, a.ApprovedBy as Approved_by,a.DownloadPath as Path_,a.IsDownloaded,a.CertificateRequestId as Req_id,C.CustomerId
	FROM tblSupportingDocApproveRequest A,tblCustomer C , tblCustomerParent P
	WHERE A.Status=@Status
	AND A.SupportingDocID=@invoiceSupDoc
	AND A.RequestId NOT in(SELECT SupportingDocName FROM tblInvoiceRate)
	AND A.RequestID NOT in(SELECT DocumentId FROM tblCancelledcertificate)
	AND A.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND A.RequestID=@refNo

	UNION

	SELECT A.CertificateId as Ref_,C.CustomerName,A.CreatedDate as Approve_Date,'CO' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.CreatedBy as Approved_by,a.CertificatePath as Path_,a.IsDownloaded,a.RequestId as Req_id,C.CustomerId
	FROM tblCertificate A,tblCertifcateRequestHeader B,tblCustomer C, tblCustomerParent P
	WHERE A.RequestId=B.RequestId
	AND A.CertificateId=@refNo
	AND A.CertificateId NOT In(SELECT DocumentId FROM tblCancelledcertificate)
	AND B.RequestId  in(SELECT D.RequestNo FROM tblInvoiceDetail D)
	AND B.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	
	UNION
	SELECT A.CertificateId as Ref_,C.CustomerName,A.CreatedDate as Approve_Date,'CO' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.CreatedBy as Approved_by,a.CertificatePath as Path_,a.IsDownloaded,a.RequestId as Req_id,C.CustomerId
	FROM tblCertificate A,tblUploadBasedCertificateRequest B,tblCustomer C , tblCustomerParent P
	WHERE A.RequestId=B.RequestId
	AND B.RequestId  in(SELECT D.RequestNo FROM tblInvoiceDetail D)
	AND A.CertificateId NOT in(SELECT D.DocumentId FROM tblCancelledcertificate D)
	AND B.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND A.CertificateId=@refNo

	UNION
	
	SELECT A.RequestID as Ref_,C.CustomerName,A.ApprovedDate as Approve_Date,'Other Document' As docTypes,'Not A Invoice' As Invoice, P.CustomerName as Parent, a.ApprovedBy as Approved_by,a.DownloadPath as Path_,a.IsDownloaded,a.CertificateRequestId as Req_id,C.CustomerId
	FROM tblSupportingDocApproveRequest A,tblCustomer C , tblCustomerParent P
	WHERE A.Status=@Status
	AND A.SupportingDocID!=@invoiceSupDoc
	AND A.RequestId  in(SELECT SupportingDocName FROM tblInvoiceRate)
	AND A.RequestID NOT in(SELECT DocumentId FROM tblCancelledcertificate)
	AND A.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND A.RequestID=@refNo

	UNION
	
	SELECT A.RequestID as Ref_,C.CustomerName,A.ApprovedDate as Approve_Date,'Invoice' As docTypes,'Invoice' As Invoice , P.CustomerName as Parent, a.ApprovedBy as Approved_by,a.DownloadPath as Path_,a.IsDownloaded,a.CertificateRequestId as Req_id,C.CustomerId
	FROM tblSupportingDocApproveRequest A,tblCustomer C , tblCustomerParent P
	WHERE A.Status=@Status
	AND A.SupportingDocID=@invoiceSupDoc
	AND A.RequestId  in(SELECT SupportingDocName FROM tblInvoiceRate)
	AND A.RequestID NOT in(SELECT DocumentId FROM tblCancelledcertificate)
    AND A.CustomerId=C.CustomerId
	AND C.ParentCustomerId = P.ParentCustomerId
	AND A.RequestID=@refNo
	
END

GO
/****** Object:  StoredProcedure [dbo].[_getAllExportSector]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_getAllExportSector] 
	(@Status varchar(1))
AS
BEGIN
	SELECT 
	ExportSector,ExportId
	FROM
	tblExportSector
	WHERE
	Status=@Status
END






GO
/****** Object:  StoredProcedure [dbo].[_getAllInvoice]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_getAllInvoice] 
(@startdate varchar(8),@enddate varchar(8),@Status varchar(1),@ParentId varchar(20))
AS
BEGIN
Select
a.CustomerId,
a.CustomerName
From tblCustomer a,tblCertifcateRequestHeader b,tblCertificate c, tblCustomerParent P
Where a.CustomerId = b.CustomerId
And a.ParentCustomerId = P.ParentCustomerId
And b.Status=@Status
And a.ParentCustomerId like @ParentId
And C.CertificateId NOT in (SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=C.CertificateId)
And b.RequestId
Not In (SELECT e.RequestNo FROM tblInvoiceDetail e WHERE e.RequestNo=b.RequestId)
And b.RequestId= c.RequestId
And convert(varchar,b.CreatedDate,112) >=@startdate
And convert(varchar,b.CreatedDate,112) <=@enddate

Group By a.CustomerId, a.CustomerName

UNION

Select
a.CustomerId,
a.CustomerName
From tblCustomer a,tblSupportingDocApproveRequest b, tblCustomerParent P
Where a.CustomerId = b.CustomerId
And a.ParentCustomerId = P.ParentCustomerId
And b.Status=@Status
And a.ParentCustomerId like @ParentId
And b.RequestID NOT in (SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=b.RequestID)
And b.RequestId
Not in (SELECT e.SupportingDocName FROM tblInvoiceRate e WHERE e.SupportingDocName=b.RequestId)
And convert(varchar,b.ApprovedDate,112) >=@startdate
And convert(varchar,b.ApprovedDate,112) <=@enddate

Group By a.CustomerId, a.CustomerName

UNION
Select a.CustomerId,a.CustomerName
From tblCustomer a,tblUploadBasedCertificateRequest b,tblCertificate C, tblCustomerParent P
Where a.CustomerId = b.CustomerId
And a.ParentCustomerId = P.ParentCustomerId
And b.Status=@Status
And a.ParentCustomerId like @ParentId
And C.RequestId=b.RequestId
AND C.CertificateId NOT in (SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=C.CertificateId)
And b.RequestId
Not in (SELECT e.RequestNo FROM tblInvoiceDetail e WHERE e.RequestNo=b.RequestId)
And convert(varchar,b.CreatedDate,112) >=@startdate
And convert(varchar,b.CreatedDate,112) <=@enddate

Group By a.CustomerId, a.CustomerName

END








GO
/****** Object:  StoredProcedure [dbo].[_getAllParentCustomers]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[_getAllParentCustomers]
as begin
Select ParentCustomerId,CustomerName
from tblCustomerParent
where Status like 'A'
End
GO
/****** Object:  StoredProcedure [dbo].[_getAllParentCustomersDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/

Create Proc [dbo].[_getAllParentCustomersDetails]
as begin
SELECT [ParentCustomerId]
      ,[CustomerName]
      ,[Telephone]
      ,[IsSVat]
      ,[Fax]
      ,[Email]
      ,[Address1]
      ,[Address2]
      ,[Address3]
      ,[Status]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[ContactPersonName]
      ,[ContactPersonDesignation]
      ,[ContactPersonDirectPhoneNumber]
      ,[ContactPersonMobile]
      ,[ContactPersonEmail]
      ,[NCEMember]
      ,[PaidType]
      ,[RequestId]
  FROM [NCEDCO].[dbo].[tblCustomerParent]
  End

GO
/****** Object:  StoredProcedure [dbo].[_getBackendSystemUsers]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[_getBackendSystemUsers]
as begin
Select  UserID, G.GroupName as UserGroupID, PersonName, U.CreatedBy, U.CreatedDate, U.IsActive, Designation, Email
From tblUser U, tblUserGroup G
Where UserGroupID != 'CADMIN'
And UserID != 'Admin'
And U.UserGroupID = G.GroupId
End
GO
/****** Object:  StoredProcedure [dbo].[_getCanceleCertificate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_getCanceleCertificate]
	(@startDate varchar(8),@enddate varchar(8),@CustomerId varchar(20),@refNo varchar(20))
AS
BEGIN
if(@refNo='%')
SELECT A.DocumentId,B.CustomerName,A.Remark,A.CancelBy,A.CancelDate,A.DocumentType, p.CustomerName AS Parent FROM
tblCancelledcertificate A,tblCustomer B, tblCustomerParent P
WHERE A.CustomerId=B.CustomerId
AND P.ParentCustomerId = b.ParentCustomerId
AND A.CustomerId like @CustomerId
and convert(varchar,A.CancelDate,112) >=@startdate
and convert(varchar,A.CancelDate,112) <=@enddate
else
SELECT A.DocumentId,B.CustomerName,A.Remark,A.CancelBy,A.CancelDate,A.DocumentType , P.CustomerName as Parent FROM
tblCancelledcertificate A,tblCustomer B, tblCustomerParent P
WHERE A.CustomerId=B.CustomerId
and B.ParentCustomerId = P.ParentCustomerId
AND A.DocumentId=@refNo



END



GO
/****** Object:  StoredProcedure [dbo].[_getCertificateRequestStatus]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[_getCertificateRequestStatus] 
	(@RequestId varchar(20),@CustomerId varchar(20),@Status varchar(3),@StartDate varchar(10),@EndDate varchar(10),@type varchar(10),@InvoiceNo varchar(20))
AS
BEGIN
if(@type like'Document')
Select 'Document' as 'Method', B.RequestId,B.CustomerId,B.Status,B.RequestDate AS CreatedDate,C.CustomerName,B.RejectReasonCode,'None' as InvoiceNo,P.CustomerName As Parent	
FROM tblSupportingDocApproveRequest B,tblCustomer C,tblCustomerParent P
WHERE C.CustomerId=B.CustomerId
and B.Status like @Status
and B.CustomerId like @CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.RequestId like @RequestId
and  isnull(b.RequestID,'') NOT in(SELECT DocumentId FROM tblCancelledcertificate  )
and B.CustomerId like @CustomerId
and convert(varchar,B.RequestDate,112)>=@StartDate
and convert(varchar,B.RequestDate,112)<=@EndDate
order by B.RequestDate desc

if(@type like'Uploaded')
Select'Uploaded Certificate' as 'Method',B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.RejectReasonCode,b.InvoiceNo,P.CustomerName As Parent	
FROM tblUploadBasedCertificateRequest B,tblCustomer C,tblCustomerParent P
WHERE isnull(b.CertificateId,'')NOT in(SELECT DocumentId FROM tblCancelledcertificate  )
and C.CustomerId=B.CustomerId
and B.Status like @Status
and B.CustomerId like  @CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.RequestId like @RequestId
and B.CustomerId like  @CustomerId
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
order by B.CreatedDate desc

if( @Status = 'P' and @type='Normal'   )
Select'Normal Certificate' as 'Method',	B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.ReasonCode,b.InvoiceNo,P.CustomerName As Parent	
FROM tblCertifcateRequestHeader B,tblCustomer C,tblCustomerParent P
WHERE C.CustomerId=B.CustomerId
and B.Status like 'G'
and B.CustomerId like @CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.RequestId like @RequestId
and B.InvoiceNo like @InvoiceNo 
and B.CustomerId like @CustomerId
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
order by B.CreatedDate desc

if(@type='Normal' and @Status like '%' and @Status != 'P'  )
Select	'Normal Certificate' as 'Method',B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.ReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader B,tblCustomer C,tblCustomerParent P
WHERE C.CustomerId=B.CustomerId
and B.Status like @Status
and b.Status !='P'
and B.status !='A'
and B.CustomerId like @CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.RequestId like @RequestId
and B.InvoiceNo like @InvoiceNo 
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate

union
Select'Normal Certificate' as 'Method',	
B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.ReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader B,tblCustomer C,tblCertificate d,tblCustomerParent P
WHERE b.RequestId=d.RequestId and
isnull(d.CertificateId,'')	 NOT in
(SELECT DocumentId FROM tblCancelledcertificate  ) 
and C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like @Status
and B.status ='A'
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and B.InvoiceNo like @InvoiceNo 
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
order by B.CreatedDate desc

if(@type like '%' and @Status = '%')
Select'Normal Certificate' as 'Method',B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.ReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader B,tblCustomer C,tblCustomerParent P
WHERE C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like @Status
and b.Status !='P'
and B.Status !='A'
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and B.InvoiceNo like @InvoiceNo 
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
union
Select'Normal Certificate' as 'Method',	B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.ReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader B,tblCustomer C,tblCertificate D,tblCustomerParent P
WHERE b.RequestId=d.RequestId 
and isnull(d.CertificateId,'') NOT in(SELECT  DocumentId FROM tblCancelledcertificate  )
and C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and b.Status !='P'
and B.Status ='A'
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and B.InvoiceNo like @InvoiceNo 
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
Union
Select	'Document' as 'Method',B.RequestId,B.CustomerId,B.Status,B.RequestDate,C.CustomerName,B.RejectReasonCode,'None' as InvoiceNo,P.CustomerName As Parent
FROM tblSupportingDocApproveRequest B,tblCustomer C,tblCustomerParent P
WHERE C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like @Status
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and  isnull(b.RequestID,'')  NOT in(SELECT DocumentId FROM tblCancelledcertificate  ) 
and B.CustomerId like   @CustomerId
and convert(varchar,B.RequestDate,112)>=@StartDate
and convert(varchar,B.RequestDate,112)<=@EndDate
union
Select'Uploaded Certificate' as 'Method',	B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.RejectReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader A,tblUploadBasedCertificateRequest B,tblCustomer C,tblCustomerParent P
WHERE isnull(b.CertificateId,'')  NOT in(SELECT DocumentId FROM tblCancelledcertificate  )
and C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like  @Status
and B.CustomerId like @CustomerId 
and B.RequestId like @RequestId
and B.CustomerId like @CustomerId
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
order by CreatedDate desc

if(@type like '%' and @Status != 'P' and  @Status != '%' )
Select'Normal Certificate' as 'Method',B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.ReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader B,tblCustomer C,tblCustomerParent P
WHERE C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like  @Status
and B.status !='G'
and B.status !='P'
and b.status !='A'
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and B.InvoiceNo like @InvoiceNo 
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
union
Select'Normal Certificate' as 'Method', B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.ReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader B,tblCustomer C,tblCertificate d,tblCustomerParent P
WHERE b.RequestId=d.RequestId and
isnull(d.CertificateId,'') NOT in(SELECT DocumentId FROM tblCancelledcertificate  ) 
and C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like  @Status
and B.status !='G'
and B.status !='P'
and b.status ='A'
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and B.InvoiceNo like @InvoiceNo 
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
Union 
Select'Document' as 'Method',B.RequestId,B.CustomerId,B.Status,B.RequestDate,C.CustomerName,B.RejectReasonCode,'None' as InvoiceNo,P.CustomerName As Parent
FROM tblSupportingDocApproveRequest B,tblCustomer C,tblCustomerParent P
WHERE C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like @Status
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and  isnull(b.RequestID,'')  NOT in
(SELECT DocumentId FROM tblCancelledcertificate  )
and B.CustomerId like   @CustomerId
and convert(varchar,B.RequestDate,112)>=@StartDate
and convert(varchar,B.RequestDate,112)<=@EndDate
union
Select'Uploaded Certificate' as 'Method',	
B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.RejectReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader A,tblUploadBasedCertificateRequest B,tblCustomer C,tblCustomerParent P
WHERE isnull(b.CertificateId,'') NOT in(SELECT DocumentId FROM tblCancelledcertificate  )
and C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like  @Status
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and B.CustomerId like @CustomerId
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
order by CreatedDate desc

if(@type like'%' and @Status = 'P')
Select	'Normal Certificate' as 'Method', B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.ReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader B,tblCustomer C,tblCustomerParent P
WHERE isnull(b.RequestId,'')  NOT in(SELECT  DocumentId FROM tblCancelledcertificate  )
and C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like 'G' --@Status
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and B.InvoiceNo like @InvoiceNo 
and B.CustomerId like @CustomerId
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
Union 
Select'Document' as 'Method',B.RequestId,B.CustomerId,B.Status,B.RequestDate,C.CustomerName,B.RejectReasonCode,'None' as InvoiceNo,P.CustomerName As Parent
FROM tblSupportingDocApproveRequest B,tblCustomer C,tblCustomerParent P
WHERE C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like @Status
and B.CustomerId like @CustomerId
and B.RequestId like @RequestId
and  isnull(b.RequestID,'')  NOT in
(SELECT DocumentId FROM tblCancelledcertificate  )
and B.CustomerId like   @CustomerId
and convert(varchar,B.RequestDate,112)>=@StartDate
and convert(varchar,B.RequestDate,112)<=@EndDate
union
Select'Uploaded Certificate' as 'Method',	B.RequestId,B.CustomerId,B.Status,B.CreatedDate,C.CustomerName,B.RejectReasonCode,b.InvoiceNo,P.CustomerName As Parent
FROM tblCertifcateRequestHeader A,tblUploadBasedCertificateRequest B,tblCustomer C,tblCustomerParent P
WHERE isnull(b.CertificateId,'') NOT in(SELECT DocumentId FROM tblCancelledcertificate)
and C.CustomerId=B.CustomerId
and C.ParentCustomerId = p.ParentCustomerId
and B.Status like  @Status
and B.CustomerId like @CustomerId 
and B.RequestId like @RequestId
and B.CustomerId like @CustomerId
and convert(varchar,B.CreatedDate,112)>=@StartDate
and convert(varchar,B.CreatedDate,112)<=@EndDate
order by CreatedDate desc
END




GO
/****** Object:  StoredProcedure [dbo].[_getCertificateStatus]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_getCertificateStatus] 
	(@CertificateNo varchar(20))
AS
BEGIN
	SELECT
	B.CustomerName,A.CreatedDate as InvoiceDate,A.Consignee,A.InvoiceNo,A.TotalInvoiceValue
	FROM
	tblCertifcateRequestHeader A,tblCustomer B,tblCertificate C
	WHERE
	A.CustomerId=B.CustomerId
	AND
	A.RequestId=c.RequestId
	AND
	A.Status='A'
	AND
	C.CertificateId=@CertificateNo
	AND
	C.CertificateId NOT in
	(SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=C.CertificateId)

	UNION
	SELECT
	B.CustomerName,A.CreatedDate as InvoiceDate,Null AS Consignee,A.InvoiceNo,NULL AS TotalInvoiceValue
	FROM
	tblUploadBasedCertificateRequest A,tblCustomer B
	WHERE
	A.CustomerId=B.CustomerId
	AND
	A.CertificateId=@CertificateNo
	AND
	
	A.CertificateId NOT in
	(SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=A.CertificateId)
	AND
	A.Status='A'	
END


GO
/****** Object:  StoredProcedure [dbo].[_getChildDeafaultRates]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[_getChildDeafaultRates](@Cid varchar(20))
as begin
Select RateId,RateName, 0.00 as RateValue, @Cid as CustomerId
From tblRates
Where Status like 'Y'
End
GO
/****** Object:  StoredProcedure [dbo].[_getClientCustomerDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[_getClientCustomerDetails](@ClientId varchar(20))
as begin
Select 
C.RequestId, 
C.CustomerName, 
C.Telephone, 
C.IsSVat ,
C.Fax, 
C.Email, 
C.Address1, 
C.Address2, 
C.Address3, 
C.Status, 
C.CreatedDate, 
C.CreatedBy, 
C.ContactPersonName, 
C.ContactPersonDesignation, 
C.ContactPersonDirectPhoneNumber, 
C.ContactPersonMobile, 
C.ContactPersonEmail, 
C.NCEMember, 
C.TemplateId,
H.TemplateName,
Productdetails,
C.ExportSector,
E.ExportSector as ExportSectorName,
C.ParentCustomerId,
P.CustomerName

from tblCustomer C, tblTemplateHeader H ,tblExportSector E ,  tblCustomerParent P
where C.CustomerId like @ClientId
and H.TemplateId = C.TemplateId
and E.ExportId = C.ExportSector
and P.ParentCustomerId = C.ParentCustomerId

End

GO
/****** Object:  StoredProcedure [dbo].[_getClientCustomerRequestDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[_getClientCustomerRequestDetails](@RequestID varchar(20))
as begin
Select 
C.RequestId, 
C.Name, 
C.Telephone, 
C.SVat ,
C.Fax, 
C.Email, 
C.Address1, 
C.Address2, 
C.Address3, 
C.Status, 
C.CreatedDate, 
C.CreatedBy, 
C.ContactPersonName, 
C.ContactPersonDesignation, 
C.ContactPersonDirectPhoneNumber, 
C.ContactPersonMobile, 
C.ContactPersonEmail, 
C.NCEMember, 
C.TemplateId,
H.TemplateName,
Productdetails,
C.ExportSector,
E.ExportSector as ExportSectorName,
C.ParentCustomerId,
P.CustomerName



from tblCustomerRequest C, tblTemplateHeader H ,tblExportSector E ,  tblCustomerParent P
where C.RequestId like @RequestID
and H.TemplateId = C.TemplateId
and E.ExportId = C.ExportSector
and P.ParentCustomerId = C.ParentCustomerId

End

GO
/****** Object:  StoredProcedure [dbo].[_getClientCustomerRequestList]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[_getClientCustomerRequestList](@Status varchar(5))
as begin
Select 
RequestId, 
Name,
Telephone, 
SVat,
Fax, 
Email, 
Address1, 
Address2, 
Address3, 
Status, 
CreatedDate, 
CreatedBy, 
ContactPersonName, 
ContactPersonDesignation, 
ContactPersonDirectPhoneNumber, 
ContactPersonMobile, 
ContactPersonEmail, 
NCEMember,
CreatedDate

from tblCustomerRequest
where Status like @Status

End

GO
/****** Object:  StoredProcedure [dbo].[_getCRequestSupportingDOC]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[_getCRequestSupportingDOC](@RequestID varchar(20))
as begin

Select
RequestRefNo, 
A.SupportingDocumentId,
B.SupportingDocumentName, 
Remarks, 
UploadedDate, 
UploadedBy, 
UploadedPath, 
UploadSeqNo,
DocumentName,
RequestDate,
SignatureRequired

from tblSupportingDOCUpload A, tblSupportingDocuments B,tblCertifcateRequestHeader C
where a.SupportingDocumentId = B.SupportingDocumentId
and a.RequestRefNo = c.RequestId
and C.RequestId = @RequestID

union
Select
RequestRefNo, 
A.SupportingDocumentId,
B.SupportingDocumentName, 
Remarks, 
UploadedDate, 
UploadedBy, 
UploadedPath, 
UploadSeqNo,
DocumentName,
RequestDate,
SignatureRequired

from tblSupportingDOCUpload A, tblSupportingDocuments B, tblUploadBasedCertificateRequest C
where a.SupportingDocumentId = B.SupportingDocumentId
and a.RequestRefNo = c.RequestId
and C.RequestId = @RequestID

End


GO
/****** Object:  StoredProcedure [dbo].[_getCustomerRateDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_getCustomerRateDetails]
	(@CustomerId varchar(20),@status varchar(1))
AS
BEGIN
	SELECT
	A.RateId,A.RateName,CAST(B.Rates AS decimal(18,2))as Rates,C.PaidType,B.CustomerId
	FROM
	tblRates A,tblCustomerApplicableRates B,tblCustomer C
	WHERE
	A.RateId=B.RatesId
	AND
	B.CustomerId=@CustomerId
	AND
	B.CustomerId=C.CustomerId
	AND
	A.Status=@status
END





GO
/****** Object:  StoredProcedure [dbo].[_getDownloadCertificate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[_getDownloadCertificate](@RequestId varchar(20),
@CustomerId varchar(20),@CertificateId varchar(10),@sealrequired varchar(10),@InvoiceNo varchar (20),@ParentId varchar(20))
AS
BEGIN
select
a.RequestId,
a.CertificateId,
a.CertificateName,
a.CertificatePath,
a.IsValid,
a.IsDownloaded,
a.ExpiryDate,
c.CustomerName,
b.RequestDate,
a.CreatedDate,
d.UserID,
b.CreatedBy,
b.SealRequired,
d.PersonName,
d.Designation,
b.InvoiceNo,
b.Consignor,
b.Consignee,
a.CreatedBy as created,
'WEB' as Ctype,
P.CustomerName as ParentName

from tblCertificate a,tblCertifcateRequestHeader b,tblCustomer c,tblUser d , tblCustomerParent P
where a.RequestId = b.RequestId 
and b.CustomerId like @CustomerId 
and b.CustomerId=c.CustomerId 
and a.RequestId like @RequestId 
and a.CertificateId NOT in (SELECT DocumentId FROM tblCancelledcertificate ) 
and c.ParentCustomerId=d.ParentCustomerId 
and b.CreatedBy=d.UserID --d.UserGroupID='CADMIN'
and c.ParentCustomerId = p.ParentCustomerId
and a.CertificateId like @CertificateId 
and b.SealRequired like @sealrequired
and b.InvoiceNo like @InvoiceNo
and C.ParentCustomerId like @ParentId
union


select
a.RequestId,
a.CertificateId,
a.CertificateName,
a.CertificatePath,
a.IsValid,
a.IsDownloaded,
a.ExpiryDate,
c.CustomerName,
b.RequestDate,
a.CreatedDate,
d.UserID,
b.CreatedBy,
b.SealRequired,
d.PersonName,
d.Designation,
b.InvoiceNo,
'N/A' as Consignor,

'N/A' as Consignee,
a.CreatedBy as created,
'UPLOAD' as Ctyp,
P.CustomerName as ParentName
from tblCertificate a,tblUploadBasedCertificateRequest b,tblCustomer c ,tblUser d,tblCustomerParent P
where a.RequestId = b.RequestId 
and b.CustomerId like @CustomerId  
and b.CustomerId=c.CustomerId 
and a.RequestId like @RequestId 
and a.CertificateId NOT in(SELECT DocumentId FROM tblCancelledcertificate ) 
and c.ParentCustomerId=d.ParentCustomerId 
and b.CreatedBy=d.UserID --d.UserGroupID='CADMIN'
and c.ParentCustomerId = p.ParentCustomerId
and a.CertificateId like @CertificateId 
and b.SealRequired like @sealrequired
and b.InvoiceNo like @InvoiceNo
and C.ParentCustomerId like @ParentId


END







GO
/****** Object:  StoredProcedure [dbo].[_getDownloadCertificateByID]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[_getDownloadCertificateByID](@RequestId varchar(20))
as begin
select
a.RequestId,
a.CertificateId,
a.CertificateName,
a.CertificatePath,
b.InvoiceNo
from tblCertificate a,tblCertifcateRequestHeader b,tblCustomer c,tblUser d , tblCustomerParent P
where a.RequestId = b.RequestId 
and b.CustomerId=c.CustomerId 
and a.CertificateId NOT in (SELECT DocumentId FROM tblCancelledcertificate ) 
and c.ParentCustomerId=d.ParentCustomerId 
and b.CreatedBy=d.UserID --d.UserGroupID='CADMIN'
and c.ParentCustomerId = p.ParentCustomerId
and a.RequestId like @RequestId 
union


select
a.RequestId,
a.CertificateId,
a.CertificateName,
a.CertificatePath,
b.InvoiceNo
from tblCertificate a,tblUploadBasedCertificateRequest b,tblCustomer c ,tblUser d,tblCustomerParent P
where a.RequestId = b.RequestId 
and b.CustomerId=c.CustomerId 
and a.CertificateId NOT in(SELECT DocumentId FROM tblCancelledcertificate ) 
and c.ParentCustomerId=d.ParentCustomerId 
and b.CreatedBy=d.UserID --d.UserGroupID='CADMIN'
and c.ParentCustomerId = p.ParentCustomerId
and a.RequestId like @RequestId
End 
GO
/****** Object:  StoredProcedure [dbo].[_getExportSector]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[_getExportSector](@Status varchar(5))
AS
BEGIN
	Select ExportId,ExportSector,Status from tblExportSector where Status like @Status 
	and Status != 'D'

END










GO
/****** Object:  StoredProcedure [dbo].[_getInvoiceBody]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_getInvoiceBody] 
	(@InvoiceNo varchar(20))
AS
BEGIN
	SELECT
	B.RequestNo,C.CertificateId,A.Consignee,A.Consignor,B.UnitCharge,B.CreatedDate
	FROM
	tblCertifcateRequestHeader A ,tblInvoiceDetail B,tblCertificate C
	WHERE
	B.InvoiceNo=@InvoiceNo
	AND
	B.RequestNo=C.RequestId
	AND
	B.RequestNo=A.RequestId
	UNION
	SELECT
	B.RequestNo,C.CertificateId,'N/A' AS Consignee,D.CustomerName AS Consignor,B.UnitCharge,B.CreatedDate
	FROM
	tblUploadBasedCertificateRequest A ,tblInvoiceDetail B,tblCertificate C,tblCustomer D
	WHERE
	B.InvoiceNo=@InvoiceNo
	AND
	B.RequestNo=C.RequestId
	AND
	B.RequestNo=A.RequestId
	AND
	A.CustomerId=D.CustomerId
	Union 
	SELECT A.SupportingDocName as RequestNo,A.SupportingDocName as CertificateId ,'N/A' as Consignee,'N/A' as Consignor, A.RateValue as UnitCharge, a.CreatedDate
    FROM tblInvoiceRate A,tblSupportingDocApproveRequest B
    WHERE
    A.InvoiceNo=@InvoiceNo
    AND
    B.RequestID=A.SupportingDocName
END






GO
/****** Object:  StoredProcedure [dbo].[_getInvoiceDetails_Certificate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_getInvoiceDetails_Certificate] 
	(@Status varchar(3),@StartDate varchar(10),@EndDate varchar(10),@customerId varchar(20)
,@rateId varchar(20))
AS
BEGIN

SELECT A.RequestId,A.CustomerId,A.CreatedDate, Consignor,Consignee,D.Rates ,c.IsSVat
FROM tblCertifcateRequestHeader A, tblCertificate B,tblCustomerApplicableRates D , tblCustomer C
WHERE A.Status=@Status
AND A.RequestId=B.RequestId
AND B.CertificateId NOT in(SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=B.CertificateId)
AND D.RatesId=@rateId
AND A.RequestId
Not in(SELECT E.RequestNo  FROM	tblInvoiceDetail E Where E.RequestNo=A.RequestId)
AND A.CustomerId=@customerId
AND D.CustomerId=A.CustomerId
and a.CustomerId = c.CustomerId
AND convert(varchar,A.CreatedDate,112)>=@StartDate
AND convert(varchar,A.CreatedDate,112)<=@EndDate

UNION

SELECT A.RequestId,A.CustomerId,A.CreatedDate,A.CustomerId AS Consignor ,null AS Consignee,D.Rates , c.IsSVat
FROM tblUploadBasedCertificateRequest A, tblCertificate B,tblCustomerApplicableRates D , tblCustomer C
WHERE A.Status=@Status
AND D.RatesId=@rateId
AND A.RequestId=B.RequestId
AND B.CertificateId NOT in (SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=B.CertificateId)
AND A.RequestId
Not in (SELECT E.RequestNo  FROM	tblInvoiceDetail E 	Where E.RequestNo=A.RequestId)
AND A.CustomerId=@customerId
AND D.CustomerId=A.CustomerId
And a.CustomerId = c.CustomerId
AND convert(varchar,A.CreatedDate,112)>=@StartDate
AND convert(varchar,A.CreatedDate,112)<=@EndDate

END





GO
/****** Object:  StoredProcedure [dbo].[_getInvoiceHeader]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_getInvoiceHeader]
	(@InvoiceNo varchar(20))
AS
BEGIN
	SELECT 
	A.CreatedDate,B.CustomerName,B.CustomerId,B.Address1,B.Address2,B.Address2,B.Address3,A.FromDate,A.ToDate, P.ParentCustomerId , P.CustomerName as ParentN,
	a.IsTaxInvoice,a.GrossTotal,a.InvoiceTotal
	FROM tblInvoiceHeader A,tblCustomer B,tblCustomerParent P
	WHERE A.InvoiceNo=@InvoiceNo
	AND B.CustomerId=A.CustomerId
	And B.ParentCustomerId = P.ParentCustomerId
	
END





GO
/****** Object:  StoredProcedure [dbo].[_getInvoiceTax]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
Create proc [dbo].[_getInvoiceTax] (@InvoiceNo varchar(20))
as begin
SELECT [InvoiceNo]
      ,[TaxCode]
      ,[Amount]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[TaxPercentage]
  FROM [NCEDCO].[dbo].[tblInvoiceTax]
  Where InvoiceNo = @InvoiceNo
  End
GO
/****** Object:  StoredProcedure [dbo].[_getOwnerCompany]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_getOwnerCompany]
	
AS
BEGIN
	SELECT OrganizationName, PostBox, Address1, Address2, Address3
	FROM tblOwnerDetails  WHERE OwnerId='NCE'
END




GO
/****** Object:  StoredProcedure [dbo].[_getOwnerContact]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_getOwnerContact]
	
AS
BEGIN
	SELECT A.Email,A.FaxNo,A.Name,A.TelephoneNo,A.WebAddress FROM tblOwnerDetails A WHERE OwnerId='NCE'
END




GO
/****** Object:  StoredProcedure [dbo].[_getParentCustomerRequestDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[_getParentCustomerRequestDetails](@CustomerID varchar(20))
as begin
Select 
RequestId,
ParentCustomerId, 
CustomerName, 
Telephone, 
IsSVat, 
Fax, 
Email, 
Address1, 
Address2, 
Address3, 
Status, 
CreatedDate, 
CreatedBy, 
ContactPersonName, 
ContactPersonDesignation, 
ContactPersonDirectPhoneNumber, 
ContactPersonMobile, 
ContactPersonEmail, 
NCEMember, 
PaidType

from tblCustomerParent
where ParentCustomerId like @CustomerID

End

GO
/****** Object:  StoredProcedure [dbo].[_getParentsChildrenDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_getParentsChildrenDetails](@ParentId varchar(20))
as Begin
Select  CustomerId, C.CustomerName, C.Telephone, C.IsSVat, C.Fax, C.Email, C.Address1, C.Address2, C.Address3, C.Status, C.CreatedDate, C.CreatedBy, C.ContactPersonName, 
C.ContactPersonDesignation, C.ContactPersonDirectPhoneNumber, C.ContactPersonMobile, C.ContactPersonEmail, C.ProductDetails, ExportSector, C.NCEMember, C.PaidType, 
C.ParentCustomerId, C.RequestId, C.TemplateId,T.TemplateName
From tblCustomer C,tblCustomerParent P,tblTemplateHeader T
Where C.ParentCustomerId =  P.ParentCustomerId
And T.TemplateId = C.TemplateId
And C.ParentCustomerId = @ParentId
End
GO
/****** Object:  StoredProcedure [dbo].[_getPendingSDoc_byID]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[_getPendingSDoc_byID](@RequestID varchar(20))
as Begin
SELECT A.RequestID, 
SupportingDocID,
B.SupportingDocumentName, 
A.CustomerID,
C.CustomerName,
RequestDate, 
RequestBy, 
A.Status, 
UploadPath,
UploadDocName,
P.CustomerName as ParentName
FROM tblSupportingDocApproveRequest A, tblSupportingDocuments B, tblCustomer C ,tblCustomerParent P
WHERE A.CustomerID = C.CustomerId
AND C.ParentCustomerId = P.ParentCustomerId
AND A.SupportingDocID = B.SupportingDocumentId
AND A.Status LIKE 'P'
AND A.RequestID = @RequestID

End



GO
/****** Object:  StoredProcedure [dbo].[_getPendingSDocApprovals]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[_getPendingSDocApprovals](@Status varchar(5),@CustomerID varchar(20), @Parentid varchar(20))
as Begin
SELECT A.RequestID, 
SupportingDocID,
B.SupportingDocumentName, 
A.CustomerID,
C.CustomerName,
RequestDate, 
RequestBy, 
A.Status, 
UploadPath,
UploadDocName,
P.CustomerName as ParentName
FROM tblSupportingDocApproveRequest A, tblSupportingDocuments B, tblCustomer C ,tblCustomerParent P
WHERE A.CustomerID = C.CustomerId
AND C.ParentCustomerId = P.ParentCustomerId
AND A.SupportingDocID = B.SupportingDocumentId
AND A.Status LIKE @Status
AND A.CustomerID LIKE @CustomerID
AND P.ParentCustomerId LIKE @Parentid
ORDER BY A.RequestDate

End



GO
/****** Object:  StoredProcedure [dbo].[_getRejectReasonCategories]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_getRejectReasonCategories]
as Begin
Select RejectReasonsCategory, CategoryDescription
From tblRejectReasonCategory

End

GO
/****** Object:  StoredProcedure [dbo].[_getRejectReasons]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_getRejectReasons](@RejectReasonCategory varchar(20))
as begin
Select RejectCode, ReasonName
from tblRejectReasons
where Category = @RejectReasonCategory
and IsActive like 'Y'
End

GO
/****** Object:  StoredProcedure [dbo].[_getRejectReasons_List]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_getRejectReasons_List](@Category varchar(20),@IsActive varchar(1))
as begin
Select RejectCode, ReasonName, Category, ModifiedBy, ModifiedDate, IsActive, CreatedDate, CreatedBy
From tblRejectReasons
Where Category like @Category
And IsActive like @IsActive

End

GO
/****** Object:  StoredProcedure [dbo].[_getSavedCertificateRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_getSavedCertificateRequest](@RequestId varchar(20))
as begin
SELECT 
H.RequestId, 
TemplateId, 
CustomerId, 
RequestDate, 
ModifiedDate, 
ModifiedBy,   
Status, 
Consignor, 
Consignee, 
InvoiceNo, 
InvoiceDate, 
CountryCode, 
LoadingPort, 
PortOfDischarge, 
Vessel, 
PlaceOfDelivery, 
TotalInvoiceValue, 
TotalQuantity, 
OtherComments, 
OtherDetails, 
ReasonCode, 
SealRequired,
--Details
GoodItem, ShippingMark, PackageType, SummaryDesc, Quantity, HSCode
FROM tblCertifcateRequestHeader H
INNER JOIN tblCertificateRequestDetails R ON R.RequestId = H.RequestId where H.RequestId = @RequestId
End
GO
/****** Object:  StoredProcedure [dbo].[_getSignatoryUsers]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_getSignatoryUsers](@UserGroup varchar(20))
as begin

select UserID,PersonName + '    [ User ID : ' + UserID +' ]' as PersonName from tblUser 
where UserGroupID like @UserGroup
and IsActive = 'Y'

end





GO
/****** Object:  StoredProcedure [dbo].[_getSignedCertificateSupportDoc]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_getSignedCertificateSupportDoc](@Certid  varchar(20))
AS
BEGIN
	Select a.RequestRefNo,a.UploadedPath as DPath,b.SupportingDocumentName as Dname,a.SupportingDocumentId as DId, 'Not Signed' as IsSigned 
	from tblSupportingDOCUpload  a ,tblSupportingDocuments b  where RequestRefNo like @Certid 
	and a.SupportingDocumentId=b.SupportingDocumentId
	and a.Remarks like ''
	union
	Select RequestID as RequestRefNo ,DownloadPath as DPath, SupportingDocumentName as Dname,SupportingDocID DId, 'Signed' as IsSigned 
	from tblSupportingDocApproveRequest a, tblSupportingDocuments b where CertificateRequestId like @Certid 
	and a.SupportingDocID = b.SupportingDocumentId
	and isnull(RequestID,'') NOT in
	(SELECT DocumentId FROM tblCancelledcertificate  )
END






GO
/****** Object:  StoredProcedure [dbo].[_getSignedCertificateSupportDocForDownLoad]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_getSignedCertificateSupportDocForDownLoad](@Certid  varchar(20))
AS
BEGIN
	Select RequestID as RequestRefNo ,DownloadPath as DPath, SupportingDocumentName as Dname,SupportingDocID DId, 'Signed' as IsSigned 
	from tblSupportingDocApproveRequest a, tblSupportingDocuments b where CertificateRequestId like @Certid 
	and a.SupportingDocID = b.SupportingDocumentId
	and isnull(RequestID,'') NOT in
	(SELECT DocumentId FROM tblCancelledcertificate  )
END






GO
/****** Object:  StoredProcedure [dbo].[_getSupportDocDownloadData]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[_getSupportDocDownloadData](@RequestID varchar(20))
as begin
select RequestID, DownloadPath, DownloadDocName
from tblSupportingDocApproveRequest
where RequestID like @RequestID 
End
GO
/****** Object:  StoredProcedure [dbo].[_getSupportDocument]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author: Shirandi Ekanayake

-- Create date: 2016/05/25

-- Description: To Retrieve User Group Information

-- =============================================

CREATE

PROCEDURE [dbo].[_getSupportDocument]
(

@SupportingDocumentId varchar(20),@IsActive varchar(1))
AS

BEGIN

select * from tblSupportingDocuments
where

SupportingDocumentId like @SupportingDocumentId
and

IsActive like @IsActive
　

END








GO
/****** Object:  StoredProcedure [dbo].[_getSupportingDOCforRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_getSupportingDOCforRequest](@CustomerClientId varchar(20),@TemplateID varchar(20))
as Begin

select S.SupportingDocumentId,S.SupportingDocumentName, C.TemplateId, T.IsMandatory

from tblSupportingDocuments S ,tblCustomer C, tblTemplateSupportingDocument T
where C.TemplateId = T.TemplateId
and S.SupportingDocumentId = T.SupportingDocumentId
and S.IsActive like 'Y'
and T.IsActive like 'Y'
and C.CustomerId = @CustomerClientId
and C.TemplateId like @TemplateID
end
GO
/****** Object:  StoredProcedure [dbo].[_getSupportingDocumentDownload]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[_getSupportingDocumentDownload](@ParentCustomer varchar(20))
AS
BEGIN
select
S.SupportingDocumentName,
b.SupportingDocID,
b.RequestID,
b.DownloadPath,
b.RequestBy,
b.RequestDate,
'SD Request'CertificateRequestId,
b.ApprovedDate,
b.ApprovedBy,
b.IsDownloaded,
'N/A' as Consignor,
'N/A' as Consignee,
'N/A' as InvoiceNo,
'SD Request' as CertificateId
from tblSupportingDocApproveRequest b, tblSupportingDocuments s , tblCustomer C, tblCustomerParent P
where b.SupportingDocID=s.SupportingDocumentId and
b.CustomerID = c.CustomerId and
c.ParentCustomerId = P.ParentCustomerId and
b.CertificateRequestId is null and 
b.Status like 'A' and
P.ParentCustomerId like @ParentCustomer and
b.RequestID NOT in
(SELECT DocumentId FROM tblCancelledcertificate )


 union

select
s.SupportingDocumentName,
b.SupportingDocID,
b.RequestID,
b.DownloadPath,
b.RequestBy,
b.RequestDate,
b.CertificateRequestId,
b.ApprovedDate,
b.ApprovedBy,
b.IsDownloaded,
'N/A' as Consignor,
'N/A' as Consignee,
u.InvoiceNo,
c.CertificateId
from tblSupportingDocApproveRequest b, tblSupportingDocuments s,tblUploadBasedCertificateRequest U, tblCertificate C,tblCustomer t, tblCustomerParent P
where b.SupportingDocID=s.SupportingDocumentId and
b.CustomerID = t.CustomerId and
t.ParentCustomerId = P.ParentCustomerId and
b.CertificateRequestId = u.RequestId and
c.RequestId = u.RequestId and
b.Status like 'A' and
P.ParentCustomerId like @ParentCustomer and
b.RequestID NOT in
(SELECT DocumentId FROM tblCancelledcertificate )




 union


 select
s.SupportingDocumentName,
b.SupportingDocID,
b.RequestID,
b.DownloadPath,
b.RequestBy,
b.RequestDate,
b.CertificateRequestId,
b.ApprovedDate,
b.ApprovedBy,
b.IsDownloaded,
H.Consignor,
h.Consignee,
h.InvoiceNo,
c.CertificateId
from tblSupportingDocApproveRequest b, tblSupportingDocuments S,tblCertifcateRequestHeader H,tblCertificate C,tblCustomer t, tblCustomerParent P
where b.SupportingDocID=s.SupportingDocumentId and
b.CustomerID = t.CustomerId and
t.ParentCustomerId = P.ParentCustomerId and
b.CertificateRequestId = H.RequestId and
c.RequestId = H.RequestId and
b.Status like 'A' and
P.ParentCustomerId like @ParentCustomer and
b.RequestID NOT in
(SELECT DocumentId FROM tblCancelledcertificate )
 order by  ApprovedDate Desc

END

GO
/****** Object:  StoredProcedure [dbo].[_getSupportingDocUsingCertificateId]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_getSupportingDocUsingCertificateId]
	(@CertificateId varchar(20),@invoiceSupDocID varchar(20))
AS
BEGIN
	SELECT A.RequestID,A.CustomerID,'Invoice' AS DocType
	 FROM tblSupportingDocApproveRequest A,tblCertificate B
	WHERE 
	B.CertificateId=@CertificateId
	AND
	A.CertificateRequestId=B.RequestId
	AND
	SupportingDocID=@invoiceSupDocID

	UNION
	SELECT A.RequestID,A.CustomerID,'Other' AS DocType
	 FROM tblSupportingDocApproveRequest A,tblCertificate B
	WHERE 
	B.CertificateId=@CertificateId
	AND
	A.CertificateRequestId=B.RequestId
	AND
	SupportingDocID!=@invoiceSupDocID

END



GO
/****** Object:  StoredProcedure [dbo].[_getSuppotingDocumentPeriodicDetail]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_getSuppotingDocumentPeriodicDetail] 
	(@customerId varchar(20),@status varchar(1),@startDate varchar(8),@endDate varchar(8)
	,@InvoiceRateId varchar(20),@OtherRateId varchar(20),@supdocInvoiceRateId varchar(20),
	@supdocOtherRateId varchar(20),@AtachSheetId varchar(20))
AS
BEGIN
	SELECT A.RequestID,A.UploadDocName,A.SupportingDocID,B.Rates,B.RatesId,C.IsSVat
	FROM tblSupportingDocApproveRequest A,tblCustomerApplicableRates B,tblCustomer C
	WHERE A.CustomerID=@customerId
	And A.CustomerID = C.CustomerId
	AND A.SupportingDocID=@supdocInvoiceRateId
	AND A.SupportingDocID!=@AtachSheetId
	AND B.RatesId=@InvoiceRateId
	AND A.RequestID NOT in(SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=A.RequestID)
	AND A.RequestID Not in(SELECT SupportingDocName FROM tblInvoiceRate WHERE SupportingDocName=A.RequestID)
	AND B.CustomerId=A.CustomerID
	AND A.Status=@status
	AND convert(varchar,ApprovedDate,112)>=@startDate
	AND convert(varchar,ApprovedDate,112)<=@endDate

	UNION

	SELECT A.RequestID,A.UploadDocName,A.SupportingDocID,B.Rates,B.RatesId,C.IsSVat
	FROM tblSupportingDocApproveRequest A,tblCustomerApplicableRates B,tblCustomer C
	WHERE A.CustomerID=@customerId
	And A.CustomerID = C.CustomerId
	AND A.SupportingDocID!=@supdocInvoiceRateId
	AND A.SupportingDocID!=@AtachSheetId
	AND B.RatesId=@OtherRateId
	AND A.RequestID NOT in(SELECT D.DocumentId FROM tblCancelledcertificate D WHERE D.DocumentId=A.RequestID)
	AND A.RequestID Not in(SELECT SupportingDocName FROM tblInvoiceRate WHERE SupportingDocName=A.RequestID)
	AND B.CustomerId=A.CustomerID
	AND A.Status=@status
	AND convert(varchar,ApprovedDate,112)>=@startDate
	AND convert(varchar,ApprovedDate,112)<=@endDate	

END





GO
/****** Object:  StoredProcedure [dbo].[_getTaxDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_getTaxDetails] 
	(@status varchar(1),@IsVat varchar(4))

	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@IsVat='Y')
	SELECT * FROM tblTax WHERE IsActive=@status ORDER BY TaxPriority
	else
	SELECT * FROM tblTax
    WHERE IsActive=@status
	AND TaxCode!= @IsVat
	ORDER BY TaxPriority
END







GO
/****** Object:  StoredProcedure [dbo].[_getTemplateSupportDoc_List]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_getTemplateSupportDoc_List] (@IsActive varchar(1),@TemplateID varchar(20))
as begin
Select S.SupportingDocumentId,S.SupportingDocumentName, D.TemplateId, H.TemplateName,
 D.CreatedBy, D.IsActive, D.CreatedDate, D.ModifiedBy, D.ModifiedDate, D.IsMandatory, TemplateSupportingDocument
From tblTemplateSupportingDocument D, tblTemplateHeader H , tblSupportingDocuments S
Where D.TemplateId = H.TemplateId
And D.SupportingDocumentId = S.SupportingDocumentId
And D.IsActive like @IsActive
And H.IsActive like @IsActive
And S.IsActive like @IsActive
And D.TemplateId like @TemplateID

End

GO
/****** Object:  StoredProcedure [dbo].[_getUploadBCrequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_getUploadBCrequest](@RequestId varchar(20))
as begin 
Select 
RequestId, 
CustomerId, 
RequestDate, 
Status, 
CreatedDate, 
CreatedBy, 
InvoiceNo,  
CertificatePath, 
UploadPath, 
Remark, 
SealRequired
From tblUploadBasedCertificateRequest
Where RequestId = @RequestId
and Status like 'P'
End
GO
/****** Object:  StoredProcedure [dbo].[_getUserGroupFunction]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_getUserGroupFunction](@FunctionId varchar(20),@GroupId varchar(20))
as begin
Select FunctionId , GroupId
from tblGroupFunction
where FunctionId = @FunctionId
and GroupId = @GroupId

End

GO
/****** Object:  StoredProcedure [dbo].[_getUserGroups]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[_getUserGroups]
as begin
Select GroupId,GroupName
From tblUserGroup 
Where GroupId != 'CUSTOMER'
And GroupId != 'CADMIN'
And IsActive like 'Y'
End
GO
/****** Object:  StoredProcedure [dbo].[_getUserInfo]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_getUserInfo](@Userid varchar(20))
as begin
SELECT [UserID]
      ,[UserGroupID]
      ,[PersonName]
      ,[IsActive]
      ,[Designation]
      ,[Email]
  FROM [dbo].[tblUser]
  Where UserID like @Userid
  End



GO
/****** Object:  StoredProcedure [dbo].[_getUserlogin]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_getUserlogin](@UserId varchar(20),@Password nvarchar(50))

as begin

select UserId,UserGroupID,IsActive,Password,PassowordExpiryDate,PersonName, ParentCustomerId
from tblUser 
where UserId = @UserId
and Password = @Password


End









GO
/****** Object:  StoredProcedure [dbo].[_getUserName]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_getUserName] 
	(@userId varchar(20))
AS
BEGIN
	
	SELECT UserID FROM tblUser WHERE UserID=@userId
END






GO
/****** Object:  StoredProcedure [dbo].[_getUserSignatureDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_getUserSignatureDetails](@UserID varchar(20))
as Begin

SELECT
UserID, 
PFXpath, 
SignatureIMGPath
from tblUserSignature
where UserID = @UserID

End



GO
/****** Object:  StoredProcedure [dbo].[_ModifyCustomerRate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_ModifyCustomerRate]
	(@customerId varchar(20),@RateId varchar(10),@Rate decimal(18,6))
AS
BEGIN
	Update 
	tblCustomerApplicableRates
	SET
	Rates=@Rate
	WHERE
	RatesId=@RateId
	AND
	CustomerId=@customerId
END





GO
/****** Object:  StoredProcedure [dbo].[_setApproveChildCustomer]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[_setApproveChildCustomer]
   (@RequestId varchar(20),
    @ParentCustomerID varchar(20),
	@ChildCustomeID varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@NCEMember varchar(10),
	@ProductDetails text,
	@ExportSector varchar(200),
	@TemplateId varchar(20))

AS
BEGIN
	INSERT INTO tblCustomer
	(RequestId,
    ParentCustomerId,
	CustomerId,
	CustomerName, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	IsSVat,
	ProductDetails,
	ExportSector,
	TemplateId)
	VALUES
	(
	 @RequestId,
	 @ParentCustomerID,
	 @ChildCustomeID,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 @CreatedBy,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @isSVat,
	 @ProductDetails,
	 @ExportSector,
	 @TemplateId)
END






GO
/****** Object:  StoredProcedure [dbo].[_setCertifcateRequestHeader]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_setCertifcateRequestHeader]
(@RequestId varchar(20), 
@TemplateId varchar(20), 
@CustomerId varchar(20),
@CreatedBy varchar(20), 
@Status varchar(3), 
@Consignor varchar(500), 
@Consignee varchar(500), 
@InvoiceNo varchar(50), 
@InvoiceDate date,
@CountryCode varchar(50), 
@LoadingPort varchar(50), 
@PortOfDischarge varchar(50), 
@Vessel varchar(50), 
@PlaceOfDelivery varchar(50), 
@TotalInvoiceValue varchar(50),
@TotalQuantity varchar(20),
@OtherComments varchar(150),
@OtherDetails varchar(250),
@SealRequired varchar(5))
AS
BEGIN
Insert into [dbo].[tblCertifcateRequestHeader]
(RequestId, TemplateId, CustomerId, RequestDate, ModifiedDate, ModifiedBy, CreatedDate, CreatedBy, 
Status, Consignor, Consignee, InvoiceNo, InvoiceDate,
 CountryCode, LoadingPort, PortOfDischarge, Vessel, PlaceOfDelivery, TotalInvoiceValue, TotalQuantity,OtherComments,OtherDetails,SealRequired)
 values
 (@RequestId, @TemplateId, @CustomerId, getdate(), null, null, getdate(), @CreatedBy, 
@Status, @Consignor, @Consignee, @InvoiceNo, @InvoiceDate,
 @CountryCode, @LoadingPort, @PortOfDischarge, @Vessel, @PlaceOfDelivery, @TotalInvoiceValue, @TotalQuantity,@OtherComments,@OtherDetails,@SealRequired)
END







GO
/****** Object:  StoredProcedure [dbo].[_setCertificateApproval]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_setCertificateApproval]
(
@CertificateId varchar(20),
@RequestId varchar(20), 
@ExpiryDate datetime, 
@CreatedBy varchar(20) , 
@IsDownloaded varchar(2), 
@CertificatePath varchar(500), 
@CertificateName varchar(150), 
@IsValid varchar(5)
)
as begin

Insert Into tblCertificate
(CertificateId,RequestId, CreatedDate, ExpiryDate, CreatedBy, IsDownloaded, CertificatePath, CertificateName, IsValid,IsSend) Values
(@CertificateId,@RequestId, GETDATE(), @ExpiryDate, @CreatedBy, @IsDownloaded, @CertificatePath, @CertificateName, @IsValid,'N')

Update tblCertifcateRequestHeader
Set Status = 'A'
where RequestId = @RequestId

Update tblWebBasedCertificateRequest
Set Status = 'A'
where RequestId = @RequestId

End



GO
/****** Object:  StoredProcedure [dbo].[_setCertificateReject]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setCertificateReject](@RequestID varchar(20), @RejectBy varchar(20),@ResonCode varchar(10))
as begin

Update tblCertifcateRequestHeader
Set Status = 'R',
ModifiedBy = @RejectBy,
ReasonCode = @ResonCode,
ModifiedDate = GETDATE()
where RequestId = @RequestId
and Status like 'G'

End


GO
/****** Object:  StoredProcedure [dbo].[_setCertificateRequestDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_setCertificateRequestDetails](@RequestId varchar(20), @GoodItem varchar(500), 
@ShippingMark varchar(500), @PackageType varchar(500), 
@SummaryDesc varchar(1000), @Quantity varchar(500), @HSCode varchar(500),@CreatedBy varchar(20))
AS
BEGIN
insert into tblCertificateRequestDetails
(RequestId, GoodItem, ShippingMark, PackageType, SummaryDesc, Quantity, HSCode, CreatedDate, CreatedBy)
values
(@RequestId, @GoodItem, @ShippingMark, @PackageType, @SummaryDesc, @Quantity, @HSCode, getdate(), @CreatedBy)


END




GO
/****** Object:  StoredProcedure [dbo].[_setChildNewRates]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setChildNewRates](@Cid varchar(20),@RatesId varchar(10),@Value decimal(18,2))
as Begin
INSERT INTO [dbo].[tblCustomerApplicableRates]
           (CustomerId
           ,RatesId
           ,Rates)
     VALUES
           (@Cid
           ,@RatesId
           ,@Value)
End



GO
/****** Object:  StoredProcedure [dbo].[_setCustomerChildReject]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setCustomerChildReject](@RequestId varchar(20))
as begin
Update tblCustomerRequest
Set Status = 'R'
Where RequestId = @RequestId
End

GO
/****** Object:  StoredProcedure [dbo].[_setCutomerClientTemplate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_setCutomerClientTemplate]
	-- Add the parameters for the stored procedure here
	(@RequestId varchar(20),@TemplateId varchar(20))
AS
BEGIN
	

    -- Insert statements for procedure here
	UPDATE tblCustomerRequest SET TemplateId=@TemplateId 
	WHERE RequestId=@RequestId
END






GO
/****** Object:  StoredProcedure [dbo].[_setDeleteExportSector]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[_setDeleteExportSector]
(

@ExportID int)
AS

BEGIN

update tblExportSector
set Status = 'D'
where
ExportId=@ExportID;
　

END






GO
/****** Object:  StoredProcedure [dbo].[_setDeleteRejectReason]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_setDeleteRejectReason]
(

@RejectCode varchar(20))
AS

BEGIN

update tblRejectReasons
set IsActive= 'D'
where
RejectCode = @RejectCode
　

END






GO
/****** Object:  StoredProcedure [dbo].[_setDeleteSupportingDocuments]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_setDeleteSupportingDocuments]
(

@SupportingDocumentId varchar(20))
AS

BEGIN

update tblSupportingDocuments
set IsActive = 'D'
where
SupportingDocumentId=@SupportingDocumentId;
　

END






GO
/****** Object:  StoredProcedure [dbo].[_setDeleteTemplateSupportDoc]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_setDeleteTemplateSupportDoc](@ID int)
as begin
Update tblTemplateSupportingDocument
Set IsActive = 'D'
Where TemplateSupportingDocument = @ID

End

GO
/****** Object:  StoredProcedure [dbo].[_setDocumentCancelation]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[_setDocumentCancelation]
(@DocID varchar(20),@CustomerId varchar(20),@Remark varchar(200),@CancelBy varchar(20),@DocType varchar(1))
AS
BEGIN
	DELETE FROM tblCancelledCertificate WHERE DocumentId=@DocID
	
	INSERT 
	INTO 
	tblCancelledcertificate
	(DocumentId, CustomerId, Remark, CancelBy, CancelDate, DocumentType)
	VALUES
	(@DocID,@CustomerId,@Remark,@CancelBy,GETDATE(),@DocType)

END



GO
/****** Object:  StoredProcedure [dbo].[_setEditUser]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setEditUser](@UserId varchar(20), @Groupid varchar(20),@PersonName varchar(149),
@Designation varchar(50),@Email varchar(50),@Createdby varchar(20),@isactive varchar(1))
as begin
UPDATE [dbo].[tblUser]
   SET [UserGroupID] = @Groupid
      ,[PersonName] = @PersonName
      ,[CreatedBy] = @Createdby
      ,[UpdateDate] = GETDATE()
      ,[IsActive] = @isactive
      ,[Designation] = @Designation
      ,[Email] = @Email
 WHERE UserID = @UserId
End



GO
/****** Object:  StoredProcedure [dbo].[_setInvoiceDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_setInvoiceDetails]
	(@RequestNo varchar(20),@UnitCharge decimal(18,8), @CreatedBy varchar(20),@InvoiceNo varchar(20))
AS
BEGIN

	INSERT INTO tblInvoiceDetail
	( RequestNo, CreatedDate,ModifiedDate, UnitCharge, 
	CreatedBy,Modifiedby, InvoiceNo)
	 VALUES
	 (@RequestNo,GETDATE(),GETDATE(),@UnitCharge,@CreatedBy,@CreatedBy,@InvoiceNo) 
END





GO
/****** Object:  StoredProcedure [dbo].[_setInvoiceHeader]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE  [dbo].[_setInvoiceHeader]
	(@InvoiceNo varchar(20), @CustomerId varchar(10),
	  @FromDate DateTime, @ToDate DateTime, @GrossTotal decimal(18,6), @InvoiceTotal decimal(18,6),
	   @IsTaxInvoice varchar(4), @CreatedBy varchar(50), @PrintTimes int)
AS
BEGIN	
	INSERT INTO tblInvoiceHeader 
	(InvoiceNo,
	CustomerId,
	FromDate,
	ToDate,
	GrossTotal,
    InvoiceTotal,
	IsTaxInvoice,
	CreatedDate,
	CreatedBy,
	PrintTime)
	VALUES 
	(@InvoiceNo,
	@CustomerId,
	Convert(varchar(30),
	@FromDate,110),
	Convert(varchar(30),
	@ToDate,110),
	@GrossTotal,
	@InvoiceTotal,
	@IsTaxInvoice,
	GETDATE(),
	@CreatedBy,
	@PrintTimes)

END





GO
/****** Object:  StoredProcedure [dbo].[_setInvoiceRate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_setInvoiceRate]
	(@CustomerId varchar(20),@InvoiceNo varchar(20),@SuportingDocName varchar(50),@RateId varchar(10),@RateValue decimal(18,2),@CreatedBy varchar(20))
AS
BEGIN
	INSERT INTO tblInvoiceRate(CustomerId,InvoiceNo, SupportingDocName, RateId, RateValue, CreatedBy, CreatedDate)
	VALUES(@CustomerId,@InvoiceNo,@SuportingDocName,@RateId,@RateValue,@CreatedBy,GETDATE())
END





GO
/****** Object:  StoredProcedure [dbo].[_setInvoiceTax]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_setInvoiceTax]
	(@InvoiceNo varchar(20),@TaxCode varchar(50),@Amount decimal(10,6),@CreatedBy varchar(50),@TaxPercentage decimal(18,2))
AS
BEGIN
	INSERT INTO 
	tblInvoiceTax
	Values
	(@InvoiceNo,@TaxCode,@Amount,@CreatedBy,GETDATE(),@TaxPercentage)
END





GO
/****** Object:  StoredProcedure [dbo].[_setNewExportSector]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[_setNewExportSector](@ExportSectorName varchar(100),@Status varchar(2))
AS
BEGIN
	Insert Into tblExportSector (ExportSector,Status)
	values (@ExportSectorName,@Status)

	 
END










GO
/****** Object:  StoredProcedure [dbo].[_setNewRejectReason]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setNewRejectReason](@RejectCode varchar(20),@Category varchar(20),@ReasonName varchar(150),@Createdby varchar(20),@IsActive varchar(1))
as begin
Insert Into tblRejectReasons (RejectCode, ReasonName, Category, IsActive, CreatedDate, CreatedBy)
Values(@RejectCode,@ReasonName,@Category,@IsActive,GETDATE(),@Createdby)

End

GO
/****** Object:  StoredProcedure [dbo].[_setNewUser]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setNewUser](@UserId varchar(20), @Groupid varchar(20),@PersonName varchar(149)
,@Password nvarchar(200),@Designation varchar(50),@Email varchar(50),@Createdby varchar(20))
as begin
INSERT INTO [dbo].[tblUser]
           ([UserID]
           ,[UserGroupID]
           ,[PersonName]
           ,[Password]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[IsActive]
           ,[PassowordExpiryDate]
           ,[Designation]
           ,[Email])
     VALUES
           (@UserId
		   ,@Groupid
           ,@PersonName
           ,@Password
           ,@Createdby
           ,GETDATE()
           ,'Y'
           ,GETDATE() + 60
           ,@Designation
           ,@Email)
End



GO
/****** Object:  StoredProcedure [dbo].[_setParentChildCustomerRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[_setParentChildCustomerRequest]
   (@RequestId varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@NCEMember varchar(10),
	@ParentCustomerId varchar(20),
	@ProductDetails text,
	@ExportSector int)
AS
BEGIN
	INSERT INTO tblCustomerRequest
	(RequestId,
	Name, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	SVat,
	ParentCustomerId,
	ExportSector,
	ProductDetails)
	VALUES
	(
	 @RequestId,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 @CreatedBy,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @isSVat,
	 @ParentCustomerId,
	 @ExportSector,
	 @ProductDetails)
END






GO
/****** Object:  StoredProcedure [dbo].[_setReffrennceRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[_setReffrennceRequest](@Consignee varchar(250),@CustomerID varchar(20),@RequestId varchar(20),@ParentId varchar(20),@TemplateName varchar(150))
as Begin
Insert into tblCertificateRequestReffrence
(Consignee, CustomerId, RequestId,ParentCustomerId,TemplateName) values 
(@Consignee,@CustomerID,@RequestId,@ParentId,@TemplateName)
End
GO
/****** Object:  StoredProcedure [dbo].[_setRejectSupportDoc]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[_setRejectSupportDoc](@RequestID varchar(20),@ApprovedBy varchar(20),@RejectReasonCode varchar(20))
as Begin
UPDATE tblSupportingDocApproveRequest
SET Status = 'R',
ApprovedBy = @ApprovedBy,
ApprovedDate = GETDATE(),
RejectReasonCode = @RejectReasonCode
where RequestID = @RequestID
End 



GO
/****** Object:  StoredProcedure [dbo].[_setRejectUBCertificate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  Create PROC [dbo].[_setRejectUBCertificate](@ModifiedBy varchar(20),@RequestId varchar(20),@RejectReasonCode varchar(20))
  as Begin

  UPDATE tblUploadBasedCertificateRequest
  SET Status = 'R',
  ModifiedDate = GETDATE(),
  ModifiedBy = @ModifiedBy,
  RejectReasonCode = @RejectReasonCode
  WHERE RequestId = @RequestId
  and Status like 'P'

  End


GO
/****** Object:  StoredProcedure [dbo].[_setResetPassword]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setResetPassword](@UserId varchar(20),@Passwrod nvarchar(200))
as begin
UPDATE [dbo].[tblUser]
   SET Password = @Passwrod
 WHERE UserID = @UserId
End



GO
/****** Object:  StoredProcedure [dbo].[_setSignatorySignatureDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[_setSignatorySignatureDetails]
(@UserID varchar(20),
@PFXpath nvarchar(250),
@SignatureIMGPath nvarchar(250),
@CreatedBy varchar(20)
)
as begin

Insert into tblUserSignature
Values (@UserID, @PFXpath, @SignatureIMGPath, @CreatedBy, GETDATE())

End




GO
/****** Object:  StoredProcedure [dbo].[_setSupportingDocApproveFrmCRquest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[_setSupportingDocApproveFrmCRquest](
@RequestID varchar(20), @SupportingDocID varchar(20), 
@CustomerID varchar(20), @RequestBy varchar(20), 
@Status varchar(5),@UploadPath varchar(250), @UploadDocName varchar(50),
@ApprovedBy varchar(20), @RequestDate datetime,@DownloadPath varchar(250),@DocExpireDate date,
@CertificateRequestId varchar(20)
)
as Begin
INSERT INTO tblSupportingDocApproveRequest
(RequestID, SupportingDocID, CustomerID, RequestDate, RequestBy, Status, ApprovedBy, ApprovedDate, UploadPath, UploadDocName, DownloadPath, DownloadDocName,DocExpireDate,IsDownloaded,IsValid,CertificateRequestId)
VALUES
(@RequestID, @SupportingDocID, @CustomerID,@RequestDate, @RequestBy, @Status, @ApprovedBy, GETDATE(), @UploadPath, @UploadDocName, @DownloadPath, @UploadDocName,@DocExpireDate,'N','Y',@CertificateRequestId)

End


GO
/****** Object:  StoredProcedure [dbo].[_setSupportingDocApproveRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[_setSupportingDocApproveRequest](
@RequestID varchar(20), @SupportingDocID varchar(20), 
@CustomerID varchar(20), @RequestBy varchar(20), 
@Status varchar(5),@UploadPath varchar(250), @UploadDocName varchar(50))
as Begin
INSERT INTO tblSupportingDocApproveRequest
(RequestID, SupportingDocID, CustomerID, RequestDate, RequestBy, Status, ApprovedBy, ApprovedDate, UploadPath, UploadDocName, DownloadPath, DownloadDocName)
VALUES
(@RequestID, @SupportingDocID, @CustomerID, GETDATE(), @RequestBy, @Status, NULL, NULL, @UploadPath, @UploadDocName, NULL, NULL)

End






GO
/****** Object:  StoredProcedure [dbo].[_setSupportingDocuments]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_setSupportingDocuments]
	-- Add the parameters for the stored procedure here
	(@SupportingDocumentId varchar(20), @SupportingDocumentName nvarchar(100), @CreatedBy nvarchar(50),@IsActive varchar(2)  )
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO tblSupportingDocuments (SupportingDocumentId,SupportingDocumentName, CreatedBy, CreatedDate,IsActive) values
	(@SupportingDocumentId, @SupportingDocumentName, @CreatedBy, GETDATE(),@IsActive)
END










GO
/****** Object:  StoredProcedure [dbo].[_setSupportingDocUpload]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_setSupportingDocUpload](@RequestRefNo varchar(20), @DocumentId varchar(20),

@Remarks varchar(150), @UploadedBy varchar(20),@UploadPath varchar(250),@DocumentName varchar(150),@SignatureRequired varchar(5))

AS

BEGIN

insert into tblSupportingDOCUpload

(RequestRefNo, SupportingDocumentId, Remarks,UploadedDate, UploadedBy,UploadedPath,DocumentName,SignatureRequired)

values

(@RequestRefNo, @DocumentId, @Remarks,GETDATE(), @UploadedBy,@UploadPath,@DocumentName,@SignatureRequired)

 

END









GO
/****** Object:  StoredProcedure [dbo].[_setTemplateSupportingDocument]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[_setTemplateSupportingDocument](@SupportingDocumentId varchar(20), @TemplateId varchar(20), @CreatedBy varchar(20), @IsMandatory varchar(1))
as begin
Insert Into tblTemplateSupportingDocument (SupportingDocumentId,TemplateId,CreatedBy,IsMandatory,IsActive)
Values (@SupportingDocumentId,@TemplateId,@CreatedBy,@IsMandatory,'Y')

End

GO
/****** Object:  StoredProcedure [dbo].[_setUpdateClientCustomerReq]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setUpdateClientCustomerReq] (@Status varchar(1),@RequestID varchar(20))
as begin
Update tblCustomerRequest
Set Status = @Status
Where RequestId like @RequestID

End

GO
/****** Object:  StoredProcedure [dbo].[_setUpdateClientsCustomer]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[_setUpdateClientsCustomer](@CustomerId varchar(20),@CustomerName varchar(150),@Telephone varchar(20),@Fax varchar(20),
@Email varchar(50),@Address1 varchar(150),@Address2 varchar(150),@Address3 varchar(150),@ContactPerson varchar(150),@ContactDesignation varchar(50),
@ContactDirectPhone varchar(20),@ContactMobile varchar(20), @ContactEmail varchar(50),@ProductDetail varchar(250),@IsSVat varchar(2),@ExportSector int)
as Begin
UPDATE [dbo].[tblCustomer]
   SET [CustomerName] = @CustomerName
      ,[Telephone] = @Telephone
      ,[IsSVat] = @IsSVat
      ,[Fax] = @Fax
      ,[Email] = @Email
      ,[Address1] = @Address1
      ,[Address2] = @Address2
      ,[Address3] = @Address3
      ,[ContactPersonName] = @ContactPerson
      ,[ContactPersonDesignation] = @ContactDesignation
      ,[ContactPersonDirectPhoneNumber] = @ContactDirectPhone
      ,[ContactPersonMobile] = @ContactMobile
      ,[ContactPersonEmail] = @ContactEmail
      ,[ProductDetails] = @ProductDetail
      ,[ExportSector] = @ExportSector
 WHERE CustomerId like @CustomerId
 End



GO
/****** Object:  StoredProcedure [dbo].[_setUpdateExportSector]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_setUpdateExportSector]
(

@ExportId int,@ExportSector varchar(100),@IsActive varchar(1))
AS

BEGIN

update tblExportSector
set ExportSector= @ExportSector,Status = @IsActive
where
ExportId=@ExportId;
　

END






GO
/****** Object:  StoredProcedure [dbo].[_setUpdateOwnerCompany]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_setUpdateOwnerCompany]
	(@OrganizationName varchar(150),@PostBox varchar(40),@Address1 varchar(120),@Address2 varchar(120),@Address3 varchar(50))
AS
BEGIN
Update tblOwnerDetails
Set OrganizationName = @OrganizationName,
PostBox = @PostBox,
Address1 = @Address1,
Address2 = @Address2,
Address3 = @Address3
where OwnerId like 'NCE'
	

END



GO
/****** Object:  StoredProcedure [dbo].[_setUpdateOwnerContact]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_setUpdateOwnerContact]
	(@name varchar(150),@phone varchar(40),@email varchar(100),@web varchar(150),@fax varchar(15))
AS
BEGIN
Update tblOwnerDetails
Set Name = @name,
Email = @email,
WebAddress = @web,
FaxNo = @fax,
TelephoneNo = @phone
where OwnerId like 'NCE'
	

END



GO
/****** Object:  StoredProcedure [dbo].[_setUpdateParentCustomer]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[_setUpdateParentCustomer](@CustomerId varchar(20),@CustomerName varchar(150),@Telephone varchar(20),@Fax varchar(20),
@Email varchar(50),@Address1 varchar(150),@Address2 varchar(150),@Address3 varchar(150),@ContactPerson varchar(150),@ContactDesignation varchar(50),
@ContactDirectPhone varchar(20),@ContactMobile varchar(20), @ContactEmail varchar(50))
as Begin

UPDATE tblCustomerParent
   SET [CustomerName] = @CustomerName
      ,[Telephone] = @Telephone
      ,[Fax] = @Fax
      ,[Email] = @Email
      ,[Address1] = @Address1
      ,[Address2] = @Address2
      ,[Address3] = @Address3
      ,[ContactPersonName] = @ContactPerson
      ,[ContactPersonDesignation] = @ContactDesignation
      ,[ContactPersonDirectPhoneNumber] = @ContactDirectPhone
      ,[ContactPersonMobile] = @ContactMobile
      ,[ContactPersonEmail] = @ContactEmail
 WHERE ParentCustomerId = @CustomerId
 End




GO
/****** Object:  StoredProcedure [dbo].[_setUpdateRejectReason]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_setUpdateRejectReason]
(

@RejectCode varchar(20),@ReasonName varchar(150),@RejectRCategory varchar(20))
AS

BEGIN

update tblRejectReasons
set ReasonName = @ReasonName, Category = @RejectRCategory
where
RejectCode = @RejectCode
　

END






GO
/****** Object:  StoredProcedure [dbo].[_setUpdateSDApproveReq]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[_setUpdateSDApproveReq](@RequestID varchar(20),@ApprovedBy varchar(20),@DownloadPath varchar(250),@DownloadDocName varchar(50),@DocExpireDate date)
as Begin
UPDATE tblSupportingDocApproveRequest
SET Status = 'A',
ApprovedBy = @ApprovedBy,
ApprovedDate = GETDATE(),
DownloadPath = @DownloadPath,
DownloadDocName = @DownloadDocName,
DocExpireDate = @DocExpireDate,
IsDownloaded = 'N',
IsValid = 'Y'
WHERE RequestID = @RequestID
End



GO
/****** Object:  StoredProcedure [dbo].[_setUpdateSupportingDocuments]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_setUpdateSupportingDocuments]
(

@SupportingDocumentId varchar(20),@SupportingDocumentName varchar(100),@ModifiedBy varchar(20))
AS

BEGIN

update tblSupportingDocuments
set SupportingDocumentName= @SupportingDocumentName,ModifiedBy=@ModifiedBy,ModifiedDate=getdate()
where
SupportingDocumentId=@SupportingDocumentId;
　

END






GO
/****** Object:  StoredProcedure [dbo].[_setUpdateSupportingDocUpload]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[_setUpdateSupportingDocUpload](@UploadSeqNo bigint, @UploadedPath varchar(250),@DocumentName varchar(150))
as Begin
UPDATE tblSupportingDOCUpload 
SET UploadedPath = @UploadedPath,
DocumentName = @DocumentName,
Remarks = 'CERTIFIED'
WHERE UploadSeqNo = @UploadSeqNo
End



GO
/****** Object:  StoredProcedure [dbo].[_setUpdateTemplateSupportDoc]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[_setUpdateTemplateSupportDoc](@ID int , @TemplateId varchar(20),@SupportDocId varchar(20),@IsMandatory varchar(1),@ModifiedBy varchar(20))
as begin

Update tblTemplateSupportingDocument
Set TemplateId = @TemplateId,
SupportingDocumentId = @SupportDocId,
ModifiedBy = @ModifiedBy,
IsMandatory= @IsMandatory
Where TemplateSupportingDocument = @ID

End

GO
/****** Object:  StoredProcedure [dbo].[_setUpdateUploadBCertifcateRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[_setUpdateUploadBCertifcateRequest](@ModifiedBy varchar(20),@CertificateId varchar(20),@RequestId varchar(20))
as Begin

  UPDATE tblUploadBasedCertificateRequest
  SET Status = 'A',
  ModifiedDate = GETDATE(),
  ModifiedBy = @ModifiedBy,
  CertificateId  = @CertificateId 
  WHERE RequestId = @RequestId

  End



GO
/****** Object:  StoredProcedure [dbo].[_setUpdateUserSignatureDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_setUpdateUserSignatureDetails]
(@UserID varchar(20), 
@PFXpath nvarchar(250), 
@SignatureIMGPath nvarchar(250), 
@CreatedBy varchar(20))

as begin

Update tblUserSignature
Set
PFXpath = @PFXpath,
SignatureIMGPath = @SignatureIMGPath,
CreatedBy = @CreatedBy,
CreatedDate = GETDATE()
Where UserID = @UserID

End






GO
/****** Object:  StoredProcedure [dbo].[_setUploadBasedCRequests]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[_setUploadBasedCRequests]
(
@RequestId varchar(20), @CustomerId varchar(20), @Status varchar(5), @CreatedBy varchar(20),@UploadPath varchar(250),@InvoiceNo varchar(50),@SealRequired varchar(5)
)
as Begin
INSERT INTO tblUploadBasedCertificateRequest
(RequestId, CustomerId, RequestDate,InvoiceNo, Status, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, CertificatePath, UploadPath, RejectReasonCode, CertificateId,SealRequired)VALUES 
(@RequestId, @CustomerId, GETDATE(),@InvoiceNo, @Status, GETDATE(), @CreatedBy, null, null,null,@UploadPath,null,null,@SealRequired)
End



GO
/****** Object:  StoredProcedure [dbo].[_setWebBasedCertificateCreation]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_setWebBasedCertificateCreation](@RequestId varchar(20), @CertificatePath varchar(250) , @CertificateName varchar(50))
as Begin

INSERT INTO tblWebBasedCertificateRequest (RequestId, CertificatePath, CertificateName, CreatedDate, Status)
VALUES (@RequestId, @CertificatePath,@CertificateName,GETDATE(),'P')
END


GO
/****** Object:  StoredProcedure [dbo].[DCISgeMailParameters]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DCISgeMailParameters]
as
Begin
SELECT ParameterCode,ParameterValue FROM tblParameter WHERE ParameterCode LIKE 'EBCR_EMAIL'
UNION
SELECT ParameterCode,ParameterValue FROM tblParameter WHERE ParameterCode LIKE 'EBCRE_PASS'
UNION
SELECT ParameterCode,ParameterValue FROM tblParameter WHERE ParameterCode LIKE 'EBCRM_SMTP'
UNION
SELECT ParameterCode,ParameterValue FROM tblParameter WHERE ParameterCode LIKE 'EBCRM_SMTP_PORT'
End




GO
/****** Object:  StoredProcedure [dbo].[DCISgetParentCustomerRequestDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[DCISgetParentCustomerRequestDetails](@RequestID varchar(20))
as begin
Select 
RequestId, 
CustomerName, 
Telephone, 
IsSVat, 
Fax, 
Email, 
Address1, 
Address2, 
Address3, 
Status, 
CreatedDate, 
CreatedBy, 
ContactPersonName, 
ContactPersonDesignation, 
ContactPersonDirectPhoneNumber, 
ContactPersonMobile, 
ContactPersonEmail, 
NCEMember, 
PaidType, 
AdminUserId, 
AdminPassword, 
AdminName

from tblCustomerParentRequest
where RequestId like @RequestID

End

GO
/****** Object:  StoredProcedure [dbo].[DCISgetParentCustomerRequestList]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[DCISgetParentCustomerRequestList](@Status varchar(5))
as begin
Select 
RequestId, 
CustomerName, 
Telephone, 
IsSVat, 
Fax, 
Email, 
Address1, 
Address2, 
Address3, 
Status, 
CreatedDate, 
CreatedBy, 
ContactPersonName, 
ContactPersonDesignation, 
ContactPersonDirectPhoneNumber, 
ContactPersonMobile, 
ContactPersonEmail, 
NCEMember, 
PaidType, 
AdminUserId, 
AdminPassword, 
AdminName

from tblCustomerParentRequest
where Status like @Status

End

GO
/****** Object:  StoredProcedure [dbo].[DCISgetSequence]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shirandi Ekanayake
-- Create date: 30-05-2016
-- Description:	To Retrieve the Next SequenceNo
-- =============================================

Create PROCEDURE [dbo].[DCISgetSequence](@SequenceName varchar(50)) AS

select SequesnceValue from tblSequence
where SequenceName=@SequenceName;
update tblSequence
set  SequesnceValue=SequesnceValue+1
where SequenceName=@SequenceName;








GO
/****** Object:  StoredProcedure [dbo].[DCISgetTemplateHeader]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE

PROCEDURE[dbo].[DCISgetTemplateHeader]
(

@TemplateId varchar (20),@IsActive varchar (2),@AdminOnlyDisplay varchar(2))
AS

BEGIN

select TemplateId, TemplateName, ImgUrl, CreatedDate, ModifiedDate, IsActive, ModifiedBy, CreatedBy, Description, TemplatePath from tblTemplateHeader
where
TemplateId like @TemplateId and IsActive like @IsActive and AdminOnly like @AdminOnlyDisplay
END


GO
/****** Object:  StoredProcedure [dbo].[DCISsetApprovedPCUser]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[DCISsetApprovedPCUser]
(@UserID varchar(20), 
 @PersonName varchar(150), 
 @Password nvarchar(200), 
 @ParentCustomerId varchar(20)
)
as Begin
Insert Into tblUser
(UserID, UserGroupID,PersonName, Password, CreatedBy, CreatedDate, IsActive, ParentCustomerId,PassowordExpiryDate)
values
(@UserID,'CADMIN',@PersonName, @Password, 'ADMIN' , GETDATE(), 'Y', @ParentCustomerId,GETDATE())
End

GO
/****** Object:  StoredProcedure [dbo].[DCISsetApproveParentCustomer]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DCISsetApproveParentCustomer]
   (@RequestId varchar(20),
    @ParentCustomerID varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@NCEMember varchar(10))

AS
BEGIN
	INSERT INTO tblCustomerParent
	(RequestId,
    ParentCustomerId,
	CustomerName, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	IsSVat)
	VALUES
	(
	 @RequestId,
	 @ParentCustomerID,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 @CreatedBy,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @isSVat)
END






GO
/****** Object:  StoredProcedure [dbo].[DCISsetCustomerParentReject]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[DCISsetCustomerParentReject](@RequestId varchar(20))
as begin
Update tblCustomerParentRequest
Set Status = 'R'
Where RequestId = @RequestId
End

GO
/****** Object:  StoredProcedure [dbo].[DCISsetCustomerRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[DCISsetCustomerRequest]
   (@RequestId varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@AdminUserId varchar(20),
	@AdminPassword varchar(200),
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@ExportSector varchar(10),
	@NCEMember varchar(10),
	@AdminName varchar(150))
AS
BEGIN
	INSERT INTO tblCustomerParentRequest
	(RequestId,
	CustomerName, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
    AdminUserId, 
	AdminPassword,
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	AdminName,
	IsSVat)
	VALUES
	(
	 @RequestId,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 'SYSTEM',
	 @AdminUserId,
	 @AdminPassword,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @AdminName,
	 @isSVat)
END






GO
/****** Object:  StoredProcedure [dbo].[DCISsetParentCustomerRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DCISsetParentCustomerRequest]
   (@RequestId varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@AdminUserId varchar(20),
	@AdminPassword varchar(200),
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@NCEMember varchar(10),
	@AdminName varchar(150))
AS
BEGIN
	INSERT INTO tblCustomerParentRequest
	(RequestId,
	CustomerName, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
    AdminUserId, 
	AdminPassword,
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	AdminName,
	IsSVat)
	VALUES
	(
	 @RequestId,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 'SYSTEM',
	 @AdminUserId,
	 @AdminPassword,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @AdminName,
	 @isSVat)
END






GO
/****** Object:  StoredProcedure [dbo].[DCISsetUpdateParentCustomerReq]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[DCISsetUpdateParentCustomerReq] (@Status varchar(1),@RequestID varchar(20))
as begin
Update tblCustomerParentRequest
Set Status = @Status
Where RequestId like @RequestID

End

GO
/****** Object:  StoredProcedure [dbo].[getAllPendingCertificateRequests]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
 PROC [dbo].[getAllPendingCertificateRequests](@CustomerID varchar(20),@ParentId varchar(20))
AS BEGIN
Select 
'W' as CertificateType,
'Web' as CType,
W.RequestId, 
CertificatePath, 
CertificateName,
C.CustomerName, 
C.CustomerId,
C.ContactPersonEmail,
H.RequestDate, 
H.InvoiceNo, 
W.Status,
H.TemplateId,
H.SealRequired as SealRequired,
'YES' as CollectionType,
 CONCAT(U.PersonName, '-' ,U.Designation) as Createdby,
 Q.SummaryDesc,
 P.CustomerName as ParentCustomer

From tblWebBasedCertificateRequest W , tblCertifcateRequestHeader H , tblCustomer C, tblUser U , tblCertificateRequestDetails Q , tblCustomerParent P
Where W.RequestId = H.RequestId
And H.CustomerId = C.CustomerId
and q.RequestId = h.RequestId
And H.Status = 'G'
And W.Status = 'P'
And U.UserID = H.CreatedBy
And H.CustomerId like @CustomerID
And H.SealRequired like 'True'
And C.ParentCustomerId = P.ParentCustomerId
And P.ParentCustomerId like @ParentId

union

Select 
'W' as CertificateType,
'Web' as CType,
W.RequestId, 
CertificatePath, 
CertificateName,
C.CustomerName, 
C.CustomerId,
C.ContactPersonEmail,
H.RequestDate, 
H.InvoiceNo, 
W.Status,
H.TemplateId,
H.SealRequired as SealRequired,
'NO' as CollectionType,
 CONCAT(U.PersonName, '-' ,U.Designation) as Createdby,
 Q.SummaryDesc,
 P.CustomerName as ParentCustomer

From tblWebBasedCertificateRequest W , tblCertifcateRequestHeader H , tblCustomer C ,tblUser U,tblCertificateRequestDetails Q,tblCustomerParent P
Where W.RequestId = H.RequestId
And H.CustomerId = C.CustomerId
and q.RequestId = h.RequestId
And H.Status = 'G'
And W.Status = 'P'
And U.UserID = H.CreatedBy
And H.CustomerId like @CustomerID
And H.SealRequired like 'False'
And C.ParentCustomerId = P.ParentCustomerId
And P.ParentCustomerId like @ParentId

union

--eeeeeeeeee
Select 
'W' as CertificateType,
'Web' as CType,
W.RequestId, 
CertificatePath, 
CertificateName,
C.CustomerName, 
C.CustomerId,
C.ContactPersonEmail,
H.RequestDate, 
H.InvoiceNo, 
W.Status,
H.TemplateId,
H.SealRequired as SealRequired,
'YES' as CollectionType,
 CONCAT(U.PersonName, '-' ,U.Designation) as Createdby,
 Q.GoodDetails as SummaryDesc,
 P.CustomerName as ParentCustomer

From tblWebBasedCertificateRequest W , tblCertifcateRequestHeader H , tblCustomer C , tblUser U , tblRowCertificateRequestDetails Q, tblCustomerParent P
Where W.RequestId = H.RequestId
And H.CustomerId = C.CustomerId
and q.RequestId = h.RequestId
And H.Status = 'G'
And W.Status = 'P'
And U.UserID = H.CreatedBy
And H.CustomerId like @CustomerID
And H.SealRequired like 'True'
And C.ParentCustomerId = P.ParentCustomerId
And P.ParentCustomerId like @ParentId

union

Select 
'W' as CertificateType,
'Web' as CType,
W.RequestId, 
CertificatePath, 
CertificateName,
C.CustomerName, 
C.CustomerId,
C.ContactPersonEmail,
H.RequestDate, 
H.InvoiceNo, 
W.Status,
H.TemplateId,
H.SealRequired as SealRequired,
'NO' as CollectionType,
 CONCAT(U.PersonName, '-' ,U.Designation) as Createdby,
 Q.GoodDetails as SummaryDesc,
 P.CustomerName as ParentCustomer

From tblWebBasedCertificateRequest W , tblCertifcateRequestHeader H , tblCustomer C ,tblUser U,tblRowCertificateRequestDetails Q,tblCustomerParent P
Where W.RequestId = H.RequestId
And H.CustomerId = C.CustomerId
and q.RequestId = h.RequestId
And H.Status = 'G'
And W.Status = 'P'
And U.UserID = H.CreatedBy
And H.CustomerId like @CustomerID
And H.SealRequired like 'False'
And C.ParentCustomerId = P.ParentCustomerId
And P.ParentCustomerId like @ParentId

union
--eeeeeeeeee

Select 
'U' as CertificateType,
'Upload' as CType,
U.RequestId, 
UploadPath as CertificatePath,
U.RequestId+'_Upload_Cert.pdf'  as CertificateName,
C.CustomerName, 
C.CustomerId,
C.ContactPersonEmail,
RequestDate, 
InvoiceNo, 
U.Status,
null as TemplateId,
U.SealRequired as SealRequired,
'YES' as CollectionType,
 CONCAT(D.PersonName, '-' ,D.Designation) as Createdby,
 'Not Available' as SummaryDesc,
 P.CustomerName as ParentCustomer

From tblUploadBasedCertificateRequest U, tblCustomer C,tblUser D,tblCustomerParent P
where U.CustomerId = c.CustomerId
and U.Status = 'P'
And D.UserID = U.CreatedBy
and U.CustomerId like @CustomerID
and U.SealRequired like 'True'
And C.ParentCustomerId = P.ParentCustomerId
union

Select 
'U' as CertificateType,
'Upload' as CType,
U.RequestId, 
UploadPath as CertificatePath,
U.RequestId+'_Upload_Cert.pdf'  as CertificateName,
C.CustomerName, 
C.CustomerId,
C.ContactPersonEmail,
RequestDate, 
InvoiceNo, 
U.Status,
null as TemplateId,
U.SealRequired as SealRequired,
'NO' as CollectionType,
 CONCAT(D.PersonName, '-' ,D.Designation) as Createdby,
  'Not Available' as SummaryDesc,
  P.CustomerName as ParentCustomer

From tblUploadBasedCertificateRequest U, tblCustomer C,tblUser D,tblCustomerParent P
where U.CustomerId = c.CustomerId
and U.Status = 'P'
And D.UserID = U.CreatedBy
and U.CustomerId like @CustomerID
and U.SealRequired like 'False'
And C.ParentCustomerId = P.ParentCustomerId
And P.ParentCustomerId like @ParentId


order by RequestDate

END

GO
/****** Object:  StoredProcedure [dbo].[getClientTemplateNName]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getClientTemplateNName](@CustomerId varchar(20),@ParentId varchar(20))
as begin

Select TemplateId,CustomerId,CustomerName + '<br />' + Address1 + '<br />' + Address2 + '<br />' + Address3 as CustomerName,
ContactPersonName,ContactPersonDesignation,ContactPersonDirectPhoneNumber,ContactPersonEmail,ContactPersonMobile
from tblCustomer
Where CustomerId = @CustomerId
And ParentCustomerId = @ParentId

End
GO
/****** Object:  StoredProcedure [dbo].[getCustomerClientList]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[getCustomerClientList](@ParentCustomerID varchar(20))
as Begin
SELECT CustomerId, CustomerName, TemplateId, ParentCustomerId
FROM tblCustomer
WHERE ParentCustomerId like @ParentCustomerID
End
GO
/****** Object:  StoredProcedure [dbo].[getCustomerConsigneesReff]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getCustomerConsigneesReff](@ParentCustomerID varchar(20))
as Begin
SELECT Consignee, CustomerId, RequestId, SeqNo, TemplateName
FROM tblCertificateRequestReffrence
WHERE ParentCustomerId like @ParentCustomerID
End
GO
/****** Object:  Table [dbo].[tblCancelledCertificate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCancelledCertificate](
	[DocumentId] [varchar](20) NOT NULL,
	[CustomerId] [varchar](20) NOT NULL,
	[Remark] [varchar](200) NULL,
	[CancelBy] [varchar](20) NOT NULL,
	[CancelDate] [datetime] NOT NULL,
	[DocumentType] [varchar](1) NOT NULL,
 CONSTRAINT [PK_tblCertificateCancelation] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCancelledInvoice]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCancelledInvoice](
	[InvoiceNo] [varchar](20) NOT NULL,
	[CancelledReasonCode] [varchar](10) NOT NULL,
	[CancelledBy] [varchar](50) NOT NULL,
	[CancelledDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblCancelledInvoice] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertifcateRequestHeader]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertifcateRequestHeader](
	[RequestId] [varchar](20) NOT NULL,
	[TemplateId] [varchar](20) NOT NULL,
	[CustomerId] [varchar](20) NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[Status] [varchar](3) NOT NULL,
	[Consignor] [varchar](500) NULL,
	[Consignee] [varchar](500) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[CountryCode] [varchar](50) NULL,
	[LoadingPort] [varchar](50) NULL,
	[PortOfDischarge] [varchar](50) NULL,
	[Vessel] [varchar](50) NULL,
	[PlaceOfDelivery] [varchar](50) NULL,
	[TotalInvoiceValue] [varchar](50) NULL,
	[TotalQuantity] [varchar](20) NULL,
	[OtherComments] [varchar](150) NULL,
	[OtherDetails] [varchar](250) NULL,
	[ReasonCode] [varchar](10) NULL,
	[SealRequired] [varchar](5) NULL,
 CONSTRAINT [PK_CertifateRequest] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificate](
	[CertificateId] [varchar](20) NOT NULL,
	[RequestId] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[IsDownloaded] [varchar](2) NOT NULL,
	[CertificatePath] [varchar](500) NULL,
	[CertificateName] [varchar](150) NULL,
	[IsValid] [varchar](5) NULL,
	[IsSend] [varchar](5) NULL,
 CONSTRAINT [PK_tblCertificate_1] PRIMARY KEY CLUSTERED 
(
	[CertificateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Uni_RequestID] UNIQUE NONCLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificateApproval]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificateApproval](
	[RequestId] [varchar](20) NOT NULL,
	[ApprovalSequence] [bigint] IDENTITY(1,1) NOT NULL,
	[ApprovalDate] [datetime] NOT NULL,
	[ApprovedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCertificateApproval] PRIMARY KEY CLUSTERED 
(
	[ApprovalSequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificateRequestDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificateRequestDetails](
	[SeqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestId] [varchar](20) NOT NULL,
	[GoodItem] [varchar](500) NULL,
	[ShippingMark] [varchar](500) NULL,
	[PackageType] [varchar](500) NULL,
	[SummaryDesc] [varchar](1000) NULL,
	[Quantity] [varchar](500) NULL,
	[HSCode] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCertificaterRequestDetails] PRIMARY KEY CLUSTERED 
(
	[SeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificateRequestReffrence]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificateRequestReffrence](
	[Consignee] [varchar](250) NULL,
	[CustomerId] [varchar](20) NULL,
	[RequestId] [varchar](20) NULL,
	[SeqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[ParentCustomerId] [varchar](20) NULL,
	[TemplateName] [varchar](150) NULL,
 CONSTRAINT [PK_tblCustomerRequestReffrence] PRIMARY KEY CLUSTERED 
(
	[SeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificateUnitCharge]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificateUnitCharge](
	[TemplateId] [varchar](20) NOT NULL,
	[UnitChargeValue] [decimal](8, 6) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblCertificateUnitCharge] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblContactFormDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblContactFormDetails](
	[seqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Phone] [varchar](20) NOT NULL,
	[Detail] [text] NOT NULL,
	[ViewStatus] [varchar](1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblContactFormDetails] PRIMARY KEY CLUSTERED 
(
	[seqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCountry]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCountry](
	[ID] [bigint] NULL,
	[CountryCode] [varchar](10) NOT NULL,
	[CountryName] [varchar](50) NOT NULL,
	[NickName] [varchar](150) NULL,
	[ISO3] [varchar](50) NULL,
	[NumCode] [bigint] NULL,
	[PhoneCode] [varchar](50) NULL,
 CONSTRAINT [PK_tblCountry_1] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomer]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomer](
	[CustomerId] [varchar](20) NOT NULL,
	[CustomerName] [varchar](150) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[IsSVat] [varchar](10) NOT NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](50) NOT NULL,
	[Address1] [varchar](150) NOT NULL,
	[Address2] [varchar](150) NOT NULL,
	[Address3] [varchar](150) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[ContactPersonName] [varchar](150) NULL,
	[ContactPersonDesignation] [varchar](50) NULL,
	[ContactPersonDirectPhoneNumber] [varchar](20) NULL,
	[ContactPersonMobile] [varchar](20) NULL,
	[ContactPersonEmail] [varchar](50) NULL,
	[ProductDetails] [text] NULL,
	[ExportSector] [int] NULL,
	[NCEMember] [varchar](10) NULL,
	[PaidType] [varchar](10) NULL,
	[ParentCustomerId] [varchar](20) NOT NULL,
	[RequestId] [varchar](20) NULL,
	[TemplateId] [varchar](20) NULL,
 CONSTRAINT [PK_tblCustomer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerApplicableRates]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerApplicableRates](
	[CustomerId] [varchar](20) NOT NULL,
	[RatesId] [varchar](10) NOT NULL,
	[Rates] [decimal](18, 6) NOT NULL,
 CONSTRAINT [PK_tblCustomerApplicableRates] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[RatesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerApplicableTax]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerApplicableTax](
	[CustomerId] [varchar](20) NULL,
	[TaxCode] [varchar](20) NOT NULL,
	[TaxRegistrationNo] [varchar](20) NOT NULL,
	[IsActive] [varchar](1) NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[RequestId] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerEmail]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerEmail](
	[CustomerId] [varchar](20) NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[UserID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblCustomerEmail] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[Email] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerExportSector]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerExportSector](
	[CustomerExportSectorId] [int] IDENTITY(1,1) NOT NULL,
	[RequestNo] [varchar](20) NULL,
	[ExportSectorId] [varchar](20) NULL,
	[CustomerId] [varchar](20) NULL,
	[Status] [varchar](1) NULL,
 CONSTRAINT [PK_tblCustomerExportSector_1] PRIMARY KEY CLUSTERED 
(
	[CustomerExportSectorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerParent]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerParent](
	[ParentCustomerId] [varchar](20) NOT NULL,
	[CustomerName] [varchar](150) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[IsSVat] [varchar](10) NOT NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](50) NOT NULL,
	[Address1] [varchar](150) NOT NULL,
	[Address2] [varchar](150) NOT NULL,
	[Address3] [varchar](150) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[ContactPersonName] [varchar](150) NULL,
	[ContactPersonDesignation] [varchar](50) NULL,
	[ContactPersonDirectPhoneNumber] [varchar](20) NULL,
	[ContactPersonMobile] [varchar](20) NULL,
	[ContactPersonEmail] [varchar](50) NULL,
	[NCEMember] [varchar](10) NULL,
	[PaidType] [varchar](10) NULL,
	[RequestId] [varchar](20) NULL,
 CONSTRAINT [PK_tblCustomerParent] PRIMARY KEY CLUSTERED 
(
	[ParentCustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerParentRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerParentRequest](
	[RequestId] [varchar](20) NOT NULL,
	[CustomerName] [varchar](150) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[IsSVat] [varchar](10) NOT NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](50) NOT NULL,
	[Address1] [varchar](150) NOT NULL,
	[Address2] [varchar](150) NOT NULL,
	[Address3] [varchar](150) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[ContactPersonName] [varchar](150) NULL,
	[ContactPersonDesignation] [varchar](50) NULL,
	[ContactPersonDirectPhoneNumber] [varchar](20) NULL,
	[ContactPersonMobile] [varchar](20) NULL,
	[ContactPersonEmail] [varchar](50) NULL,
	[NCEMember] [varchar](10) NULL,
	[PaidType] [varchar](10) NULL,
	[AdminUserId] [varchar](20) NOT NULL,
	[AdminPassword] [varchar](200) NOT NULL,
	[AdminName] [varchar](150) NULL,
 CONSTRAINT [PK_tblCustomerParentRequest] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerRegistartionFiles]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerRegistartionFiles](
	[CustomerId] [varchar](20) NULL,
	[RegistrationLetterPath] [varchar](200) NOT NULL,
	[RequestLetterPath] [varchar](200) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[RequestId] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerRequest](
	[RequestId] [varchar](20) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Fax] [varchar](20) NULL,
	[Address1] [varchar](150) NOT NULL,
	[Address2] [varchar](150) NULL,
	[Address3] [varchar](150) NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [varchar](20) NULL,
	[SVat] [varchar](10) NOT NULL,
	[TemplateId] [varchar](20) NULL,
	[RejectReasonCode] [varchar](20) NULL,
	[ContactPersonName] [varchar](150) NULL,
	[ContactPersonDesignation] [varchar](50) NULL,
	[ContactPersonDirectPhoneNumber] [varchar](20) NULL,
	[ContactPersonMobile] [varchar](20) NULL,
	[ContactPersonEmail] [varchar](50) NULL,
	[Productdetails] [text] NULL,
	[ExportSector] [int] NULL,
	[NCEMember] [varchar](10) NULL,
	[ParentCustomerId] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblCustomerRequest1] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerTemplate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerTemplate](
	[CustomerId] [varchar](20) NOT NULL,
	[TemplateId] [varchar](20) NOT NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblCustomerTemplate] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDocumentType]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDocumentType](
	[DocumentTypeId] [varchar](10) NOT NULL,
	[DocumentTypeName] [varchar](150) NOT NULL,
	[IsBaseDocument] [varchar](2) NOT NULL,
 CONSTRAINT [PK_tblDocumentType] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblErrorLog]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblErrorLog](
	[UserId] [varchar](50) NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[ErrorMessage] [nvarchar](250) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblExportSector]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblExportSector](
	[ExportId] [int] IDENTITY(1,1) NOT NULL,
	[ExportSector] [varchar](100) NOT NULL,
	[Status] [varchar](1) NULL,
 CONSTRAINT [PK_tblExportSector_1] PRIMARY KEY CLUSTERED 
(
	[ExportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblFunction]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFunction](
	[FunctionId] [varchar](25) NOT NULL,
	[FunctionName] [varchar](150) NOT NULL,
 CONSTRAINT [PK_tblFunction] PRIMARY KEY CLUSTERED 
(
	[FunctionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGroupFunction]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGroupFunction](
	[FunctionId] [varchar](25) NOT NULL,
	[GroupId] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblGroupFunction] PRIMARY KEY CLUSTERED 
(
	[FunctionId] ASC,
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblIgnoredEmailRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblIgnoredEmailRequest](
	[IndexNo] [bigint] IDENTITY(1,1) NOT NULL,
	[MailID] [varchar](150) NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[CustomerId] [varchar](20) NULL,
	[RecivedDate] [datetime] NOT NULL,
	[EmailSubject] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
	[ModifiedBy] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoiceDetail]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoiceDetail](
	[InvoiceLineNo] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestNo] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[UnitCharge] [decimal](18, 8) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[Modifiedby] [varchar](20) NOT NULL,
	[InvoiceNo] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblInvoiceDetail] PRIMARY KEY CLUSTERED 
(
	[InvoiceLineNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoiceHeader]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoiceHeader](
	[InvoiceNo] [varchar](20) NOT NULL,
	[CustomerId] [varchar](10) NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[GrossTotal] [decimal](18, 2) NOT NULL,
	[InvoiceTotal] [decimal](18, 6) NOT NULL,
	[IsTaxInvoice] [varchar](4) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[PrintTime] [int] NOT NULL,
 CONSTRAINT [PK_tblInvoiceHeader_1] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoicePrintCount]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoicePrintCount](
	[InvoiceNo] [varchar](20) NOT NULL,
	[PrintCount] [int] NOT NULL,
	[PrintDate] [date] NOT NULL,
	[PrintReason] [text] NOT NULL,
	[PrintedBy] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblInvoicePrintCount] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC,
	[PrintCount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoiceRate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoiceRate](
	[InvoiceRateId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [varchar](20) NOT NULL,
	[InvoiceNo] [varchar](20) NOT NULL,
	[SupportingDocName] [varchar](50) NOT NULL,
	[RateId] [varchar](10) NOT NULL,
	[RateValue] [decimal](18, 6) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[CreatedDate] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblInvoiceRate] PRIMARY KEY CLUSTERED 
(
	[InvoiceRateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoiceTax]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoiceTax](
	[InvoiceNo] [varchar](20) NOT NULL,
	[TaxCode] [varchar](50) NOT NULL,
	[Amount] [decimal](18, 6) NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[TaxPercentage] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_tblInvoiceTax] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC,
	[TaxCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLoginInfo]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblLoginInfo](
	[SessionId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NOT NULL,
	[SessionStart] [datetime] NOT NULL,
	[SessionEnd] [datetime] NOT NULL,
 CONSTRAINT [PK_tblLoginInfo] PRIMARY KEY CLUSTERED 
(
	[SessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblManualCertificate]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tblManualCertificate](
	[ReferenceNo] [varchar](20) NOT NULL,
	[IssuedDate] [datetime] NULL,
	[ExporterInvoiceNo] [varchar](20) NULL,
	[ItemDescription] [varchar](1) NULL,
	[Status] [varchar](2) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CustomerId] [varchar](20) NULL,
 CONSTRAINT [PK_tblManualCertificate] PRIMARY KEY CLUSTERED 
(
	[ReferenceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMember]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMember](
	[MemberId] [varchar](8) NOT NULL,
	[MemberName] [varchar](150) NOT NULL,
	[JoinedDate] [datetime] NOT NULL,
	[MemberType] [varchar](8) NULL,
 CONSTRAINT [PK_tblMember] PRIMARY KEY CLUSTERED 
(
	[MemberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMemberRates]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMemberRates](
	[RateID] [varchar](20) NOT NULL,
	[RateValue] [decimal](18, 6) NOT NULL,
	[Member] [varchar](1) NOT NULL,
 CONSTRAINT [PK_tblMemberRates] PRIMARY KEY CLUSTERED 
(
	[RateID] ASC,
	[RateValue] ASC,
	[Member] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMemberType]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMemberType](
	[MemberTypeId] [varchar](8) NOT NULL,
	[MemeberType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblMemberType] PRIMARY KEY CLUSTERED 
(
	[MemberTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOwnerDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOwnerDetails](
	[OrganizationName] [varchar](150) NOT NULL,
	[OwnerId] [varchar](8) NOT NULL,
	[PostBox] [varchar](10) NOT NULL,
	[Address1] [varchar](120) NULL,
	[Address2] [varchar](120) NULL,
	[Address3] [varchar](50) NOT NULL,
	[VARRegNo] [varchar](50) NULL,
	[SVATregNo] [varchar](50) NULL,
	[TelephoneNo] [varchar](10) NOT NULL,
	[FaxNo] [varchar](15) NULL,
	[Email] [varchar](100) NULL,
	[WebAddress] [varchar](150) NULL,
	[ImageUrls] [varchar](150) NULL,
	[Name] [varchar](150) NULL,
 CONSTRAINT [PK_tblOwnerDetails] PRIMARY KEY CLUSTERED 
(
	[OwnerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPackageType]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPackageType](
	[PackageType] [varchar](20) NOT NULL,
	[PackageDescription] [varchar](150) NULL,
	[IsActive] [varchar](1) NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [date] NULL,
 CONSTRAINT [PK_tblPackageType] PRIMARY KEY CLUSTERED 
(
	[PackageType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblParameter]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblParameter](
	[ParameterCode] [varchar](20) NOT NULL,
	[ParameterDescription] [varchar](150) NOT NULL,
	[ParameterValue] [varchar](200) NOT NULL,
 CONSTRAINT [PK_tblParameter] PRIMARY KEY CLUSTERED 
(
	[ParameterCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPort]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPort](
	[PortId] [varchar](20) NOT NULL,
	[PortName] [varchar](150) NOT NULL,
	[Active] [varchar](1) NOT NULL,
 CONSTRAINT [PK_tblPort] PRIMARY KEY CLUSTERED 
(
	[PortId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRates]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRates](
	[RateId] [varchar](10) NOT NULL,
	[RateName] [varchar](50) NOT NULL,
	[Status] [varchar](2) NOT NULL,
 CONSTRAINT [PK_tblRates] PRIMARY KEY CLUSTERED 
(
	[RateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRejectReasonCategory]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRejectReasonCategory](
	[RejectReasonsCategory] [varchar](20) NOT NULL,
	[CategoryDescription] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tblRejectReasonCategory] PRIMARY KEY CLUSTERED 
(
	[RejectReasonsCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRejectReasons]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRejectReasons](
	[RejectCode] [varchar](20) NOT NULL,
	[ReasonName] [varchar](150) NOT NULL,
	[Category] [varchar](20) NOT NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
	[IsActive] [varchar](1) NULL,
	[CreatedDate] [date] NULL,
	[CreatedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblRejectReasons] PRIMARY KEY CLUSTERED 
(
	[RejectCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRowCertificateRequestDetails]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRowCertificateRequestDetails](
	[SeqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestId] [varchar](20) NOT NULL,
	[GoodDetails] [varchar](500) NOT NULL,
	[QuantityDetails] [varchar](300) NULL,
	[HSCodeDetails] [varchar](300) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblRowCertificateRequestDetails] PRIMARY KEY CLUSTERED 
(
	[SeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSequence]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSequence](
	[SequenceName] [varchar](50) NOT NULL,
	[SequesnceValue] [bigint] NULL,
 CONSTRAINT [PK_tblSequence] PRIMARY KEY CLUSTERED 
(
	[SequenceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSignatureLevelHeader]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSignatureLevelHeader](
	[LevelID] [varchar](10) NOT NULL,
	[Description] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSignatureLevels]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSignatureLevels](
	[UserId] [varchar](20) NOT NULL,
	[LevelId] [varchar](20) NOT NULL,
	[TemplateId] [varchar](20) NOT NULL,
	[IsActive] [varchar](1) NULL,
	[ModifiedDate] [date] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [date] NULL,
 CONSTRAINT [PK_tblSignatureLevels] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSupportingDocApproveRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSupportingDocApproveRequest](
	[RequestID] [varchar](20) NOT NULL,
	[SupportingDocID] [varchar](20) NULL,
	[CustomerID] [varchar](20) NULL,
	[RequestDate] [datetime] NULL,
	[RequestBy] [varchar](20) NULL,
	[Status] [varchar](5) NOT NULL,
	[ApprovedBy] [varchar](20) NULL,
	[ApprovedDate] [datetime] NULL,
	[UploadPath] [varchar](250) NOT NULL,
	[UploadDocName] [varchar](50) NOT NULL,
	[DownloadPath] [varchar](250) NULL,
	[DownloadDocName] [varchar](50) NULL,
	[RejectReasonCode] [varchar](20) NULL,
	[DocExpireDate] [date] NULL,
	[IsDownloaded] [varchar](5) NULL,
	[IsValid] [varchar](5) NULL,
	[CertificateRequestId] [varchar](20) NULL,
 CONSTRAINT [PK_tblSupportingDoc] PRIMARY KEY CLUSTERED 
(
	[RequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSupportingDocumentConfig]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSupportingDocumentConfig](
	[SupportingDocId] [varchar](20) NOT NULL,
	[LLXcordinates] [decimal](18, 2) NOT NULL,
	[LLYcordinates] [decimal](18, 2) NOT NULL,
	[URXcordinates] [decimal](18, 2) NOT NULL,
	[URYcordinates] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_tblSupportingDocumentConfig] PRIMARY KEY CLUSTERED 
(
	[SupportingDocId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSupportingDocuments]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSupportingDocuments](
	[SupportingDocumentId] [varchar](20) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IsMandatory] [varchar](2) NULL,
	[IsActive] [varchar](2) NULL,
	[SupportingDocumentName] [varchar](100) NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
 CONSTRAINT [PK_tblSupportingDocuments] PRIMARY KEY CLUSTERED 
(
	[SupportingDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSupportingDOCUpload]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSupportingDOCUpload](
	[RequestRefNo] [varchar](20) NOT NULL,
	[SupportingDocumentId] [varchar](8) NOT NULL,
	[Remarks] [varchar](150) NULL,
	[UploadedDate] [datetime] NOT NULL,
	[UploadedBy] [varchar](20) NOT NULL,
	[UploadedPath] [varchar](250) NOT NULL,
	[UploadSeqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[DocumentName] [varchar](150) NULL,
	[SignatureRequired] [varchar](5) NULL,
 CONSTRAINT [PK_tblSupportingDOCUpload_1] PRIMARY KEY CLUSTERED 
(
	[UploadSeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTax]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTax](
	[TaxCode] [varchar](20) NOT NULL,
	[TaxName] [nvarchar](100) NOT NULL,
	[TaxPercentage] [decimal](18, 2) NOT NULL,
	[TaxPriority] [int] NULL,
	[IsActive] [varchar](1) NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
 CONSTRAINT [PK_tblTax] PRIMARY KEY CLUSTERED 
(
	[TaxCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTaxPriorityList]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaxPriorityList](
	[PriorityNo] [int] NOT NULL,
	[PriorityDescription] [varchar](150) NULL,
 CONSTRAINT [PK_tblTaxPriorityList] PRIMARY KEY CLUSTERED 
(
	[PriorityNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTaxSummary]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaxSummary](
	[TaxId] [varchar](20) NOT NULL,
	[InvoiceNo] [varchar](20) NOT NULL,
	[TaxAmount] [decimal](8, 6) NOT NULL,
	[Date] [datetime] NOT NULL,
	[TaxPercentage] [decimal](8, 6) NOT NULL,
 CONSTRAINT [PK_tblTaxSummary] PRIMARY KEY CLUSTERED 
(
	[TaxId] ASC,
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTemplateDownload]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTemplateDownload](
	[IndexNo] [bigint] IDENTITY(1,1) NOT NULL,
	[TemplateID] [varchar](20) NOT NULL,
	[TemplateDName] [varchar](150) NOT NULL,
	[TemplateIMGPath] [varchar](250) NOT NULL,
	[DownloadPath] [varchar](250) NOT NULL,
	[DownlaodedTime] [bigint] NULL,
 CONSTRAINT [PK_tblTemplateDownload] PRIMARY KEY CLUSTERED 
(
	[IndexNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTemplateHeader]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTemplateHeader](
	[TemplateId] [varchar](20) NOT NULL,
	[TemplateName] [nvarchar](50) NOT NULL,
	[ImgUrl] [nchar](200) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsActive] [varchar](1) NOT NULL,
	[ModifiedBy] [varchar](20) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[Description] [text] NULL,
	[TemplatePath] [varchar](250) NULL,
	[AdminOnly] [varchar](2) NULL,
 CONSTRAINT [PK_tblTemplateHeader_1] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTemplateSupportingDocument]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTemplateSupportingDocument](
	[SupportingDocumentId] [varchar](20) NOT NULL,
	[TemplateId] [varchar](20) NOT NULL,
	[CreatedBy] [varchar](20) NULL,
	[IsActive] [varchar](1) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
	[IsMandatory] [varchar](1) NULL,
	[TemplateSupportingDocument] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_tblTemplateSupportingDocument_1] PRIMARY KEY CLUSTERED 
(
	[TemplateSupportingDocument] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUploadBasedCertificateRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUploadBasedCertificateRequest](
	[RequestId] [varchar](20) NOT NULL,
	[CustomerId] [varchar](20) NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[Status] [varchar](5) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[InvoiceNo] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [varchar](20) NULL,
	[CertificatePath] [varchar](250) NULL,
	[UploadPath] [varchar](250) NULL,
	[RejectReasonCode] [varchar](20) NULL,
	[CertificateId] [varchar](20) NULL,
	[Remark] [varchar](50) NULL,
	[SealRequired] [varchar](5) NULL,
 CONSTRAINT [PK_tblUploadBasedCertificateRequest] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUser](
	[UserID] [varchar](20) NOT NULL,
	[UserGroupID] [varchar](20) NOT NULL,
	[PersonName] [varchar](150) NOT NULL,
	[Password] [nvarchar](200) NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[IsActive] [varchar](1) NOT NULL,
	[PassowordExpiryDate] [datetime] NOT NULL,
	[ParentCustomerId] [varchar](20) NULL,
	[Designation] [varchar](50) NULL,
	[RandomID] [varchar](20) NULL,
	[Email] [varchar](50) NULL,
 CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserGroup]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserGroup](
	[GroupId] [varchar](20) NOT NULL,
	[GroupName] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [varchar](1) NOT NULL,
	[CreatedBy] [nvarchar](20) NOT NULL,
	[ModifiedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblUserGroup] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserRequest](
	[UserRequestId] [varchar](20) NOT NULL,
	[UserId] [varchar](20) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ApprovedBy] [varchar](50) NOT NULL,
	[Password] [varchar](150) NOT NULL,
	[ModifiedBy] [varchar](20) NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[PersonName] [varchar](150) NULL,
	[UserGroupID] [varchar](20) NULL,
	[ParentCustomerId] [varchar](20) NULL,
	[RejectReason] [varchar](20) NULL,
 CONSTRAINT [PK_tblUserRequest] PRIMARY KEY CLUSTERED 
(
	[UserRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserSignature]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserSignature](
	[UserID] [varchar](20) NOT NULL,
	[PFXpath] [nvarchar](250) NOT NULL,
	[SignatureIMGPath] [nvarchar](250) NOT NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblUserSignature] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblWebBasedCertificateRequest]    Script Date: 11/8/2018 11:37:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblWebBasedCertificateRequest](
	[IndexNo] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestId] [varchar](20) NOT NULL,
	[CertificatePath] [varchar](250) NOT NULL,
	[CertificateName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Status] [varchar](5) NOT NULL,
 CONSTRAINT [PK_tblWebBasedCertificateRequest] PRIMARY KEY CLUSTERED 
(
	[IndexNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblContactFormDetails] ADD  CONSTRAINT [DF_tblContactFormDetails_ViewStatus]  DEFAULT ('N') FOR [ViewStatus]
GO
ALTER TABLE [dbo].[tblExportSector] ADD  CONSTRAINT [DF_tblExportSector_Status]  DEFAULT ('Y') FOR [Status]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] ADD  CONSTRAINT [DF_tblUploadBasedCertificateRequest_Remark]  DEFAULT ('A') FOR [Remark]
GO
ALTER TABLE [dbo].[tblCancelledCertificate]  WITH CHECK ADD  CONSTRAINT [FK_tblCancelledcertificate_tblCustomer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[tblCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[tblCancelledCertificate] CHECK CONSTRAINT [FK_tblCancelledcertificate_tblCustomer]
GO
ALTER TABLE [dbo].[tblCertifcateRequestHeader]  WITH CHECK ADD  CONSTRAINT [FK_tblCertifateRequest_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblCertifcateRequestHeader] CHECK CONSTRAINT [FK_tblCertifateRequest_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblCertifcateRequestHeader]  WITH CHECK ADD  CONSTRAINT [FK_tblCertifateRequest_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblCertifcateRequestHeader] CHECK CONSTRAINT [FK_tblCertifateRequest_tblUser]
GO
ALTER TABLE [dbo].[tblCertificate]  WITH CHECK ADD  CONSTRAINT [FK_tblCertificate_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblCertificate] CHECK CONSTRAINT [FK_tblCertificate_tblUser]
GO
ALTER TABLE [dbo].[tblCertificateRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblCertificaterRequestDetails_tblCertifcateRequestHeader] FOREIGN KEY([RequestId])
REFERENCES [dbo].[tblCertifcateRequestHeader] ([RequestId])
GO
ALTER TABLE [dbo].[tblCertificateRequestDetails] CHECK CONSTRAINT [FK_tblCertificaterRequestDetails_tblCertifcateRequestHeader]
GO
ALTER TABLE [dbo].[tblCertificateRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblCertificaterRequestDetails_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblCertificateRequestDetails] CHECK CONSTRAINT [FK_tblCertificaterRequestDetails_tblUser]
GO
ALTER TABLE [dbo].[tblCustomer]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomer_tblCustomerParent] FOREIGN KEY([ParentCustomerId])
REFERENCES [dbo].[tblCustomerParent] ([ParentCustomerId])
GO
ALTER TABLE [dbo].[tblCustomer] CHECK CONSTRAINT [FK_tblCustomer_tblCustomerParent]
GO
ALTER TABLE [dbo].[tblCustomer]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomer_tblCustomerRequest] FOREIGN KEY([RequestId])
REFERENCES [dbo].[tblCustomerRequest] ([RequestId])
GO
ALTER TABLE [dbo].[tblCustomer] CHECK CONSTRAINT [FK_tblCustomer_tblCustomerRequest]
GO
ALTER TABLE [dbo].[tblCustomer]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomer_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblCustomer] CHECK CONSTRAINT [FK_tblCustomer_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblCustomerParent]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerParent_tblCustomerParentRequest] FOREIGN KEY([RequestId])
REFERENCES [dbo].[tblCustomerParentRequest] ([RequestId])
GO
ALTER TABLE [dbo].[tblCustomerParent] CHECK CONSTRAINT [FK_tblCustomerParent_tblCustomerParentRequest]
GO
ALTER TABLE [dbo].[tblCustomerRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerRequest_tblCustomerParent] FOREIGN KEY([ParentCustomerId])
REFERENCES [dbo].[tblCustomerParent] ([ParentCustomerId])
GO
ALTER TABLE [dbo].[tblCustomerRequest] CHECK CONSTRAINT [FK_tblCustomerRequest_tblCustomerParent]
GO
ALTER TABLE [dbo].[tblCustomerRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerRequest_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblCustomerRequest] CHECK CONSTRAINT [FK_tblCustomerRequest_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblCustomerTemplate]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerTemplate_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblCustomerTemplate] CHECK CONSTRAINT [FK_tblCustomerTemplate_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblCustomerTemplate]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerTemplate_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblCustomerTemplate] CHECK CONSTRAINT [FK_tblCustomerTemplate_tblUser]
GO
ALTER TABLE [dbo].[tblGroupFunction]  WITH CHECK ADD  CONSTRAINT [FK_tblGroupFunction_tblFunction] FOREIGN KEY([FunctionId])
REFERENCES [dbo].[tblFunction] ([FunctionId])
GO
ALTER TABLE [dbo].[tblGroupFunction] CHECK CONSTRAINT [FK_tblGroupFunction_tblFunction]
GO
ALTER TABLE [dbo].[tblIgnoredEmailRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblIgnoredEmailRequest_tblCustomer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[tblCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[tblIgnoredEmailRequest] CHECK CONSTRAINT [FK_tblIgnoredEmailRequest_tblCustomer]
GO
ALTER TABLE [dbo].[tblIgnoredEmailRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblIgnoredEmailRequest_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblIgnoredEmailRequest] CHECK CONSTRAINT [FK_tblIgnoredEmailRequest_tblUser]
GO
ALTER TABLE [dbo].[tblInvoicePrintCount]  WITH CHECK ADD  CONSTRAINT [FK_tblInvoicePrintCount_tblInvoiceHeader] FOREIGN KEY([InvoiceNo])
REFERENCES [dbo].[tblInvoiceHeader] ([InvoiceNo])
GO
ALTER TABLE [dbo].[tblInvoicePrintCount] CHECK CONSTRAINT [FK_tblInvoicePrintCount_tblInvoiceHeader]
GO
ALTER TABLE [dbo].[tblInvoicePrintCount]  WITH CHECK ADD  CONSTRAINT [FK_tblInvoicePrintCount_tblUser] FOREIGN KEY([PrintedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblInvoicePrintCount] CHECK CONSTRAINT [FK_tblInvoicePrintCount_tblUser]
GO
ALTER TABLE [dbo].[tblRejectReasons]  WITH CHECK ADD  CONSTRAINT [FK_tblRejectReasons_tblRejectReasonCategory] FOREIGN KEY([Category])
REFERENCES [dbo].[tblRejectReasonCategory] ([RejectReasonsCategory])
GO
ALTER TABLE [dbo].[tblRejectReasons] CHECK CONSTRAINT [FK_tblRejectReasons_tblRejectReasonCategory]
GO
ALTER TABLE [dbo].[tblRejectReasons]  WITH CHECK ADD  CONSTRAINT [FK_tblRejectReasons_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblRejectReasons] CHECK CONSTRAINT [FK_tblRejectReasons_tblUser]
GO
ALTER TABLE [dbo].[tblRowCertificateRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblRowCertificateRequestDetails_tblCertifcateRequestHeader] FOREIGN KEY([RequestId])
REFERENCES [dbo].[tblCertifcateRequestHeader] ([RequestId])
GO
ALTER TABLE [dbo].[tblRowCertificateRequestDetails] CHECK CONSTRAINT [FK_tblRowCertificateRequestDetails_tblCertifcateRequestHeader]
GO
ALTER TABLE [dbo].[tblRowCertificateRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblRowCertificateRequestDetails_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblRowCertificateRequestDetails] CHECK CONSTRAINT [FK_tblRowCertificateRequestDetails_tblUser]
GO
ALTER TABLE [dbo].[tblSignatureLevels]  WITH CHECK ADD  CONSTRAINT [FK_tblSignatureLevels_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblSignatureLevels] CHECK CONSTRAINT [FK_tblSignatureLevels_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblSignatureLevels]  WITH CHECK ADD  CONSTRAINT [FK_tblSignatureLevels_tblUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSignatureLevels] CHECK CONSTRAINT [FK_tblSignatureLevels_tblUser]
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDoc_tblSupportingDoc] FOREIGN KEY([RejectReasonCode])
REFERENCES [dbo].[tblRejectReasons] ([RejectCode])
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest] CHECK CONSTRAINT [FK_tblSupportingDoc_tblSupportingDoc]
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocApproveRequest_tblCustomer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[tblCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest] CHECK CONSTRAINT [FK_tblSupportingDocApproveRequest_tblCustomer]
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocApproveRequest_tblUser] FOREIGN KEY([RequestBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest] CHECK CONSTRAINT [FK_tblSupportingDocApproveRequest_tblUser]
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocApproveRequest_tblUser1] FOREIGN KEY([ApprovedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest] CHECK CONSTRAINT [FK_tblSupportingDocApproveRequest_tblUser1]
GO
ALTER TABLE [dbo].[tblSupportingDocuments]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocuments_tblSupportingDocuments] FOREIGN KEY([SupportingDocumentId])
REFERENCES [dbo].[tblSupportingDocuments] ([SupportingDocumentId])
GO
ALTER TABLE [dbo].[tblSupportingDocuments] CHECK CONSTRAINT [FK_tblSupportingDocuments_tblSupportingDocuments]
GO
ALTER TABLE [dbo].[tblSupportingDocuments]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocuments_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDocuments] CHECK CONSTRAINT [FK_tblSupportingDocuments_tblUser]
GO
ALTER TABLE [dbo].[tblSupportingDocuments]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocuments_tblUser1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDocuments] CHECK CONSTRAINT [FK_tblSupportingDocuments_tblUser1]
GO
ALTER TABLE [dbo].[tblSupportingDOCUpload]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDOCUpload_tblUser] FOREIGN KEY([UploadedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDOCUpload] CHECK CONSTRAINT [FK_tblSupportingDOCUpload_tblUser]
GO
ALTER TABLE [dbo].[tblTax]  WITH CHECK ADD  CONSTRAINT [FK_tblTax_tblTaxPriorityList] FOREIGN KEY([TaxPriority])
REFERENCES [dbo].[tblTaxPriorityList] ([PriorityNo])
GO
ALTER TABLE [dbo].[tblTax] CHECK CONSTRAINT [FK_tblTax_tblTaxPriorityList]
GO
ALTER TABLE [dbo].[tblTax]  WITH CHECK ADD  CONSTRAINT [FK_tblTax_tblUser] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblTax] CHECK CONSTRAINT [FK_tblTax_tblUser]
GO
ALTER TABLE [dbo].[tblTemplateHeader]  WITH CHECK ADD  CONSTRAINT [FK_tblTemplateHeader_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblTemplateHeader] CHECK CONSTRAINT [FK_tblTemplateHeader_tblUser]
GO
ALTER TABLE [dbo].[tblTemplateHeader]  WITH CHECK ADD  CONSTRAINT [FK_tblTemplateHeader_tblUser1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblTemplateHeader] CHECK CONSTRAINT [FK_tblTemplateHeader_tblUser1]
GO
ALTER TABLE [dbo].[tblTemplateSupportingDocument]  WITH CHECK ADD  CONSTRAINT [FK_tblTemplateSupportingDocument_tblSupportingDocuments] FOREIGN KEY([SupportingDocumentId])
REFERENCES [dbo].[tblSupportingDocuments] ([SupportingDocumentId])
GO
ALTER TABLE [dbo].[tblTemplateSupportingDocument] CHECK CONSTRAINT [FK_tblTemplateSupportingDocument_tblSupportingDocuments]
GO
ALTER TABLE [dbo].[tblTemplateSupportingDocument]  WITH CHECK ADD  CONSTRAINT [FK_tblTemplateSupportingDocument_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblTemplateSupportingDocument] CHECK CONSTRAINT [FK_tblTemplateSupportingDocument_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblCertificate] FOREIGN KEY([CertificateId])
REFERENCES [dbo].[tblCertificate] ([CertificateId])
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] CHECK CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblCertificate]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblRejectReasons] FOREIGN KEY([RejectReasonCode])
REFERENCES [dbo].[tblRejectReasons] ([RejectCode])
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] CHECK CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblRejectReasons]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] CHECK CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblUser]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblUser1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] CHECK CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblUser1]
GO
ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [FK_tblUser_tblCustomer] FOREIGN KEY([ParentCustomerId])
REFERENCES [dbo].[tblCustomerParent] ([ParentCustomerId])
GO
ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [FK_tblUser_tblCustomer]
GO
ALTER TABLE [dbo].[tblUserGroup]  WITH CHECK ADD  CONSTRAINT [FK_tblUserGroup_tblUserGroup1] FOREIGN KEY([GroupId])
REFERENCES [dbo].[tblUserGroup] ([GroupId])
GO
ALTER TABLE [dbo].[tblUserGroup] CHECK CONSTRAINT [FK_tblUserGroup_tblUserGroup1]
GO
ALTER TABLE [dbo].[tblUserRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUserRequest_tblCustomer] FOREIGN KEY([ParentCustomerId])
REFERENCES [dbo].[tblCustomerParent] ([ParentCustomerId])
GO
ALTER TABLE [dbo].[tblUserRequest] CHECK CONSTRAINT [FK_tblUserRequest_tblCustomer]
GO
ALTER TABLE [dbo].[tblUserRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUserRequest_tblRejectReasons] FOREIGN KEY([RejectReason])
REFERENCES [dbo].[tblRejectReasons] ([RejectCode])
GO
ALTER TABLE [dbo].[tblUserRequest] CHECK CONSTRAINT [FK_tblUserRequest_tblRejectReasons]
GO
ALTER TABLE [dbo].[tblUserRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUserRequest_tblUserGroup] FOREIGN KEY([UserGroupID])
REFERENCES [dbo].[tblUserGroup] ([GroupId])
GO
ALTER TABLE [dbo].[tblUserRequest] CHECK CONSTRAINT [FK_tblUserRequest_tblUserGroup]
GO
ALTER TABLE [dbo].[tblUserSignature]  WITH CHECK ADD  CONSTRAINT [FK_tblUserSignature_tblUserSignature] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblUserSignature] CHECK CONSTRAINT [FK_tblUserSignature_tblUserSignature]
GO
USE [master]
GO
ALTER DATABASE [NCEDCO] SET  READ_WRITE 
GO
