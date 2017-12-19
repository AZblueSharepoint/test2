SELECT 
       MEMBER_FIRST_NAME AS 'Beneficiary First Name'
     , MEMBER_LAST_NAME AS 'Beneficiary Last Name'
     , CARDHOLDER_ID AS 'Cardholder ID'
     , CONTRACT_ID AS 'Contract ID'
     , PLAN_ID AS 'Plan ID'
     , CASE       
        WHEN  GRIEVANCE_REPORTED_BY in ('Member','B') THEN 'B'
        WHEN  GRIEVANCE_REPORTED_BY in ('Member''s Representative','BR') THEN 'BR' 
       END  AS 'Person who made the request'
     , CONVERT(VARCHAR(10),RECEIVED_DATE,111) AS 'Date Grievance/Complaint was received'
     , RECEIVED_TIME AS 'Time Grievance/Complaint was received'
     ,  CASE RECEIVED_HOW
	WHEN 'Oral' THEN 'Oral' 
        WHEN 'Phone Call' THEN 'Oral'
	WHEN 'Walk in' THEN 'Oral'
       ELSE 'Written' END AS 'How was the grievance/complaint received?'
     , CATEGORY AS 'Category of the Grievance/Complaint'
     , ISSUE_DESC AS 'Grievance/Complaint Description'   
     , COALESCE(CONVERT(VARCHAR(10),VERBAL_NOTIFICATION_DATE ,111),'NA') AS 'Date oral notification of resolution provided to enrollee'
     , COALESCE(CAST(VERBAL_NOTIFICATION_TIME AS VARCHAR),'NA') AS 'Time oral notification of resolution provided to enrollee'
     , COALESCE(CONVERT(VARCHAR(10),WRITTEN_NOTIFICATION_DATE,111),'NA') AS  'Date written notification of resolution provided to enrollee'
     , COALESCE(CAST(WRITTEN_NOTIFICATION_TIME AS VARCHAR),'NA') AS 'Time written notification of resolution provided to enrollee'
     , RESOLUTION_DESC AS 'Resolution Description'
     , COALESCE(CONVERT(VARCHAR(10),AOR_RECEIPT_DATE,111),'NA') AS 'AOR receipt date'
     , '' AS 'AOR receipt time'
     , 'NA' AS 'First Tier, Downstream, and Related Entity'
     , GRIEVANCE_RECORD_NUMBER
     , ASSESSMENT_ID
     ,ASSUMED_RESOLUTION_DATE
     , ASSESSMENT_START_DATE
     , ASSESSMENT_COMPLETE
     , ASSESSMENT_END_DATE
     , ASSESSMENT_END_TIME
     , GRIEVANCE_TIMEFRAME
     , GRIEVANCE_TYPE
     , RESOLUTION
     , DATA_CORRECTION
     , GRIEVANCE_TYPE_UPDATE
     , GRIEVANCE_CATEGORY_UPDATE
     , AOR_DATE_UPDATE
     , WRITTEN_NOTIFICATION_DATE_UPDATE
     , VERBAL_NOTIFICATION_DATE_UPDATE
     , RECEIVED_HOW_UPDATE
     , CASE_REQUESTED_BY_UPDATE
     ,[Issue_Desc_Update]
     ,[Resolution_Desc_Update]
     ,[Receive_Date_Update]
     ,[ASSUMED_RESOLUTION_DATE_UPDATE]
FROM dbo.vitalgrievances
WHERE GRIEVANCE_TIMEFRAME = 'Expedited'
AND GRIEVANCE_TYPE = 'Part C'
AND (RESOLUTION not like 'Dismissed%' or RESOLUTION is NULL)
AND (VERBAL_NOTIFICATION_DATE BETWEEN (@StartDate) and (@EndDate)
     OR 
     WRITTEN_NOTIFICATION_DATE BETWEEN (@StartDate) and (@EndDate)
     OR
     ASSUMED_RESOLUTION_DATE BETWEEN (@StartDate) and (@EndDate)
     OR
     (VERBAL_NOTIFICATION_DATE is null and WRITTEN_NOTIFICATION_DATE is null and ASSESSMENT_COMPLETE='N'  )
)

AND ASSESSMENT_COMPLETE in (@Completion)