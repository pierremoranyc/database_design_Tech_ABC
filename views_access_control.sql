CREATE VIEW EmployeeFullView AS
SELECT 
    e.emp_ID,
    e.emp_name AS Emp_NM,
    e.email,
    j.hire_date,
    j.job_title,
    s.salary_amount AS salary,
    d.dep_name AS department_nm,
    m.manag_name AS manager,
    j.start_date,
    j.end_date,
    l.location_name AS location,
    a.address_name AS address,
    c.city_name AS city,
    st.state_name AS state,
    e.edu_level AS education_lvl
FROM 
    Employee e
JOIN Job j ON e.emp_ID = j.emp_ID
JOIN Department d ON j.dep_ID = d.dep_ID
JOIN Manager m ON j.manag_ID = m.manag_ID
JOIN Salary s ON j.job_ID = s.job_ID
JOIN Location l ON j.location_ID = l.location_ID
JOIN Address a ON j.address_ID = a.address_ID
JOIN City c ON a.city_ID = c.city_ID
JOIN State st ON c.state_ID = st.state_ID;


CREATE OR REPLACE FUNCTION GetEmployeeJobs (
    emp_name_param VARCHAR(100)
)
RETURNS TABLE (
    EmployeeName VARCHAR(100),
    JobTitle VARCHAR(100),
    Department VARCHAR(100),
    ManagerName VARCHAR(100),
    StartDate DATE,
    EndDate DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.emp_name AS EmployeeName,
        j.job_title AS JobTitle,
        d.dep_name AS Department,
        m.manag_name AS ManagerName,
        j.start_date AS StartDate,
        j.end_date AS EndDate
    FROM 
        Employee e
    JOIN 
        Job j ON e.emp_ID = j.emp_ID
    JOIN 
        Department d ON j.dep_ID = d.dep_ID
    LEFT JOIN 
        Manager m ON j.manag_ID = m.manag_ID
    WHERE 
        e.emp_name = emp_name_param;
END;
$$;


-- Creating the NoMgr user (non-management)
CREATE USER NoMgr WITH PASSWORD 'securepassword';

-- Creating the Mgr user (management)
CREATE USER Mgr WITH PASSWORD 'securepassword';

-- Grant access to connect to the database
GRANT CONNECT ON DATABASE HR_database TO NoMgr, Mgr;

-- Allow these users to use the public schema (where our tables are)
GRANT USAGE ON SCHEMA public TO NoMgr, Mgr;

-- Step 1: Create Users
CREATE USER NoMgr WITH PASSWORD 'securepassword';  -- Creates a non-management user
CREATE USER Mgr WITH PASSWORD 'securepassword';    -- Creates a management user

-- Step 2: Grant Access to Database
GRANT CONNECT ON DATABASE hr_database TO NoMgr, Mgr;  -- Allows users to connect to the hr_database
GRANT USAGE ON SCHEMA public TO NoMgr, Mgr;          -- Allows users to use the public schema

-- Step 3: Grant and Revoke Table Permissions
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename != 'Salary')
    LOOP
        EXECUTE 'GRANT SELECT ON TABLE public.' || r.tablename || ' TO NoMgr';  -- Grant read access to each table except Salary
    END LOOP;
END $$;

REVOKE SELECT ON TABLE Salary FROM NoMgr;  -- Make sure NoMgr cannot read the Salary table

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO Mgr;  -- Grant full access to Mgr




