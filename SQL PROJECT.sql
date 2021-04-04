-- QUERY 1
SELECT ClaimantID, ReopenedDate 
FROM Claimant;

-- QUERY 2
SELECT PK, MAX(EntryDate) AS ExamnierAssignedDate
FROM ClaimLog
WHERE FieldName = 'ExaminerCode'
GROUP BY PK;

-- QUERY 3
SELECT ClaimNumber, MAX(EnteredOn) AS LastSavedOn
FROM ReservingTool
WHERE IsPublished = 1
GROUP BY ClaimNumber;