IF NOT EXISTS (
    SELECT * FROM sys.databases WHERE name = 'childcare'
)
    CREATE DATABASE childcare
GO

USE childcare
GO


--DOWN
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_clinics_clinic_clinic_id')
    ALTER TABLE CUSTOMERS DROP CONSTRAINT fk_clinics_clinic_clinic_id

DROP TABLE IF EXISTS appointments
DROP TABLE IF EXISTS fix_appointments
DROP TABLE IF EXISTS employees
DROP TABLE IF EXISTS clinic_contacts
DROP TABLE IF EXISTS clinics
DROP TABLE IF EXISTS state_lookup
-- UP METADATA

CREATE TABLE state_lookup
(
   state_id       INT IDENTITY (1, 1),
   state_name     VARCHAR (32),
   state_abbrev   CHAR (2),
   CONSTRAINT pk_state_lookup_state_id primary key (state_id)
)


CREATE TABLE clinics (
    clinic_id int IDENTITY NOT NULL,
    clinic_name varchar(50) NOT NULL,
    address_line_one varchar (200) NOT NULL,
    address_line_two varchar (200) NOT NULL,
    clinic_state int NOT NULL,
    clinic_city char(30) NOT NULL,
    clinic_zip int NOT NULL,
    CONSTRAINT pk_clinics_clinic_id PRIMARY KEY (clinic_id),
    CONSTRAINT u_clinics_clinic_name UNIQUE (clinic_name)
)
ALTER TABLE clinics
    ADD CONSTRAINT fk_clinics_clinic_state FOREIGN KEY (clinic_state)
        REFERENCES state_lookup (state_id)


CREATE TABLE clinic_contacts (
    clinic_id int IDENTITY NOT NULL,
    contact_no int NOT NULL,
    email varchar(50) NOT NULL,
    URL varchar (50) NULL,
    CONSTRAINT pk_clinic_contacts_clinic_id PRIMARY KEY (clinic_id)
)
ALTER TABLE clinic_contacts
    ADD CONSTRAINT fk_clinic_contacts_clinic_id FOREIGN KEY (clinic_id)
        REFERENCES clinics(clinic_id)

CREATE TABLE employees(
    employee_id int IDENTITY NOT NULL,
    emp_firstname varchar(255) NOT NULL,
    emp_lastname VARCHAR(255) NOT NULL,
    emp_title varchar(5) NOT NULL,
    employee_clinic_id INT NOT NULL,
    CONSTRAINT pk_employees_employee_id PRIMARY KEY (employee_id)
)
ALTER TABLE employees
    ADD CONSTRAINT fk_employees_employee_clinic_id FOREIGN KEY (employee_clinic_id)
        REFERENCES clinics (clinic_id)

CREATE TABLE appointments(
    appointment_id INT IDENTITY NOT NULL,
    appointment_type VARCHAR(255) NOT NULL,
    appointment_created_date DATETIME NOT NULL,
    appointment_patient_id INT NOT NULL,
    CONSTRAINT pk_appointments_appointment_id PRIMARY KEY (appointment_id)
)

CREATE TABLE fix_appointments(
    fix_appointment_id INT IDENTITY NOT NULL,
    fix_clinic_id INT NOT NULL,
    CONSTRAINT pk_fix_appointments_fix_appointment_id PRIMARY KEY (fix_appointment_id)
)
ALTER TABLE fix_appointments
    ADD CONSTRAINT fk_fix_appointments_fix_appointment_id FOREIGN KEY (fix_appointment_id)
        REFERENCES appointments(appointment_id)

ALTER TABLE fix_appointments
    ADD CONSTRAINT fk_fix_appointments_fix_clinic_id FOREIGN KEY (fix_clinic_id)
        REFERENCES clinics (clinic_id)


--UP DATA

INSERT INTO state_lookup
VALUES ('Alabama', 'AL'),
       ('Alaska', 'AK'),
       ('Arizona', 'AZ'),
       ('Arkansas', 'AR'),
       ('California', 'CA'),
       ('Colorado', 'CO'),
       ('Connecticut', 'CT'),
       ('Delaware', 'DE'),
       ('District of Columbia', 'DC'),
       ('Florida', 'FL'),
       ('Georgia', 'GA'),
       ('Hawaii', 'HI'),
       ('Idaho', 'ID'),
       ('Illinois', 'IL'),
       ('Indiana', 'IN'),
       ('Iowa', 'IA'),
       ('Kansas', 'KS'),
       ('Kentucky', 'KY'),
       ('Louisiana', 'LA'),
       ('Maine', 'ME'),
       ('Maryland', 'MD'),
       ('Massachusetts', 'MA'),
       ('Michigan', 'MI'),
       ('Minnesota', 'MN'),
       ('Mississippi', 'MS'),
       ('Missouri', 'MO'),
       ('Montana', 'MT'),
       ('Nebraska', 'NE'),
       ('Nevada', 'NV'),
       ('New Hampshire', 'NH'),
       ('New Jersey', 'NJ'),
       ('New Mexico', 'NM'),
       ('New York', 'NY'),
       ('North Carolina', 'NC'),
       ('North Dakota', 'ND'),
       ('Ohio', 'OH'),
       ('Oklahoma', 'OK'),
       ('Oregon', 'OR'),
       ('Pennsylvania', 'PA'),
       ('Rhode Island', 'RI'),
       ('South Carolina', 'SC'),
       ('South Dakota', 'SD'),
       ('Tennessee', 'TN'),
       ('Texas', 'TX'),
       ('Utah', 'UT'),
       ('Vermont', 'VT'),
       ('Virginia', 'VA'),
       ('Washington', 'WA'),
       ('West Virginia', 'WV'),
       ('Wisconsin', 'WI'),
       ('Wyoming', 'WY')

--VERIFY