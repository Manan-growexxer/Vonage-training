select * from DEV_DB.DEV_SCHEMA.EMPLOYEE;

select * from DEV_DB.DEV_SCHEMA.EMPLOYEE where EMP_ID=2;


delete from DEV_DB.DEV_SCHEMA.EMPLOYEE where EMP_ID=2;

CREATE TABLE DEV_DB.DEV_SCHEMA.ATTENDANCE (
    EMP_ID         NUMBER(10, 0),
    ATTENDANCE_DATE DATE,
    STATUS         VARCHAR(10),  
    PRIMARY KEY (EMP_ID, ATTENDANCE_DATE)
);

INSERT INTO DEV_DB.DEV_SCHEMA.ATTENDANCE (EMP_ID, ATTENDANCE_DATE, STATUS) VALUES
(1, '2024-07-01', 'Present'),
(2, '2024-07-01', 'Present'),
(3, '2024-07-01', 'Absent'),
(4, '2024-07-01', 'Present'),
(5, '2024-07-01', 'Leave'),
(6, '2024-07-01', 'Present'),
(7, '2024-07-01', 'Present'),
(8, '2024-07-01', 'Absent'),
(9, '2024-07-01', 'Present'),
(10, '2024-07-01', 'Present'),
(11, '2024-07-01', 'Leave'),
(12, '2024-07-01', 'Present'),
(13, '2024-07-01', 'Present'),
(14, '2024-07-01', 'Absent'),
(15, '2024-07-01', 'Present');



CREATE TABLE DEV_DB.DEV_SCHEMA.PROJECTS (
    PROJECT_ID     NUMBER(10, 0) PRIMARY KEY,
    PROJECT_NAME   VARCHAR(100),
    DEPARTMENT     VARCHAR(50),
    START_DATE     DATE,
    END_DATE       DATE,
    BUDGET         NUMBER(12, 2)
);

INSERT INTO DEV_DB.DEV_SCHEMA.PROJECTS (PROJECT_ID, PROJECT_NAME, DEPARTMENT, START_DATE, END_DATE, BUDGET) VALUES
(101, 'Employee Portal Revamp', 'IT', '2024-01-15', '2024-06-30', 150000.00),
(102, 'Quarterly Audit', 'Finance', '2024-04-01', '2024-04-30', 30000.00),
(103, 'Onboarding Automation', 'HR', '2024-03-01', '2024-06-01', 75000.00),
(104, 'Cloud Migration', 'IT', '2024-05-01', '2024-10-01', 200000.00),
(105, 'Internal Branding', 'Marketing', '2024-02-15', '2024-07-31', 50000.00),
(106, 'Mobile App Launch', 'Product', '2024-01-01', '2024-05-01', 120000.00),
(107, 'Cost Optimization', 'Finance', '2024-06-01', '2024-12-31', 40000.00),
(108, 'Campus Hiring Drive', 'HR', '2024-07-01', '2024-09-15', 25000.00),
(109, 'SEO Improvements', 'Marketing', '2024-05-15', '2024-08-15', 15000.00),
(110, 'AI Chatbot Integration', 'Product', '2024-03-01', '2024-09-01', 110000.00),
(111, 'Vendor Portal Setup', 'Procurement', '2024-02-01', '2024-05-30', 30000.00),
(112, 'Sales Dashboard', 'Sales', '2024-04-01', '2024-07-01', 45000.00),
(113, 'Product Feedback Tool', 'Product', '2024-06-01', '2024-10-01', 80000.00),
(114, 'Performance Review System', 'HR', '2024-05-01', '2024-08-01', 60000.00),
(115, 'Digital Campaign Q3', 'Marketing', '2024-07-01', '2024-09-30', 70000.00);

