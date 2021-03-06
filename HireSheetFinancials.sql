/****** Script for SelectTopNRows command from SSMS  ******/
use scribe_forms
go

Select c.Cost as 'ExternalFieldCost'
	,gb.JOB_NUMBER
	,gb.STUDY_NAME
	,gb.INITIAL_AMOUNT
	,gb.SALES_CODE
	,gb.ESTIMATED_STAFF_COST
	,u.LAST_NAME
	,u.DEPT_ID
from(
	Select jobid, 
		sum(Cost) as 'Cost'
	from (
		Select h.*, g.* 
		from dbo.hiresheets h
		inner join (
			Select HireSheetId,
			sum(TotalCost) as 'Cost'
			from dbo.Vendors 
			group by hiresheetid
		) g
		on h.Id = g.HireSheetId
		where LastPolarisSync is not null
	) a
	group by JobId
) c
inner join View_FrameworkLRW_GB_JOB_ACCT_INFO gb
on c.JobId = gb.id
inner join View_FrameworkLRW_USER u
on gb.ACCOUNT_MANAGER_ID = u.ID

