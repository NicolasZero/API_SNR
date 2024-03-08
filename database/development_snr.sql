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
    rol_id integer NOT NULL,
    department_id integer NOT NULL,
    is_active boolean NOT NULL DEFAULT true
);

CREATE TABLE auth.roles(
    id serial primary key,
    role varchar NOT NULL UNIQUE
);

CREATE TABLE auth.department(
    id serial primary key,
    department varchar NOT NULL UNIQUE
);

ALTER TABLE auth.users ADD CONSTRAINT fk_person_id FOREIGN KEY (person_id) references persons(id);
ALTER TABLE auth.users ADD CONSTRAINT fk_rol_id FOREIGN KEY (rol_id) references auth.roles(id);
ALTER TABLE auth.users ADD CONSTRAINT fk_department_id FOREIGN KEY (department_id) references auth.department(id);

-- Inserta datos de pruebas
INSERT INTO genders (id,gender) VALUES (1,'Mujer'), (2,'Hombre'), (3,'Otro');
INSERT INTO auth.roles (id,role) VALUES (1,'Administradora'),(2,'Operadora');
INSERT INTO auth.department (id,department) VALUES (1,'0800'),(2,'Informática');
INSERT INTO persons (id,identity_card,first_name,first_last_name,gender_id) VALUES (1,28076011,'Nicolas','Zapata',2);
INSERT INTO auth.users (id,username,password,person_id,rol_id,department_id) VALUES (1,'nicoadmin','$2a$10$iTHAxSj1ooB.J1vCPQEnCel21TUE5qimteBFg6HtL0nDwQ5IWC6Ze',1,1,2);
-- password = 123456