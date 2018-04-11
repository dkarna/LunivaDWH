CREATE TABLE DataWareHouse.[dbo].[BillMaster_Mah](
	[BillMasterID] [int] IDENTITY(1,1) NOT NULL,
	[BillNo] [varchar](20) NOT NULL,
	[_PatientId] [int] NOT NULL,
	[BillDate] [datetime] NOT NULL,
	[BillPrice] [money] NOT NULL,
	[BillDiscount] [float] NOT NULL,
	[BillHSTAmount] [money] NOT NULL,
	[BillTotal] [money] NOT NULL,
	[BillPaid] [money] NOT NULL,
	[BillBalance] [money] NOT NULL,
	[IsOutGoing] [bit] NOT NULL,
	[BillPaymentType] [varchar](50) NULL,
	[BillOutgoingAmt] [money] NULL,
	[BillOutgoingDiscAmt] [money] NULL,
	[BillOutgoingPct] [float] NULL,
	[BillVoid] [bit] NULL,
	[BillCreatedBy] [varchar](100) NULL,
	[BillModifiedBy] [varchar](100) NULL,
	[BillModifiedDate] [datetime] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[BillMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


-- insert values in BillMaster table

insert into DataWareHouse.dbo.BillMaster_Mah
select tpb.BillNo as BillNo
,tpb.PatId as _PatientId
,tpb.BillDate as BillDate
,isnull(tpb.Price,0) as BillPrice
,isnull(tpb.BillDiscountAmt,0) as BillDiscount
,isnull(tpb.BillHstAmt,0) as BillHSTAmount
,isnull(tpb.TotalPrice,0) as BillTotal
,isnull(tpb.BillAmtPaid,0) as BillPaid
,isnull(tpb.BillRemainingAmt,0) as BillBalance
,case when isnull(tpb.BillOutGngAmt,0) > 0 then 1 else 0 end as IsOutGoing
,tpb.BillPaymentType as BillPaymentType
,isnull(tpb.BillOutGngAmtPc,0) as BillOutgoingAmt
,isnull(tpb.BillOutGngDiscountAmt,0) as BillOutgoingDiscAmt
,isnull(tpb.BillOutGngAmtPc,0) as BillOutgoingPct
,tpb.BillIsVoid as BillVoid
,tau.usrFullName as BillCreatedBy
,mtau.usrFullName as BillModifiedBy
,tpb.BillLastModifiedDate as BillModifiedDate
,getdate() as CreateTs
,getdate() as UpdateTs
from pat.tbl_PatientBill tpb
join dbo.tbl_appUsers tau on tpb.UserId = tau.usruserid  -- bills creating user
join dbo.tbl_appUsers mtau on tpb.UserId=mtau.usruserid