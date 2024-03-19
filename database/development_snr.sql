-- Ultimpo cambio el 12/03/2024
-- Crea las tablas
CREATE TABLE persons(
    id serial primary key,
    identity_card integer NOT NULL UNIQUE,
    is_foreign boolean NOT NULL DEFAULT false,
    first_name varchar(40) NOT NULL,
    other_names varchar(160) DEFAULT '',
    first_last_name varchar(40) NOT NULL,
    other_last_names varchar(160) DEFAULT '',
    email varchar(200) DEFAULT '',
    phone varchar(20) DEFAULT '',
    gender_id integer NOT NULL DEFAULT 1
);

CREATE TABLE genders(
    id serial primary key,
    gender varchar NOT NULL UNIQUE
);

CREATE TABLE location(
    id serial primary key,
    person_id integer NOT NULL UNIQUE,
    state_id integer NOT NULL,
    municipality_id integer NOT NULL,
    parish_id integer NOT NULL,
    address text DEFAULT ''
);

CREATE TABLE states(
    id serial primary key,
    states varchar NOT NULL UNIQUE
);

CREATE TABLE municipalities(
    id serial primary key,
    state_id integer NOT NULL,
    municipality varchar NOT NULL UNIQUE
);

CREATE TABLE parishes(
    id serial primary key,
    municipality_id integer NOT NULL,
    parish varchar NOT NULL UNIQUE
);

ALTER TABLE persons ADD CONSTRAINT fk_gender_id FOREIGN KEY (gender_id) references genders(id);

ALTER TABLE location ADD CONSTRAINT fk_person_id FOREIGN KEY (person_id) references persons(id);
ALTER TABLE location ADD CONSTRAINT fk_state_id FOREIGN KEY (state_id) references states(id);
ALTER TABLE location ADD CONSTRAINT fk_municipality_id FOREIGN KEY (municipality_id) references municipalities(id);
ALTER TABLE location ADD CONSTRAINT fk_parish_id FOREIGN KEY (parish_id) references parishes(id);

ALTER TABLE municipalities ADD CONSTRAINT fk_state_id FOREIGN KEY (state_id) references states(id);

ALTER TABLE parishes ADD CONSTRAINT fk_municipality_id FOREIGN KEY (municipality_id) references municipalities(id);

-- Crea un esquema
CREATE SCHEMA auth;

CREATE TABLE auth.users(
    id serial primary key,
    username varchar(100) NOT NULL UNIQUE,
    password varchar NOT NULL,
    person_id integer NOT NULL UNIQUE,
    role_id integer NOT NULL,
    department_id integer NOT NULL,
    is_active boolean NOT NULL DEFAULT true
);

CREATE TABLE auth.roles(
    id serial primary key,
    role varchar NOT NULL UNIQUE
);

CREATE TABLE auth.departments(
    id serial primary key,
    department varchar NOT NULL UNIQUE
);

ALTER TABLE auth.users ADD CONSTRAINT fk_person_id FOREIGN KEY (person_id) references persons(id);
ALTER TABLE auth.users ADD CONSTRAINT fk_rol_id FOREIGN KEY (role_id) references auth.roles(id);
ALTER TABLE auth.users ADD CONSTRAINT fk_department_id FOREIGN KEY (department_id) references auth.departments(id);

CREATE VIEW view_user_data AS SELECT u.id, u.username, u.password, r.role, d.department, u.is_active  FROM auth.users AS u
INNER JOIN auth.roles AS r ON r.id = u.role_id
INNER JOIN auth.departments AS d ON d.id = u.department_id;

CREATE VIEW view_user_profile AS SELECT u.id, u.username, u.is_active, p.identity_card, p.is_foreign, p.first_name, p.other_names, p.first_last_name, p.other_last_names, p.email, p.phone, g.gender, r.role, d.department
FROM auth.users AS u
INNER JOIN persons AS p ON p.id = u.person_id
INNER JOIN genders AS g ON g.id = p.gender_id
INNER JOIN auth.roles AS r ON r.id = u.role_id
INNER JOIN auth.departments AS d ON d.id = u.department_id

-- Inserta datos de pruebas
INSERT INTO genders (id,gender) VALUES (1,'Mujer'), (2,'Hombre'), (3,'Otro');
INSERT INTO auth.roles (id,role) VALUES (1,'Administradora'),(2,'Directora'),(3,'Analista'),(4,'Usuaria');
INSERT INTO auth.departments (id,department) VALUES (1,'0800'),(2,'OSTI'),(3,'OAC'),(4,'SIN');
INSERT INTO persons (id,identity_card,first_name,first_last_name,gender_id) VALUES (1,28076011,'Nicolas','Zapata',2);
INSERT INTO auth.users (id,username,password,person_id,role_id,department_id) VALUES (1,'nicoadmin','$2a$10$iTHAxSj1ooB.J1vCPQEnCel21TUE5qimteBFg6HtL0nDwQ5IWC6Ze',1,1,2);
-- password = 123456