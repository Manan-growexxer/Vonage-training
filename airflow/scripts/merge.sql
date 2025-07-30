MERGE INTO {{ database }}.{{ schema }}.{{ attendance_table }} AS target
USING (
    SELECT 1 AS EMP_ID, '2024-07-01'::DATE AS ATTENDANCE_DATE, 'Present' AS STATUS
    UNION ALL
    SELECT 2, '2024-07-01'::DATE, 'Leave'
    UNION ALL
    SELECT 3, '2024-07-01'::DATE, 'Absent'
) AS source
ON target.EMP_ID = source.EMP_ID AND target.ATTENDANCE_DATE = source.ATTENDANCE_DATE
WHEN MATCHED THEN
    UPDATE SET target.STATUS = source.STATUS
WHEN NOT MATCHED THEN
    INSERT (EMP_ID, ATTENDANCE_DATE, STATUS)
    VALUES (source.EMP_ID, source.ATTENDANCE_DATE, source.STATUS);
