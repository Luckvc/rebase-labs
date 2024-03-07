CREATE DATABASE test;
CREATE DATABASE development;

\c development;

CREATE TABLE tests ( id SERIAL PRIMARY KEY,
                     patient_cpf VARCHAR(20) NOT NULL,
                     patient_name VARCHAR(100) NOT NULL,
                     patient_email VARCHAR(100) NOT NULL,
                     patient_birthdate DATE NOT NULL,
                     patient_address VARCHAR(100) NOT NULL,
                     patient_city VARCHAR(100) NOT NULL,
                     patient_state VARCHAR(20) NOT NULL,
                     doctor_crm VARCHAR(10) NOT NULL,
                     doctor_crm_state VARCHAR(20) NOT NULL,
                     doctor_name VARCHAR(100) NOT NULL,
                     doctor_email VARCHAR(100) NOT NULL,
                     exam_token VARCHAR(100) NOT NULL,
                     exam_date DATE NOT NULL,
                     exam_type VARCHAR(100) NOT NULL,
                     exam_limits VARCHAR(100) NOT NULL,
                     exam_result VARCHAR(100) NOT NULL
                     );

\c test;

CREATE TABLE tests ( id SERIAL PRIMARY KEY,
                     patient_cpf VARCHAR(20) NOT NULL,
                     patient_name VARCHAR(100) NOT NULL,
                     patient_email VARCHAR(100) NOT NULL,
                     patient_birthdate DATE NOT NULL,
                     patient_address VARCHAR(100) NOT NULL,
                     patient_city VARCHAR(100) NOT NULL,
                     patient_state VARCHAR(20) NOT NULL,
                     doctor_crm VARCHAR(10) NOT NULL,
                     doctor_crm_state VARCHAR(20) NOT NULL,
                     doctor_name VARCHAR(100) NOT NULL,
                     doctor_email VARCHAR(100) NOT NULL,
                     exam_token VARCHAR(100) NOT NULL,
                     exam_date DATE NOT NULL,
                     exam_type VARCHAR(100) NOT NULL,
                     exam_limits VARCHAR(100) NOT NULL,
                     exam_result VARCHAR(100) NOT NULL
                     );

\q