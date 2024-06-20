CREATE TABLE Employee(
    emp_ID varchar(10) PRIMARY KEY,
    emp_name varchar(100),
    email varchar(100),
    edu_level varchar(50)
);

CREATE TABLE Manager(
    manag_ID varchar(10) PRIMARY KEY,
    manag_name varchar(100)
);

CREATE TABLE Department(
    dep_ID SERIAL PRIMARY KEY,
    dep_name varchar(100));
    
CREATE TABLE Job(
    job_ID SERIAL PRIMARY KEY,
    emp_ID varchar(10),
    job_title varchar(100),
    hire_date date,
    start_date date,
    end_date date,
    address_ID int,
    location_ID int,
    dep_ID int,
    manag_ID varchar(10)
);

CREATE TABLE Salary(
    salary_ID SERIAL PRIMARY KEY,
    salary_amount decimal(10,2),
    job_ID int,
    FOREIGN KEY (job_ID) REFERENCES Job(job_ID)
);

CREATE TABLE Location(
    location_ID SERIAL PRIMARY KEY,
    location_name varchar(100)
);

CREATE TABLE State(
    state_ID SERIAL PRIMARY KEY,
    state_name varchar(100)
);

CREATE TABLE City(
    city_ID SERIAL PRIMARY KEY,
    city_name varchar(100),
    state_ID int,
    FOREIGN KEY (state_ID) REFERENCES State(state_ID)
);

CREATE TABLE Address(
    address_ID SERIAL PRIMARY KEY,
    address_name varchar(100),
    city_ID int,
    FOREIGN KEY (city_ID) REFERENCES City(city_ID)
);

ALTER TABLE Job
ADD CONSTRAINT fk_address
FOREIGN KEY (address_ID) REFERENCES Address(address_ID);

ALTER TABLE Job
ADD CONSTRAINT fk_location
FOREIGN KEY (location_ID) REFERENCES Location(location_ID);

ALTER TABLE Job
ADD CONSTRAINT fk_department
FOREIGN KEY (dep_ID) REFERENCES Department(dep_ID);

INSERT INTO Employee (emp_ID, emp_name, email, edu_level)
SELECT DISTINCT Emp_ID, Emp_NM, Email, education_lvl
FROM proj_stg;

CREATE TEMP TABLE temp_managers AS
SELECT DISTINCT manager
FROM proj_stg
WHERE manager IS NOT NULL;

INSERT INTO Manager(manag_ID,manag_name)
SELECT DISTINCT p.emp_ID, p.Emp_NM
FROM proj_stg AS p
JOIN temp_managers AS t
ON p.Emp_NM = t.manager;

INSERT INTO Department (dep_name)
SELECT DISTINCT department_nm
FROM proj_stg;

INSERT INTO Location(location_name)
SELECT DISTINCT location
FROM proj_stg;

INSERT INTO State(state_name)
SELECT DISTINCT state
FROM proj_stg;

INSERT INTO City(city_name, state_ID)
SELECT DISTINCT st.city, s.state_ID
FROM proj_stg AS st
JOIN State AS s ON st.state = s.state_name;

INSERT INTO Address(address_name, city_ID)
SELECT DISTINCT st.address, c.city_ID
FROM proj_stg AS st
JOIN City AS c ON st.city = c.city_name;

INSERT INTO Job (emp_ID, job_title, hire_date, start_date, end_date, address_ID, location_ID, dep_ID)
SELECT DISTINCT 
    st.Emp_ID,
    st.job_title,
    st.hire_dt,
    st.start_dt,
    st.end_dt,
    a.address_ID,
    l.location_ID,
    d.dep_ID
FROM proj_stg AS st
JOIN Address AS a ON st.address = a.address_name
JOIN Location AS l ON st.location = l.location_name
JOIN Department AS d ON st.department_nm = d.dep_name;

UPDATE Job
SET manag_ID = m.manag_ID
FROM proj_stg AS st
JOIN Manager AS m ON st.manager = m.manag_name
WHERE Job.emp_ID = st.Emp_ID
AND Job.job_title = st.job_title
AND Job.start_date = st.start_dt;

-- Inserting data into Salary table
INSERT INTO Salary(salary_amount, job_ID)
SELECT DISTINCT st.salary, j.job_ID
FROM proj_stg AS st
JOIN Job AS j ON st.Emp_ID = j.emp_ID AND st.job_title = j.job_title AND st.start_dt = j.start_date;

SELECT e.emp_name, 
       j.job_title, 
       d.dep_name
FROM Employee AS e
JOIN Job AS j ON e.emp_ID = j.emp_ID
JOIN Department AS d ON j.dep_ID = d.dep_ID;

INSERT INTO Job (job_title)
VALUES ('Web Programmer');

UPDATE Job
SET job_title = 'Web Developer'
WHERE job_title = 'Web Programmer';

DELETE FROM Job
WHERE job_title = 'Web Developer';

SELECT COUNT(DISTINCT j.emp_ID) AS employee_count,
       d.dep_name
FROM Job AS j
JOIN Department AS d ON j.dep_ID = d.dep_ID
GROUP BY d.dep_name;

SELECT j.job_ID,e.emp_name,j.job_title,d.dep_name,m.manag_name,j.start_date,j.end_date
FROM Job AS j
JOIN Employee AS e
ON j.emp_ID = E.emp_ID
JOIN Department AS d
ON j.dep_ID = d.dep_ID
JOIN Manager AS m
ON j.manag_id = m.manag_ID
WHERE e.emp_name = 'Toni Lembeck';

