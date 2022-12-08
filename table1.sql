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

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_clinics_clinic_state')
        ALTER TABLE clinics DROP CONSTRAINT fk_clinics_clinic_state

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_employees_employee_clinic_id')
        ALTER TABLE employees DROP CONSTRAINT fk_employees_employee_clinic_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_appointments_appointment_patient_id')
        ALTER TABLE appointments DROP CONSTRAINT fk_appointments_appointment_patient_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_fix_appointments_fix_appointment_id')
        ALTER TABLE fix_appointments DROP CONSTRAINT fk_fix_appointments_fix_appointment_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_fix_appointments_fix_clinic_id')
        ALTER TABLE fix_appointments DROP CONSTRAINT fk_fix_appointments_fix_clinic_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_treatments_treatment_appointment_id')
        ALTER TABLE treatments DROP CONSTRAINT fk_treatments_treatment_appointment_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_vaccines_vaccine_patient_id')
        ALTER TABLE vaccines DROP CONSTRAINT fk_vaccines_vaccine_patient_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_patients_patient_doctor_id')
        ALTER TABLE patients DROP CONSTRAINT fk_patients_patient_doctor_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_patient_family_patient_id')
        ALTER TABLE patient_family DROP CONSTRAINT fk_patient_family_patient_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_emergency_contacts_patient_id')
        ALTER TABLE emergency_contacts DROP CONSTRAINT fk_emergency_contacts_patient_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_lab_patient_id')
        ALTER TABLE lab DROP CONSTRAINT fk_lab_patient_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_bills_patient_id')
        ALTER TABLE bills DROP CONSTRAINT fk_bills_patient_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_insurance_patient_id')
        ALTER TABLE insurance DROP CONSTRAINT fk_insurance_patient_id

DROP TABLE IF EXISTS pharmacy
DROP TABLE IF EXISTS test_price
DROP TABLE IF EXISTS insurance_covers
DROP TABLE IF EXISTS insurance
DROP TABLE IF EXISTS bills
DROP TABLE IF EXISTS lab
DROP TABLE IF EXISTS emergency_contacts
DROP TABLE IF EXISTS patient_family
DROP TABLE IF EXISTS vaccines
DROP TABLE IF EXISTS patients
DROP TABLE IF EXISTS treatments
DROP TABLE IF EXISTS doctors
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

CREATE TABLE doctors(
    doctor_id INT IDENTITY NOT NULL,
    doctor_license_no INT NOT NULL,
    doctor_firstname VARCHAR(255),
    doctor_lastname VARCHAR(255),
    doctor_email VARCHAR(255),
    doctor_contact_no INT NOT NULL,
    doctor_experience INT NULL
    CONSTRAINT pk_doctors_doctor_id PRIMARY KEY (doctor_id)
)


CREATE TABLE patients(
    patient_id INT IDENTITY NOT NULL,
    patient_firstname VARCHAR(255) NOT NULL,
    patient_lastname VARCHAR(255) NOT NULL,
    patient_nationality VARCHAR(255) NULL,
    patient_gender VARCHAR(255) NOT NULL,
    patient_dob DATETIME NOT NULL,
    patient_age INT NOT NULL,
    patient_address_line_1 VARCHAR(255) NOT NULL,
    patient_address_line_2 VARCHAR(255) NULL,
    patient_city VARCHAR(255) NOT NULL,
    patient_state INT NOT NULL,
    patient_zipcode INT NOT NULL,
    patient_existing_medical_conditions_1 VARCHAR(255) NULL,
    patient_existing_medical_conditions_2 VARCHAR(255) NULL,
    patient_allergy VARCHAR(255) NULL,
    patient_doctor_id INT NOT NULL

    CONSTRAINT pk_patients_patient_id PRIMARY KEY (patient_id)
)
ALTER TABLE patients
    ADD CONSTRAINT fk_patients_patient_doctor_id FOREIGN KEY (patient_doctor_id)
        REFERENCES doctors(doctor_id)


CREATE TABLE appointments(
    appointment_id INT IDENTITY NOT NULL,
    appointment_type VARCHAR(255) NOT NULL,
    appointment_created_date DATETIME NOT NULL,
    appointment_patient_id INT NOT NULL,
    CONSTRAINT pk_appointments_appointment_id PRIMARY KEY (appointment_id)
)
ALTER TABLE appointments
    ADD CONSTRAINT fk_appointments_appointment_patient_id FOREIGN KEY (appointment_patient_id)
        REFERENCES patients(patient_id)


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


CREATE TABLE treatments(
    treatment_appointment_id INT NOT NULL,
    treatment_doctor_id INT NOT NULL,
    CONSTRAINT pk_treatments_treatment_appointment_id PRIMARY KEY (treatment_appointment_id)
)
ALTER TABLE treatments
    ADD CONSTRAINT fk_treatments_treatment_appointment_id FOREIGN KEY (treatment_appointment_id)
        REFERENCES appointments(appointment_id)

CREATE TABLE vaccines(
    vaccine_patient_id INT IDENTITY NOT NULL,
    vaccine_id INT NOT NULL,
    vaccine_name VARCHAR(255) NOT NULL,
    vaccine_patient_status BIT NULL,
    vaccine_date DATETIME NULL,
    vaccine_due_date DATETIME NULL
    CONSTRAINT pk_vaccines_vaccine_patient_id PRIMARY KEY (vaccine_id)
)
ALTER TABLE vaccines
    ADD CONSTRAINT fk_vaccines_vaccine_patient_id FOREIGN KEY (vaccine_patient_id)
        REFERENCES patients(patient_id)


CREATE TABLE patient_family(
    patient_id INT IDENTITY NOT NULL,
    patient_father_firstname VARCHAR(255) NOT NULL,
    patient_father_lastname VARCHAR(255) NOT NULL,
    patient_mother_firstname VARCHAR(255) NOT NULL,
    patient_mother_lastname VARCHAR(255) NOT NULL,
    patient_father_contact_no INT NOT NULL,
    patient_mother_contact_no INT NOT NULL,
    patient_mother_medical_conditions VARCHAR(255) NULL,
    patient_father_medical_conditions VARCHAR(255) NULL,
)
ALTER TABLE patient_family
    ADD CONSTRAINT fk_patient_family_patient_id FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)

CREATE TABLE emergency_contacts(
    patient_id INT IDENTITY NOT NULL,
    emergency_contact_firstname VARCHAR(255) NOT NULL,
    emergency_contact_lastname VARCHAR(255) NOT NULL,
    emergency_contact_address VARCHAR(255) NOT NULL,
    emergency_contact_email VARCHAR(255) NOT NULL,
    CONSTRAINT pk_emergency_contacts_patient_id PRIMARY KEY (patient_id)
)
ALTER TABLE emergency_contacts
    ADD CONSTRAINT fk_emergency_contacts_patient_id FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)


CREATE TABLE lab(
    lab_no INT IDENTITY NOT NULL,
    lab_patient_id INT NOT NULL,
    lab_test_type VARCHAR NOT NULL,
    lab_test_code INT NOT NULL,
    lab_patient_weight INT NOT NULL,
    lab_patient_height INT NOT NULL,
    lab_blood_pressure INT NOT NULL,
    lab_tempreture INT NOT NULL,
    lab_date DATETIME,
    lab_test_result BIT
    CONSTRAINT pk_lab_lab_no PRIMARY KEY (lab_no)
)
ALTER TABLE lab
    ADD CONSTRAINT fk_lab_patient_id FOREIGN KEY (lab_patient_id)
        REFERENCES patients(patient_id)


CREATE TABLE bills(
    bill_no INT IDENTITY NOT NULL,
    patient_id INT NOT NULL,
    bill_doctor_charge INT NOT NULL,
    bill_lab_charge INT NOT NULL,
    bill_insurance_code INT NOT NULL,
    bill_total_bill INT NOT NULL,
    CONSTRAINT pk_bills_bill_no PRIMARY KEY (bill_no)
)
ALTER TABLE bills
    ADD CONSTRAINT fk_bills_patient_id FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)

CREATE TABLE insurance(
    insurance_patient_id INT IDENTITY NOT NULL,
    insurance_policy_no INT NOT NULL,
    insurance_code INT NOT NULL,
    insurance_publish_date DATETIME NOT NULL,
    insurance_expiry_date DATETIME NOT NULL
    CONSTRAINT pk_insurance_medicine_id PRIMARY KEY (insurance_medicine_id)
)
ALTER TABLE insurance
    ADD CONSTRAINT fk_insurance_patient_id FOREIGN KEY (insurance_patient_id)
        REFERENCES patients(patient_id)



CREATE TABLE insurance_covers(
    insurance_cover_code INT IDENTITY NOT NULL,
    insurance_cover_company VARCHAR(255) NOT NULL,
    insurance_cover_entry_fee INT NOT NULL,
    insurance_cover_co_pay VARCHAR(255) NOT NULL,
    CONSTRAINT pk_insurance_covers_insurance_cover PRIMARY KEY (insurance_cover)
)


CREATE TABLE test_price(
    test_code INT IDENTITY NOT NULL,
    test_price INT NULL
    CONSTRAINT pk_test_price_test_code PRIMARY KEY (test_code)
)

CREATE TABLE pharmacy(
    pharmacy_name VARCHAR NOT NULL,
    pharmacy_address VARCHAR(255) NOT NULL,
    pharmacy_city VARCHAR(255) NOT NULL,
    pharmacy_zip INT NOT NULL,
    pharmacy_contact_no INT NOT NULL,
    pharmacy_tax_number INT NULL
)
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
