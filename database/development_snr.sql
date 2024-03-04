-- Crea las tablas
CREATE TABLE persons(
    id serial primary key,
    identity_card integer not null UNIQUE,
    is_foreign boolean not null,
    first_name varchar(40) not null,
    other_names varchar(160),
    first_last_name varchar(40),
    other_last_names varchar(160),
    email varchar(200),
    phone varchar(20),
    gender_id integer not null
);

CREATE TABLE genders(
    id serial primary key,
    gender varchar not null UNIQUE
);

CREATE TABLE location(
    id serial primary key,
    person_id integer not null UNIQUE,
    state_id integer not null,
    municipality_id integer not null,
    parish_id integer not null,
    address text
);

CREATE TABLE states(
    id serial primary key,
    states varchar not null UNIQUE
);

CREATE TABLE municipalities(
    id serial primary key,
    state_id integer not null,
    municipality varchar not null UNIQUE
);

CREATE TABLE parishes(
    id serial primary key,
    municipality_id integer not null,
    parish varchar not null UNIQUE
);

alter table persons add constraint fk_gender_id foreign key (gender_id) references genders(id);

alter table location add constraint fk_person_id foreign key (person_id) references persons(id);
alter table location add constraint fk_state_id foreign key (state_id) references states(id);
alter table location add constraint fk_municipality_id foreign key (municipality_id) references municipalities(id);
alter table location add constraint fk_parish_id foreign key (parish_id) references parishes(id);

alter table municipalities add constraint fk_state_id foreign key (state_id) references states(id);

alter table parishes add constraint fk_municipality_id foreign key (municipality_id) references municipalities(id);

-- Crea un esquema
CREATE SCHEMA auth;

CREATE TABLE auth.users(
    id serial primary key,
    username varchar(100) not null UNIQUE,
    password varchar not null,
    person_id integer not null UNIQUE,
    rol_id integer not null,
    department_id integer not null,
    is_active boolean not null
);

CREATE TABLE auth.roles(
    id serial primary key,
    role varchar not null UNIQUE
);

CREATE TABLE auth.department(
    id serial primary key,
    department varchar not null UNIQUE
);

alter table auth.users add constraint fk_person_id foreign key (person_id) references persons(id);
alter table auth.users add constraint fk_rol_id foreign key (rol_id) references auth.roles(id);
alter table auth.users add constraint fk_department_id foreign key (department_id) references auth.department(id);

-- Inserta datos de pruebas
INSERT INTO genders (id,gender) VALUES (1,'Mujer'), (2,'Hombre'), (3,'Otro');
INSERT INTO auth.roles (id,role) VALUES (1,'Administradora'),(2,'Operadora');
INSERT INTO auth.department (id,department) VALUES (1,'0800'),(2,'Informática');
INSERT INTO persons (identity_card, is_foreign, first_name, first_last_name, gender_id) VALUES (28076011, false, 'Nicolas','Zapata', 2);
INSERT INTO auth.users (username,password,is_active,person_id,rol_id,department_id) VALUES ('nicoadmin','12345678',true,1,1,2);