CREATE DATABASE test;
CREATE DATABASE development;

\c development;

CREATE TABLE patients ( id SERIAL PRIMARY KEY,
                        cpf VARCHAR(20) NOT NULL UNIQUE,
                        name VARCHAR(100) NOT NULL,
                        email VARCHAR(100) NOT NULL,
                        birthdate DATE NOT NULL,
                        address VARCHAR(100) NOT NULL,
                        city VARCHAR(100) NOT NULL,
                        state VARCHAR(20) NOT NULL
                     );

CREATE TABLE doctors ( id SERIAL PRIMARY KEY,
                       crm VARCHAR(10) NOT NULL,
                       crm_state VARCHAR(20) NOT NULL,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) NOT NULL,
                       CONSTRAINT unique_crm_in_state UNIQUE (crm, crm_state)
                     );

CREATE TABLE exams ( id SERIAL PRIMARY KEY,
                     token VARCHAR(100) NOT NULL UNIQUE,
                     date DATE NOT NULL,
                     patient_id INT NOT NULL,
                     doctor_id INT NOT NULL,
                     FOREIGN KEY (patient_id) REFERENCES patients(id),
                     FOREIGN KEY (doctor_id) REFERENCES doctors(id)
                     );

CREATE TABLE tests ( id SERIAL PRIMARY KEY,
                     type VARCHAR(100) NOT NULL,
                     limits VARCHAR(100) NOT NULL,
                     result VARCHAR(100) NOT NULL,
                     exam_id INT NOT NULL,
                     FOREIGN KEY (exam_id) REFERENCES exams(id)
                     );

\c test;

CREATE TABLE patients ( id SERIAL PRIMARY KEY,
                        cpf VARCHAR(20) NOT NULL UNIQUE,
                        name VARCHAR(100) NOT NULL,
                        email VARCHAR(100) NOT NULL,
                        birthdate DATE NOT NULL,
                        address VARCHAR(100) NOT NULL,
                        city VARCHAR(100) NOT NULL,
                        state VARCHAR(20) NOT NULL
                     );

CREATE TABLE doctors ( id SERIAL PRIMARY KEY,
                       crm VARCHAR(10) NOT NULL,
                       crm_state VARCHAR(20) NOT NULL,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) NOT NULL,
                       CONSTRAINT unique_crm_in_state UNIQUE (crm, crm_state)
                     );

CREATE TABLE exams ( id SERIAL PRIMARY KEY,
                     token VARCHAR(100) NOT NULL UNIQUE,
                     date DATE NOT NULL,
                     patient_id INT NOT NULL,
                     doctor_id INT NOT NULL,
                     FOREIGN KEY (patient_id) REFERENCES patients(id),
                     FOREIGN KEY (doctor_id) REFERENCES doctors(id)
                     );

CREATE TABLE tests ( id SERIAL PRIMARY KEY,
                     type VARCHAR(100) NOT NULL,
                     limits VARCHAR(100) NOT NULL,
                     result VARCHAR(100) NOT NULL,
                     exam_id INT NOT NULL,
                     FOREIGN KEY (exam_id) REFERENCES exams(id)
                     );



\q