# database_design_Tech_ABC
Database Architecture &amp; Design

# Tech ABC Corp Employee Management Database


## Project Overview

Tech ABC Corp saw explosive growth with the sudden appearance onto the gaming scene with their new AI-powered video game console. As a result, the company expanded from a small 10-person operation to 200 employees and 5 locations in under a year. This rapid growth has made it increasingly cumbersome for HR to manage employee information using a spreadsheet.

This project involves designing and building a robust database to manage employee information efficiently and securely. The new database will improve data integrity, ensure compliance with data retention regulations, and support future integrations with other departmental systems.

## Database Objects

### Tables

1. **Employee**: Stores employee information (ID, name, email, education level).
2. **Manager**: Stores manager information (ID, name).
3. **Department**: Stores department information (ID, name).
4. **Job**: Stores job information (ID, employee ID, job title, hire date, start date, end date, address ID, location ID, department ID, manager ID).
5. **Salary**: Stores salary information (ID, amount, job ID).
6. **Location**: Stores location information (ID, name).
7. **State**: Stores state information (ID, name).
8. **City**: Stores city information (ID, name, state ID).
9. **Address**: Stores address information (ID, name, city ID).

### Views

- **decrypted_salary**: View for displaying decrypted salary data (ID, job ID, amount).

### Functions

- **GetEmployeeJobs**: Returns current and past jobs for a given employee name (parameters: employee name; returns: employee name, job title, department, manager name, start date, end date).

## Features

- **User Access and Security**: Different levels of access for HR, management, and general employees.
- **Data Maintenance and Integrity**: Real-time input and editing of information, with secure handling of sensitive data.
- **Data Retention and Backup**: Compliance with federal regulations and business-critical data backup strategies.
- **Future Integration**: Designed to interface with the payroll department's system for future enhancements.

## Getting Started

### Prerequisites

- PostgreSQL or compatible database system
- SQL client (e.g., pgAdmin, DBeaver)


