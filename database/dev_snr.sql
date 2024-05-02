-- Ultimpo cambio el 02/05/2024
-- Crea las tablas
CREATE TABLE persons(
    --id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1),
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
    --id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1),
    gender varchar NOT NULL UNIQUE
);

CREATE TABLE location(
    --id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1),
    person_id integer NOT NULL UNIQUE,
    state_id integer NOT NULL,
    municipality_id integer NOT NULL,
    parish_id integer NOT NULL,
    address text DEFAULT ''
);

CREATE TABLE states(
    --id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1 MAXVALUE 24),
    state varchar NOT NULL
);

CREATE TABLE municipalities(
    -- id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1 MAXVALUE 335),
    state_id integer NOT NULL,
    municipality varchar NOT NULL
);

CREATE TABLE parishes(
    -- id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1 MAXVALUE 1134),
    municipality_id integer NOT NULL,
    parish varchar NOT NULL
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
    -- id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1),
    username varchar(100) NOT NULL UNIQUE,
    password varchar NOT NULL,
    person_id integer NOT NULL UNIQUE,
    role_id integer NOT NULL,
    department_id integer NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    created date DEFAULT CURRENT_DATE,
    updated date DEFAULT CURRENT_DATE
);

CREATE TABLE auth.roles(
    -- id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1),
    role varchar NOT NULL UNIQUE
);

CREATE TABLE auth.departments(
    -- id serial primary key,
    id integer NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1),
    department varchar NOT NULL UNIQUE
);

ALTER TABLE auth.users ADD CONSTRAINT fk_person_id FOREIGN KEY (person_id) references persons(id);
ALTER TABLE auth.users ADD CONSTRAINT fk_rol_id FOREIGN KEY (role_id) references auth.roles(id);
ALTER TABLE auth.users ADD CONSTRAINT fk_department_id FOREIGN KEY (department_id) references auth.departments(id);

-- Vista para uso interno del sistema
CREATE VIEW view_user_data AS SELECT u.id, u.username, u.password, r.role, d.department, u.is_active  FROM auth.users AS u
LEFT JOIN auth.roles AS r ON r.id = u.role_id
LEFT JOIN auth.departments AS d ON d.id = u.department_id;

--Vista para uso público
CREATE VIEW view_user_profile AS SELECT u.id, u.username, u.is_active, p.identity_card, p.is_foreign, p.first_name, p.other_names, p.first_last_name, p.other_last_names, p.email, p.phone, p.gender_id, g.gender, u.role_id, r.role, u.department_id, d.department, l.state_id, l.state, l.municipality_id, l.municipality, l.parish_id, l.parish, l.address FROM auth.users AS u
LEFT JOIN persons AS p ON p.id = u.person_id
LEFT JOIN genders AS g ON g.id = p.gender_id
LEFT JOIN auth.roles AS r ON r.id = u.role_id
LEFT JOIN auth.departments AS d ON d.id = u.department_id
LEFT JOIN view_person_location AS l ON p.id = l.person_id;

CREATE VIEW view_person_location AS SELECT l.person_id, l.state_id, s.state, l.municipality_id, m.municipality, l.parish_id, p.parish, l.address FROM location AS l
LEFT JOIN states AS s ON l.state_id = s.id
LEFT JOIN municipalities AS m ON l.municipality_id = m.id 
LEFT JOIN parishes AS p ON l.parish_id = p.id;



--Insertar Datos obligatorios
INSERT INTO genders (gender) VALUES ('Mujer'),('Hombre'),('Otro');
INSERT INTO auth.roles (role) VALUES ('Administradora'),('Directora'),('Analista'),('Usuaria');
INSERT INTO auth.departments (department) VALUES ('0800'),('OSTI'),('OAC'),('SIN');

INSERT INTO states (state) VALUES ('CARACAS'),('ANZOATEGUI'),('APURE'),('ARAGUA'),('BARINAS'),('BOLIVAR'),('CARABOBO'),('COJEDES'),('FALCON'),('GUARICO'),('LARA'),('MERIDA'),('MIRANDA'),('MONAGAS'),('NUEVA ESPARTA'),('PORTUGUESA'),('SUCRE'),('TACHIRA'),('TRUJILLO'),('YARACUY'),('ZULIA'),('AMAZONAS'),('DELTA AMACURO'),('VARGAS');

INSERT INTO municipalities (municipality, state_id) VALUES ('LIBERTADOR',1),('ANACO',2),('ARAGUA',2),('BOLIVAR',2),('BRUZUAL',2),('CAJIGAL',2),('FREITES',2),('INDEPENDENCIA',2),('LIBERTAD',2),('MIRANDA',2),('MONAGAS',2),('PEÑALVER',2),('SIMON RODRIGUEZ',2),('SOTILLO',2),('GUANIPA',2),('GUANTA',2),('PIRITU',2),('M.L/DIEGO BAUTISTA U',2),('CARVAJAL',2),('SANTA ANA',2),('MC GREGOR',2),('S JUAN CAPISTRANO',2),('ACHAGUAS',3),('MUÑOZ',3),('PAEZ',3),('PEDRO CAMEJO',3),('ROMULO GALLEGOS',3),('SAN FERNANDO',3),('BIRUACA',3),('GIRARDOT',4),('SANTIAGO MARIÑO',4),('JOSE FELIX RIVAS',4),('SAN CASIMIRO',4),('SAN SEBASTIAN',4),('SUCRE',4),('URDANETA',4),('ZAMORA',4),('LIBERTADOR',4),('JOSE ANGEL LAMAS',4),('BOLIVAR',4),('SANTOS MICHELENA',4),('MARIO B IRAGORRY',4),('TOVAR',4),('CAMATAGUA',4),('JOSE R REVENGA',4),('FRANCISCO LINARES A.',4),('M.OCUMARE D LA COSTA',4),('ARISMENDI',5),('BARINAS',5),('BOLIVAR',5),('EZEQUIEL ZAMORA',5),('OBISPOS',5),('PEDRAZA',5),('ROJAS',5),('SOSA',5),('ALBERTO ARVELO T',5),('A JOSE DE SUCRE',5),('CRUZ PAREDES',5),('ANDRES E. BLANCO',5),('CARONI',6),('CEDEÑO',6),('HERES',6),('PIAR',6),('ROSCIO',6),('SUCRE',6),('SIFONTES',6),('RAUL LEONI',6),('GRAN SABANA',6),('EL CALLAO',6),('PADRE PEDRO CHIEN',6),('BEJUMA',7),('CARLOS ARVELO',7),('DIEGO IBARRA',7),('GUACARA',7),('MONTALBAN',7),('JUAN JOSE MORA',7),('PUERTO CABELLO',7),('SAN JOAQUIN',7),('VALENCIA',7),('MIRANDA',7),('LOS GUAYOS',7),('NAGUANAGUA',7),('SAN DIEGO',7),('LIBERTADOR',7),('ANZOATEGUI',8),('FALCON',8),('GIRARDOT',8),('MP PAO SN J BAUTISTA',8),('RICAURTE',8),('SAN CARLOS',8),('TINACO',8),('LIMA BLANCO',8),('ROMULO GALLEGOS',8),('ACOSTA',9),('BOLIVAR',9),('BUCHIVACOA',9),('CARIRUBANA',9),('COLINA',9),('DEMOCRACIA',9),('FALCON',9),('FEDERACION',9),('MAUROA',9),('MIRANDA',9),('PETIT',9),('SILVA',9),('ZAMORA',9),('DABAJURO',9),('MONS. ITURRIZA',9),('LOS TAQUES',9),('PIRITU',9),('UNION',9),('SAN FRANCISCO',9),('JACURA',9),('CACIQUE MANAURE',9),('PALMA SOLA',9),('SUCRE',9),('URUMACO',9),('TOCOPERO',9),('INFANTE',10),('MELLADO',10),('MIRANDA',10),('MONAGAS',10),('RIBAS',10),('ROSCIO',10),('ZARAZA',10),('CAMAGUAN',10),('S JOSE DE GUARIBE',10),('LAS MERCEDES',10),('EL SOCORRO',10),('ORTIZ',10),('S MARIA DE IPIRE',10),('CHAGUARAMAS',10),('SAN GERONIMO DE G',10),('CRESPO',11),('IRIBARREN',11),('JIMENEZ',11),('MORAN',11),('PALAVECINO',11),('TORRES',11),('URDANETA',11),('ANDRES E BLANCO',11),('SIMON PLANAS',11),('ALBERTO ADRIANI',12),('ANDRES BELLO',12),('ARZOBISPO CHACON',12),('CAMPO ELIAS',12),('GUARAQUE',12),('JULIO CESAR SALAS',12),('JUSTO BRICEÑO',12),('LIBERTADOR',12),('SANTOS MARQUINA',12),('MIRANDA',12),('ANTONIO PINTO S.',12),('OB. RAMOS DE LORA',12),('CARACCIOLO PARRA',12),('CARDENAL QUINTERO',12),('PUEBLO LLANO',12),('RANGEL',12),('RIVAS DAVILA',12),('SUCRE',12),('TOVAR',12),('TULIO F CORDERO',12),('PADRE NOGUERA',12),('ARICAGUA',12),('ZEA',12),('ACEVEDO',13),('BRION',13),('GUAICAIPURO',13),('INDEPENDENCIA',13),('LANDER',13),('PAEZ',13),('PAZ CASTILLO',13),('PLAZA',13),('SUCRE',13),('URDANETA',13),('ZAMORA',13),('CRISTOBAL ROJAS',13),('LOS SALIAS',13),('ANDRES BELLO',13),('SIMON BOLIVAR',13),('BARUTA',13),('CARRIZAL',13),('CHACAO',13),('EL HATILLO',13),('BUROZ',13),('PEDRO GUAL',13),('ACOSTA',14),('BOLIVAR',14),('CARIPE',14),('CEDEÑO',14),('EZEQUIEL ZAMORA',14),('LIBERTADOR',14),('MATURIN',14),('PIAR',14),('PUNCERES',14),('SOTILLO',14),('AGUASAY',14),('SANTA BARBARA',14),('URACOA',14),('ARISMENDI',15),('DIAZ',15),('GOMEZ',15),('MANEIRO',15),('MARCANO',15),('MARIÑO',15),('PENIN. DE MACANAO',15),('VILLALBA(I.COCHE)',15),('TUBORES',15),('ANTOLIN DEL CAMPO',15),('GARCIA',15),('ARAURE',16),('ESTELLER',16),('GUANARE',16),('GUANARITO',16),('OSPINO',16),('PAEZ',16),('SUCRE',16),('TUREN',16),('M.JOSE V DE UNDA',16),('AGUA BLANCA',16),('PAPELON',16),('GENARO BOCONOITO',16),('S RAFAEL DE ONOTO',16),('SANTA ROSALIA',16),('ARISMENDI',17),('BENITEZ',17),('BERMUDEZ',17),('CAJIGAL',17),('MARIÑO',17),('MEJIA',17),('MONTES',17),('RIBERO',17),('SUCRE',17),('VALDEZ',17),('ANDRES E BLANCO',17),('LIBERTADOR',17),('ANDRES MATA',17),('BOLIVAR',17),('CRUZ S ACOSTA',17),('AYACUCHO',18),('BOLIVAR',18),('INDEPENDENCIA',18),('CARDENAS',18),('JAUREGUI',18),('JUNIN',18),('LOBATERA',18),('SAN CRISTOBAL',18),('URIBANTE',18),('CORDOBA',18),('GARCIA DE HEVIA',18),('GUASIMOS',18),('MICHELENA',18),('LIBERTADOR',18),('PANAMERICANO',18),('PEDRO MARIA UREÑA',18),('SUCRE',18),('ANDRES BELLO',18),('FERNANDEZ FEO',18),('LIBERTAD',18),('SAMUEL MALDONADO',18),('SEBORUCO',18),('ANTONIO ROMULO C',18),('FCO DE MIRANDA',18),('JOSE MARIA VARGA',18),('RAFAEL URDANETA',18),('SIMON RODRIGUEZ',18),('TORBES',18),('SAN JUDAS TADEO',18),('RAFAEL RANGEL',19),('BOCONO',19),('CARACHE',19),('ESCUQUE',19),('TRUJILLO',19),('URDANETA',19),('VALERA',19),('CANDELARIA',19),('MIRANDA',19),('MONTE CARMELO',19),('MOTATAN',19),('PAMPAN',19),('S RAFAEL CARVAJAL',19),('SUCRE',19),('ANDRES BELLO',19),('BOLIVAR',19),('JOSE F M CAÑIZAL',19),('JUAN V CAMPO ELI',19),('LA CEIBA',19),('PAMPANITO',19),('BOLIVAR',20),('BRUZUAL',20),('NIRGUA',20),('SAN FELIPE',20),('SUCRE',20),('URACHICHE',20),('PEÑA',20),('JOSE ANTONIO PAEZ',20),('LA TRINIDAD',20),('COCOROTE',20),('INDEPENDENCIA',20),('ARISTIDES BASTID',20),('MANUEL MONGE',20),('VEROES',20),('BARALT',21),('SANTA RITA',21),('COLON',21),('MARA',21),('MARACAIBO',21),('MIRANDA',21),('PAEZ',21),('MACHIQUES DE P',21),('SUCRE',21),('LA CAÑADA DE U.',21),('LAGUNILLAS',21),('CATATUMBO',21),('M/ROSARIO DE PERIJA',21),('CABIMAS',21),('VALMORE RODRIGUEZ',21),('JESUS E LOSSADA',21),('ALMIRANTE P',21),('SAN FRANCISCO',21),('JESUS M SEMPRUN',21),('FRANCISCO J PULG',21),('SIMON BOLIVAR',21),('ATURES',22),('ATABAPO',22),('MAROA',22),('RIO NEGRO',22),('AUTANA',22),('MANAPIARE',22),('ALTO ORINOCO',22),('TUCUPITA',23),('PEDERNALES',23),('ANTONIO DIAZ',23),('CASACOIMA',23),('VARGAS',24);

INSERT INTO parishes (parish, municipality_id) VALUES ('ALTAGRACIA',1),('CANDELARIA',1),('CATEDRAL',1),('LA PASTORA',1),('SAN AGUSTIN',1),('SAN JOSE',1),('SAN JUAN',1),('SANTA ROSALIA',1),('SANTA TERESA',1),('SUCRE',1),('23 DE ENERO',1),('ANTIMANO',1),('EL RECREO',1),('EL VALLE',1),('LA VEGA',1),('MACARAO',1),('CARICUAO',1),('EL JUNQUITO',1),('COCHE',1),('SAN PEDRO',1),('SAN BERNARDINO',1),('EL PARAISO',1),('ANACO',2),('SAN JOAQUIN',2),('CM. ARAGUA DE BARCELONA',3),('CACHIPO',3),('EL CARMEN',4),('SAN CRISTOBAL',4),('BERGANTIN',4),('CAIGUA',4),('EL PILAR',4),('NARICUAL',4),('CM. CLARINES',5),('GUANAPE',5),('SABANA DE UCHIRE',5),('CM. ONOTO',6),('SAN PABLO',6),('CM. CANTAURA',7),('LIBERTADOR',7),('SANTA ROSA',7),('URICA',7),('CM. SOLEDAD',8),('MAMO',8),('CM. SAN MATEO',9),('EL CARITO',9),('SANTA INES',9),('CM. PARIAGUAN',10),('ATAPIRIRE',10),('BOCA DEL PAO',10),('EL PAO',10),('CM. MAPIRE',11),('PIAR',11),('SN DIEGO DE CABRUTICA',11),('SANTA CLARA',11),('UVERITO',11),('ZUATA',11),('CM. PUERTO PIRITU',12),('SAN MIGUEL',12),('SUCRE',12),('CM. EL TIGRE',13),('POZUELOS',14),('CM PTO. LA CRUZ',14),('CM. SAN JOSE DE GUANIPA',15),('GUANTA',16),('CHORRERON',16),('PIRITU',17),('SAN FRANCISCO',17),('LECHERIAS',18),('EL MORRO',18),('VALLE GUANAPE',19),('SANTA BARBARA',19),('SANTA ANA',20),('PUEBLO NUEVO',20),('EL CHAPARRO',21),('TOMAS ALFARO CALATRAVA',21),('BOCA UCHIRE',22),('BOCA DE CHAVEZ',22),('ACHAGUAS',23),('APURITO',23),('EL YAGUAL',23),('GUACHARA',23),('MUCURITAS',23),('QUESERAS DEL MEDIO',23),('BRUZUAL',24),('MANTECAL',24),('QUINTERO',24),('SAN VICENTE',24),('RINCON HONDO',24),('GUASDUALITO',25),('ARAMENDI',25),('EL AMPARO',25),('SAN CAMILO',25),('URDANETA',25),('SAN JUAN DE PAYARA',26),('CODAZZI',26),('CUNAVICHE',26),('ELORZA',27),('LA TRINIDAD',27),('SAN FERNANDO',28),('PEÑALVER',28),('EL RECREO',28),('SN RAFAEL DE ATAMAICA',28),('BIRUACA',29),('CM. LAS DELICIAS',30),('CHORONI',30),('MADRE MA DE SAN JOSE',30),('JOAQUIN CRESPO',30),('PEDRO JOSE OVALLES',30),('JOSE CASANOVA GODOY',30),('ANDRES ELOY BLANCO',30),('LOS TACARIGUAS',30),('CM. TURMERO',31),('SAMAN DE GUERE',31),('ALFREDO PACHECO M',31),('CHUAO',31),('AREVALO APONTE',31),('CM. LA VICTORIA',32),('ZUATA',32),('PAO DE ZARATE',32),('CASTOR NIEVES RIOS',32),('LAS GUACAMAYAS',32),('CM. SAN CASIMIRO',33),('VALLE MORIN',33),('GUIRIPA',33),('OLLAS DE CARAMACATE',33),('CM. SAN SEBASTIAN',34),('CM. CAGUA',35),('BELLA VISTA',35),('CM. BARBACOAS',36),('SAN FRANCISCO DE CARA',36),('TAGUAY',36),('LAS PEÑITAS',36),('CM. VILLA DE CURA',37),('MAGDALENO',37),('SAN FRANCISCO DE ASIS',37),('VALLES DE TUCUTUNEMO',37),('PQ AUGUSTO MIJARES',37),('CM. PALO NEGRO',38),('SAN MARTIN DE PORRES',38),('CM. SANTA CRUZ',39),('CM. SAN MATEO',40),('CM. LAS TEJERIAS',41),('TIARA',41),('CM. EL LIMON',42),('CA A DE AZUCAR',42),('CM. COLONIA TOVAR',43),('CM. CAMATAGUA',44),('CARMEN DE CURA',44),('CM. EL CONSEJO',45),('CM. SANTA RITA',46),('FRANCISCO DE MIRANDA',46),('MONS FELICIANO G',46),('OCUMARE DE LA COSTA',47),('ARISMENDI',48),('GUADARRAMA',48),('LA UNION',48),('SAN ANTONIO',48),('ALFREDO A LARRIVA',49),('BARINAS',49),('SAN SILVESTRE',49),('SANTA INES',49),('SANTA LUCIA',49),('TORUNOS',49),('EL CARMEN',49),('ROMULO BETANCOURT',49),('CORAZON DE JESUS',49),('RAMON I MENDEZ',49),('ALTO BARINAS',49),('MANUEL P FAJARDO',49),('JUAN A RODRIGUEZ D',49),('DOMINGA ORTIZ P',49),('ALTAMIRA',50),('BARINITAS',50),('CALDERAS',50),('SANTA BARBARA',51),('JOSE IGNACIO DEL PUMAR',51),('RAMON IGNACIO MENDEZ',51),('PEDRO BRICEÑO MENDEZ',51),('EL REAL',52),('LA LUZ',52),('OBISPOS',52),('LOS GUASIMITOS',52),('CIUDAD BOLIVIA',53),('IGNACIO BRICEÑO',53),('PAEZ',53),('JOSE FELIX RIBAS',53),('DOLORES',54),('LIBERTAD',54),('PALACIO FAJARDO',54),('SANTA ROSA',54),('CIUDAD DE NUTRIAS',55),('EL REGALO',55),('PUERTO DE NUTRIAS',55),('SANTA CATALINA',55),('RODRIGUEZ DOMINGUEZ',56),('SABANETA',56),('TICOPORO',57),('NICOLAS PULIDO',57),('ANDRES BELLO',57),('BARRANCAS',58),('EL SOCORRO',58),('MASPARRITO',58),('EL CANTON',59),('SANTA CRUZ DE GUACAS',59),('PUERTO VIVAS',59),('SIMON BOLIVAR',60),('ONCE DE ABRIL',60),('VISTA AL SOL',60),('CHIRICA',60),('DALLA COSTA',60),('CACHAMAY',60),('UNIVERSIDAD',60),('UNARE',60),('YOCOIMA',60),('POZO VERDE',60),('CM. CAICARA DEL ORINOCO',61),('ASCENSION FARRERAS',61),('ALTAGRACIA',61),('LA URBANA',61),('GUANIAMO',61),('PIJIGUAOS',61),('CATEDRAL',62),('AGUA SALADA',62),('LA SABANITA',62),('VISTA HERMOSA',62),('MARHUANTA',62),('JOSE ANTONIO PAEZ',62),('ORINOCO',62),('PANAPANA',62),('ZEA',62),('CM. UPATA',63),('ANDRES ELOY BLANCO',63),('PEDRO COVA',63),('CM. GUASIPATI',64),('SALOM',64),('CM. MARIPA',65),('ARIPAO',65),('LAS MAJADAS',65),('MOITACO',65),('GUARATARO',65),('CM. TUMEREMO',66),('DALLA COSTA',66),('SAN ISIDRO',66),('CM. CIUDAD PIAR',67),('SAN FRANCISCO',67),('BARCELONETA',67),('SANTA BARBARA',67),('CM. SANTA ELENA DE UAIREN',68),('IKABARU',68),('CM. EL CALLAO',69),('CM. EL PALMAR',70),('BEJUMA',71),('CANOABO',71),('SIMON BOLIVAR',71),('GUIGUE',72),('BELEN',72),('TACARIGUA',72),('MARIARA',73),('AGUAS CALIENTES',73),('GUACARA',74),('CIUDAD ALIANZA',74),('YAGUA',74),('MONTALBAN',75),('MORON',76),('URAMA',76),('DEMOCRACIA',77),('FRATERNIDAD',77),('GOAIGOAZA',77),('JUAN JOSE FLORES',77),('BARTOLOME SALOM',77),('UNION',77),('BORBURATA',77),('PATANEMO',77),('SAN JOAQUIN',78),('CANDELARIA',79),('CATEDRAL',79),('EL SOCORRO',79),('MIGUEL PEÑA',79),('SAN BLAS',79),('SAN JOSE',79),('SANTA ROSA',79),('RAFAEL URDANETA',79),('NEGRO PRIMERO',79),('MIRANDA',80),('U LOS GUAYOS',81),('NAGUANAGUA',82),('URB SAN DIEGO',83),('U TOCUYITO',84),('U INDEPENDENCIA',84),('COJEDES',85),('JUAN DE MATA SUAREZ',85),('TINAQUILLO',86),('EL BAUL',87),('SUCRE',87),('EL PAO',88),('LIBERTAD DE COJEDES',89),('EL AMPARO',89),('SAN CARLOS DE AUSTRIA',90),('JUAN ANGEL BRAVO',90),('MANUEL MANRIQUE',90),('GRL/JEFE JOSE L SILVA',91),('MACAPO',92),('LA AGUADITA',92),('ROMULO GALLEGOS',93),('SAN JUAN DE LOS CAYOS',94),('CAPADARE',94),('LA PASTORA',94),('LIBERTADOR',94),('SAN LUIS',95),('ARACUA',95),('LA PEÑA',95),('CAPATARIDA',96),('BOROJO',96),('SEQUE',96),('ZAZARIDA',96),('BARIRO',96),('GUAJIRO',96),('NORTE',97),('CARIRUBANA',97),('PUNTA CARDON',97),('SANTA ANA',97),('LA VELA DE CORO',98),('ACURIGUA',98),('GUAIBACOA',98),('MACORUCA',98),('LAS CALDERAS',98),('PEDREGAL',99),('AGUA CLARA',99),('AVARIA',99),('PIEDRA GRANDE',99),('PURURECHE',99),('PUEBLO NUEVO',100),('ADICORA',100),('BARAIVED',100),('BUENA VISTA',100),('JADACAQUIVA',100),('MORUY',100),('EL VINCULO',100),('EL HATO',100),('ADAURE',100),('CHURUGUARA',101),('AGUA LARGA',101),('INDEPENDENCIA',101),('MAPARARI',101),('EL PAUJI',101),('MENE DE MAUROA',102),('CASIGUA',102),('SAN FELIX',102),('SAN ANTONIO',103),('SAN GABRIEL',103),('SANTA ANA',103),('GUZMAN GUILLERMO',103),('MITARE',103),('SABANETA',103),('RIO SECO',103),('CABURE',104),('CURIMAGUA',104),('COLINA',104),('TUCACAS',105),('BOCA DE AROA',105),('PUERTO CUMAREBO',106),('LA CIENAGA',106),('LA SOLEDAD',106),('PUEBLO CUMAREBO',106),('ZAZARIDA',106),('CM. DABAJURO',107),('CHICHIRIVICHE',108),('BOCA DE TOCUYO',108),('TOCUYO DE LA COSTA',108),('LOS TAQUES',109),('JUDIBANA',109),('PIRITU',110),('SAN JOSE DE LA COSTA',110),('STA.CRUZ DE BUCARAL',111),('EL CHARAL',111),('LAS VEGAS DEL TUY',111),('CM. MIRIMIRE',112),('JACURA',113),('AGUA LINDA',113),('ARAURIMA',113),('CM. YARACAL',114),('CM. PALMA SOLA',115),('SUCRE',116),('PECAYA',116),('URUMACO',117),('BRUZUAL',117),('CM. TOCOPERO',118),('VALLE DE LA PASCUA',119),('ESPINO',119),('EL SOMBRERO',120),('SOSA',120),('CALABOZO',121),('EL CALVARIO',121),('EL RASTRO',121),('GUARDATINAJAS',121),('ALTAGRACIA DE ORITUCO',122),('LEZAMA',122),('LIBERTAD DE ORITUCO',122),('SAN FCO DE MACAIRA',122),('SAN RAFAEL DE ORITUCO',122),('SOUBLETTE',122),('PASO REAL DE MACAIRA',122),('TUCUPIDO',123),('SAN RAFAEL DE LAYA',123),('SAN JUAN DE LOS MORROS',124),('PARAPARA',124),('CANTAGALLO',124),('ZARAZA',125),('SAN JOSE DE UNARE',125),('CAMAGUAN',126),('PUERTO MIRANDA',126),('UVERITO',126),('SAN JOSE DE GUARIBE',127),('LAS MERCEDES',128),('STA RITA DE MANAPIRE',128),('CABRUTA',128),('EL SOCORRO',129),('ORTIZ',130),('SAN FCO. DE TIZNADOS',130),('SAN JOSE DE TIZNADOS',130),('S LORENZO DE TIZNADOS',130),('SANTA MARIA DE IPIRE',131),('ALTAMIRA',131),('CHAGUARAMAS',132),('GUAYABAL',133),('CAZORLA',133),('FREITEZ',134),('JOSE MARIA BLANCO',134),('CATEDRAL',135),('LA CONCEPCION',135),('SANTA ROSA',135),('UNION',135),('EL CUJI',135),('TAMACA',135),('JUAN DE VILLEGAS',135),('AGUEDO F. ALVARADO',135),('BUENA VISTA',135),('JUAREZ',135),('JUAN B RODRIGUEZ',136),('DIEGO DE LOZADA',136),('SAN MIGUEL',136),('CUARA',136),('PARAISO DE SAN JOSE',136),('TINTORERO',136),('JOSE BERNARDO DORANTE',136),('CRNEL. MARIANO PERAZA',136),('BOLIVAR',137),('ANZOATEGUI',137),('GUARICO',137),('HUMOCARO ALTO',137),('HUMOCARO BAJO',137),('MORAN',137),('HILARIO LUNA Y LUNA',137),('LA CANDELARIA',137),('CABUDARE',138),('JOSE G. BASTIDAS',138),('AGUA VIVA',138),('TRINIDAD SAMUEL',139),('ANTONIO DIAZ',139),('CAMACARO',139),('CASTAÑEDA',139),('CHIQUINQUIRA',139),('ESPINOZA LOS MONTEROS',139),('LARA',139),('MANUEL MORILLO',139),('MONTES DE OCA',139),('TORRES',139),('EL BLANCO',139),('MONTA A VERDE',139),('HERIBERTO ARROYO',139),('LAS MERCEDES',139),('CECILIO ZUBILLAGA',139),('REYES VARGAS',139),('ALTAGRACIA',139),('SIQUISIQUE',140),('SAN MIGUEL',140),('XAGUAS',140),('MOROTURO',140),('PIO TAMAYO',141),('YACAMBU',141),('QBDA. HONDA DE GUACHE',141),('SARARE',142),('GUSTAVO VEGAS LEON',142),('BURIA',142),('GABRIEL PICON G.',143),('HECTOR AMABLE MORA',143),('JOSE NUCETE SARDI',143),('PULIDO MENDEZ',143),('PTE. ROMULO GALLEGOS',143),('PRESIDENTE BETANCOURT',143),('PRESIDENTE PAEZ',143),('CM. LA AZULITA',144),('CM. CANAGUA',145),('CAPURI',145),('CHACANTA',145),('EL MOLINO',145),('GUAIMARAL',145),('MUCUTUY',145),('MUCUCHACHI',145),('ACEQUIAS',146),('JAJI',146),('LA MESA',146),('SAN JOSE',146),('MONTALBAN',146),('MATRIZ',146),('FERNANDEZ PEÑA',146),('CM. GUARAQUE',147),('MESA DE QUINTERO',147),('RIO NEGRO',147),('CM. ARAPUEY',148),('PALMIRA',148),('CM. TORONDOY',149),('SAN CRISTOBAL DE T',149),('ARIAS',150),('SAGRARIO',150),('MILLA',150),('EL LLANO',150),('JUAN RODRIGUEZ SUAREZ',150),('JACINTO PLAZA',150),('DOMINGO PEÑA',150),('GONZALO PICON FEBRES',150),('OSUNA RODRIGUEZ',150),('LASSO DE LA VEGA',150),('CARACCIOLO PARRA P',150),('MARIANO PICON SALAS',150),('ANTONIO SPINETTI DINI',150),('EL MORRO',150),('LOS NEVADOS',150),('CM. TABAY',151),('CM. TIMOTES',152),('ANDRES ELOY BLANCO',152),('PIÑANGO',152),('LA VENTA',152),('CM. STA CRUZ DE MORA',153),('MESA BOLIVAR',153),('MESA DE LAS PALMAS',153),('CM. STA ELENA DE ARENALES',154),('ELOY PAREDES',154),('PQ R DE ALCAZAR',154),('CM. TUCANI',155),('FLORENCIO RAMIREZ',155),('CM. SANTO DOMINGO',156),('LAS PIEDRAS',156),('CM. PUEBLO LLANO',157),('CM. MUCUCHIES',158),('MUCURUBA',158),('SAN RAFAEL',158),('CACUTE',158),('LA TOMA',158),('CM. BAILADORES',159),('GERONIMO MALDONADO',159),('CM. LAGUNILLAS',160),('CHIGUARA',160),('ESTANQUES',160),('SAN JUAN',160),('PUEBLO NUEVO DEL SUR',160),('LA TRAMPA',160),('EL LLANO',161),('TOVAR',161),('EL AMPARO',161),('SAN FRANCISCO',161),('CM. NUEVA BOLIVIA',162),('INDEPENDENCIA',162),('MARIA C PALACIOS',162),('SANTA APOLONIA',162),('CM. STA MARIA DE CAPARO',163),('CM. ARICAGUA',164),('SAN ANTONIO',164),('CM. ZEA',165),('CAÑO EL TIGRE',165),('CAUCAGUA',166),('ARAGUITA',166),('AREVALO GONZALEZ',166),('CAPAYA',166),('PANAQUIRE',166),('RIBAS',166),('EL CAFE',166),('MARIZAPA',166),('HIGUEROTE',167),('CURIEPE',167),('TACARIGUA',167),('LOS TEQUES',168),('CECILIO ACOSTA',168),('PARACOTOS',168),('SAN PEDRO',168),('TACATA',168),('EL JARILLO',168),('ALTAGRACIA DE LA M',168),('STA TERESA DEL TUY',169),('EL CARTANAL',169),('OCUMARE DEL TUY',170),('LA DEMOCRACIA',170),('SANTA BARBARA',170),('RIO CHICO',171),('EL GUAPO',171),('TACARIGUA DE LA LAGUNA',171),('PAPARO',171),('SN FERNANDO DEL GUAPO',171),('SANTA LUCIA',172),('GUARENAS',173),('PETARE',174),('LEONCIO MARTINEZ',174),('CAUCAGUITA',174),('FILAS DE MARICHES',174),('LA DOLORITA',174),('CUA',175),('NUEVA CUA',175),('GUATIRE',176),('BOLIVAR',176),('CHARALLAVE',177),('LAS BRISAS',177),('SAN ANTONIO LOS ALTOS',178),('SAN JOSE DE BARLOVENTO',179),('CUMBO',179),('SAN FCO DE YARE',180),('S ANTONIO DE YARE',180),('BARUTA',181),('EL CAFETAL',181),('LAS MINAS DE BARUTA',181),('CARRIZAL',182),('CHACAO',183),('EL HATILLO',184),('MAMPORAL',185),('CUPIRA',186),('MACHURUCUTO',186),('CM. SAN ANTONIO',187),('SAN FRANCISCO',187),('CM. CARIPITO',188),('CM. CARIPE',189),('TERESEN',189),('EL GUACHARO',189),('SAN AGUSTIN',189),('LA GUANOTA',189),('SABANA DE PIEDRA',189),('CM. CAICARA',190),('AREO',190),('SAN FELIX',190),('VIENTO FRESCO',190),('CM. PUNTA DE MATA',191),('EL TEJERO',191),('CM. TEMBLADOR',192),('TABASCA',192),('LAS ALHUACAS',192),('CHAGUARAMAS',192),('EL FURRIAL',193),('JUSEPIN',193),('EL COROZO',193),('SAN VICENTE',193),('LA PICA',193),('ALTO DE LOS GODOS',193),('BOQUERON',193),('LAS COCUIZAS',193),('SANTA CRUZ',193),('SAN SIMON',193),('CM. ARAGUA',194),('CHAGUARAMAL',194),('GUANAGUANA',194),('APARICIO',194),('TAGUAYA',194),('EL PINTO',194),('LA TOSCANA',194),('CM. QUIRIQUIRE',195),('CACHIPO',195),('CM. BARRANCAS',196),('LOS BARRANCOS DE FAJARDO',196),('CM. AGUASAY',197),('CM. SANTA BARBARA',198),('CM. URACOA',199),('CM. LA ASUNCION',200),('CM. SAN JUAN BAUTISTA',201),('ZABALA',201),('CM. SANTA ANA',202),('GUEVARA',202),('MATASIETE',202),('BOLIVAR',202),('SUCRE',202),('CM. PAMPATAR',203),('AGUIRRE',203),('CM. JUAN GRIEGO',204),('ADRIAN',204),('CM. PORLAMAR',205),('CM. BOCA DEL RIO',206),('SAN FRANCISCO',206),('CM. SAN PEDRO DE COCHE',207),('VICENTE FUENTES',207),('CM. PUNTA DE PIEDRAS',208),('LOS BARALES',208),('CM.LA PLAZA DE PARAGUACHI',209),('CM. VALLE ESP SANTO',210),('FRANCISCO FAJARDO',210),('CM. ARAURE',211),('RIO ACARIGUA',211),('CM. PIRITU',212),('UVERAL',212),('CM. GUANARE',213),('CORDOBA',213),('SAN JUAN GUANAGUANARE',213),('VIRGEN DE LA COROMOTO',213),('SAN JOSE DE LA MONTAÑA',213),('CM. GUANARITO',214),('TRINIDAD DE LA CAPILLA',214),('DIVINA PASTORA',214),('CM. OSPINO',215),('APARICION',215),('LA ESTACION',215),('CM. ACARIGUA',216),('PAYARA',216),('PIMPINELA',216),('RAMON PERAZA',216),('CM. BISCUCUY',217),('CONCEPCION',217),('SAN RAFAEL PALO ALZADO',217),('UVENCIO A VELASQUEZ',217),('SAN JOSE DE SAGUAZ',217),('VILLA ROSA',217),('CM. VILLA BRUZUAL',218),('CANELONES',218),('SANTA CRUZ',218),('SAN ISIDRO LABRADOR',218),('CM. CHABASQUEN',219),('PEÑA BLANCA',219),('CM. AGUA BLANCA',220),('CM. PAPELON',221),('CAÑO DELGADITO',221),('CM. BOCONOITO',222),('ANTOLIN TOVAR AQUINO',222),('CM. SAN RAFAEL DE ONOTO',223),('SANTA FE',223),('THERMO MORLES',223),('CM. EL PLAYON',224),('FLORIDA',224),('RIO CARIBE',225),('SAN JUAN GALDONAS',225),('PUERTO SANTO',225),('EL MORRO DE PTO SANTO',225),('ANTONIO JOSE DE SUCRE',225),('EL PILAR',226),('EL RINCON',226),('GUARAUNOS',226),('TUNAPUICITO',226),('UNION',226),('GRAL FCO. A VASQUEZ',226),('SANTA CATALINA',227),('SANTA ROSA',227),('SANTA TERESA',227),('BOLIVAR',227),('MACARAPANA',227),('YAGUARAPARO',228),('LIBERTAD',228),('PAUJIL',228),('IRAPA',229),('CAMPO CLARO',229),('SORO',229),('SAN ANTONIO DE IRAPA',229),('MARABAL',229),('CM. SAN ANT DEL GOLFO',230),('CUMANACOA',231),('ARENAS',231),('ARICAGUA',231),('COCOLLAR',231),('SAN FERNANDO',231),('SAN LORENZO',231),('CARIACO',232),('CATUARO',232),('RENDON',232),('SANTA CRUZ',232),('SANTA MARIA',232),('ALTAGRACIA',233),('AYACUCHO',233),('SANTA INES',233),('VALENTIN VALIENTE',233),('SAN JUAN',233),('GRAN MARISCAL',233),('RAUL LEONI',233),('GUIRIA',234),('CRISTOBAL COLON',234),('PUNTA DE PIEDRA',234),('BIDEAU',234),('MARIÑO',235),('ROMULO GALLEGOS',235),('TUNAPUY',236),('CAMPO ELIAS',236),('SAN JOSE DE AREOCUAR',237),('TAVERA ACOSTA',237),('CM. MARIGUITAR',238),('ARAYA',239),('MANICUARE',239),('CHACOPATA',239),('CM. COLON',240),('RIVAS BERTI',240),('SAN PEDRO DEL RIO',240),('CM. SAN ANT DEL TACHIRA',241),('PALOTAL',241),('JUAN VICENTE GOMEZ',241),('ISAIAS MEDINA ANGARIT',241),('CM. CAPACHO NUEVO',242),('JUAN GERMAN ROSCIO',242),('ROMAN CARDENAS',242),('CM. TARIBA',243),('LA FLORIDA',243),('AMENODORO RANGEL LAMU',243),('CM. LA GRITA',244),('EMILIO C. GUERRERO',244),('MONS. MIGUEL A SALAS',244),('CM. RUBIO',245),('BRAMON',245),('LA PETROLEA',245),('QUINIMARI',245),('CM. LOBATERA',246),('CONSTITUCION',246),('LA CONCORDIA',247),('PEDRO MARIA MORANTES',247),('SN JUAN BAUTISTA',247),('SAN SEBASTIAN',247),('DR. FCO. ROMERO LOBO',247),('CM. PREGONERO',248),('CARDENAS',248),('POTOSI',248),('JUAN PABLO PEÑALOZA',248),('CM. STA. ANA  DEL TACHIRA',249),('CM. LA FRIA',250),('BOCA DE GRITA',250),('JOSE ANTONIO PAEZ',250),('CM. PALMIRA',251),('CM. MICHELENA',252),('CM. ABEJALES',253),('SAN JOAQUIN DE NAVAY',253),('DORADAS',253),('EMETERIO OCHOA',253),('CM. COLONCITO',254),('LA PALMITA',254),('CM. UREÑA',255),('NUEVA ARCADIA',255),('CM. QUENIQUEA',256),('SAN PABLO',256),('ELEAZAR LOPEZ CONTRERA',256),('CM. CORDERO',257),('CM.SAN RAFAEL DEL PINAL',258),('SANTO DOMINGO',258),('ALBERTO ADRIANI',258),('CM. CAPACHO VIEJO',259),('CIPRIANO CASTRO',259),('MANUEL FELIPE RUGELES',259),('CM. LA TENDIDA',260),('BOCONO',260),('HERNANDEZ',260),('CM. SEBORUCO',261),('CM. LAS MESAS',262),('CM. SAN JOSE DE BOLIVAR',263),('CM. EL COBRE',264),('CM. DELICIAS',265),('CM. SAN SIMON',266),('CM. SAN JOSECITO',267),('CM. UMUQUENA',268),('BETIJOQUE',269),('JOSE G HERNANDEZ',269),('LA PUEBLITA',269),('EL CEDRO',269),('BOCONO',270),('EL CARMEN',270),('MOSQUEY',270),('AYACUCHO',270),('BURBUSAY',270),('GENERAL RIVAS',270),('MONSEÑOR JAUREGUI',270),('RAFAEL RANGEL',270),('SAN JOSE',270),('SAN MIGUEL',270),('GUARAMACAL',270),('LA VEGA DE GUARAMACAL',270),('CARACHE',271),('LA CONCEPCION',271),('CUICAS',271),('PANAMERICANA',271),('SANTA CRUZ',271),('ESCUQUE',272),('SABANA LIBRE',272),('LA UNION',272),('SANTA RITA',272),('CRISTOBAL MENDOZA',273),('CHIQUINQUIRA',273),('MATRIZ',273),('MONSEÑOR CARRILLO',273),('CRUZ CARRILLO',273),('ANDRES LINARES',273),('TRES ESQUINAS',273),('LA QUEBRADA',274),('JAJO',274),('LA MESA',274),('SANTIAGO',274),('CABIMBU',274),('TUÑAME',274),('MERCEDES DIAZ',275),('JUAN IGNACIO MONTILLA',275),('LA BEATRIZ',275),('MENDOZA',275),('LA PUERTA',275),('SAN LUIS',275),('CHEJENDE',276),('CARRILLO',276),('CEGARRA',276),('BOLIVIA',276),('MANUEL SALVADOR ULLOA',276),('SAN JOSE',276),('ARNOLDO GABALDON',276),('EL DIVIDIVE',277),('AGUA CALIENTE',277),('EL CENIZO',277),('AGUA SANTA',277),('VALERITA',277),('MONTE CARMELO',278),('BUENA VISTA',278),('STA MARIA DEL HORCON',278),('MOTATAN',279),('EL BAÑO',279),('JALISCO',279),('PAMPAN',280),('SANTA ANA',280),('LA PAZ',280),('FLOR DE PATRIA',280),('CARVAJAL',281),('ANTONIO N BRICEÑO',281),('CAMPO ALEGRE',281),('JOSE LEONARDO SUAREZ',281),('SABANA DE MENDOZA',282),('JUNIN',282),('VALMORE RODRIGUEZ',282),('EL PARAISO',282),('SANTA ISABEL',283),('ARAGUANEY',283),('EL JAGUITO',283),('LA ESPERANZA',283),('SABANA GRANDE',284),('CHEREGUE',284),('GRANADOS',284),('EL SOCORRO',285),('LOS CAPRICHOS',285),('ANTONIO JOSE DE SUCRE',285),('CAMPO ELIAS',286),('ARNOLDO GABALDON',286),('SANTA APOLONIA',287),('LA CEIBA',287),('EL PROGRESO',287),('TRES DE FEBRERO',287),('PAMPANITO',288),('PAMPANITO II',288),('LA CONCEPCION',288),('CM. AROA',289),('CM. CHIVACOA',290),('CAMPO ELIAS',290),('CM. NIRGUA',291),('SALOM',291),('TEMERLA',291),('CM. SAN FELIPE',292),('ALBARICO',292),('SAN JAVIER',292),('CM. GUAMA',293),('CM. URACHICHE',294),('CM. YARITAGUA',295),('SAN ANDRES',295),('CM. SABANA DE PARRA',296),('CM. BORAURE',297),('CM. COCOROTE',298),('CM. INDEPENDENCIA',299),('CM. SAN PABLO',300),('CM. YUMARE',301),('CM. FARRIAR',302),('EL GUAYABO',302),('GENERAL URDANETA',303),('LIBERTADOR',303),('MANUEL GUANIPA MATOS',303),('MARCELINO BRICEÑO',303),('SAN TIMOTEO',303),('PUEBLO NUEVO',303),('PEDRO LUCAS URRIBARRI',304),('SANTA RITA',304),('JOSE CENOVIO URRIBARR',304),('EL MENE',304),('SANTA CRUZ DEL ZULIA',305),('URRIBARRI',305),('MORALITO',305),('SAN CARLOS DEL ZULIA',305),('SANTA BARBARA',305),('LUIS DE VICENTE',306),('RICAURTE',306),('MONS.MARCOS SERGIO G',306),('SAN RAFAEL',306),('LAS PARCELAS',306),('TAMARE',306),('LA SIERRITA',306),('BOLIVAR',307),('COQUIVACOA',307),('CRISTO DE ARANZA',307),('CHIQUINQUIRA',307),('SANTA LUCIA',307),('OLEGARIO VILLALOBOS',307),('JUANA DE AVILA',307),('CARACCIOLO PARRA PEREZ',307),('IDELFONZO VASQUEZ',307),('CACIQUE MARA',307),('CECILIO ACOSTA',307),('RAUL LEONI',307),('FRANCISCO EUGENIO B',307),('MANUEL DAGNINO',307),('LUIS HURTADO HIGUERA',307),('VENANCIO PULGAR',307),('ANTONIO BORJAS ROMERO',307),('SAN ISIDRO',307),('FARIA',308),('SAN ANTONIO',308),('ANA MARIA CAMPOS',308),('SAN JOSE',308),('ALTAGRACIA',308),('GOAJIRA',309),('ELIAS SANCHEZ RUBIO',309),('SINAMAICA',309),('ALTA GUAJIRA',309),('SAN JOSE DE PERIJA',310),('BARTOLOME DE LAS CASAS',310),('LIBERTAD',310),('RIO NEGRO',310),('GIBRALTAR',311),('HERAS',311),('M.ARTURO CELESTINO A',311),('ROMULO GALLEGOS',311),('BOBURES',311),('EL BATEY',311),('ANDRES BELLO (KM 48)',312),('POTRERITOS',312),('EL CARMELO',312),('CHIQUINQUIRA',312),('CONCEPCION',312),('ELEAZAR LOPEZ C',313),('ALONSO DE OJEDA',313),('VENEZUELA',313),('CAMPO LARA',313),('LIBERTAD',313),('UDON PEREZ',314),('ENCONTRADOS',314),('DONALDO GARCIA',315),('SIXTO ZAMBRANO',315),('EL ROSARIO',315),('AMBROSIO',316),('GERMAN RIOS LINARES',316),('JORGE HERNANDEZ',316),('LA ROSA',316),('PUNTA GORDA',316),('CARMEN HERRERA',316),('SAN BENITO',316),('ROMULO BETANCOURT',316),('ARISTIDES CALVANI',316),('RAUL CUENCA',317),('LA VICTORIA',317),('RAFAEL URDANETA',317),('JOSE RAMON YEPEZ',318),('LA CONCEPCION',318),('SAN JOSE',318),('MARIANO PARRA LEON',318),('MONAGAS',319),('ISLA DE TOAS',319),('MARCIAL HERNANDEZ',320),('FRANCISCO OCHOA',320),('SAN FRANCISCO',320),('EL BAJO',320),('DOMITILA FLORES',320),('LOS CORTIJOS',320),('BARI',321),('JESUS M SEMPRUN',321),('SIMON RODRIGUEZ',322),('CARLOS QUEVEDO',322),('FRANCISCO J PULGAR',322),('RAFAEL MARIA BARALT',323),('MANUEL MANRIQUE',323),('RAFAEL URDANETA',323),('FERNANDO GIRON TOVAR',324),('LUIS ALBERTO GOMEZ',324),('PARHUEÑA',324),('PLATANILLAL',324),('CM. SAN FERNANDO DE ATABA',325),('UCATA',325),('YAPACANA',325),('CANAME',325),('CM. MAROA',326),('VICTORINO',326),('COMUNIDAD',326),('CM. SAN CARLOS DE RIO NEG',327),('SOLANO',327),('COCUY',327),('CM. ISLA DE RATON',328),('SAMARIAPO',328),('SIPAPO',328),('MUNDUAPO',328),('GUAYAPO',328),('CM. SAN JUAN DE MANAPIARE',329),('ALTO VENTUARI',329),('MEDIO VENTUARI',329),('BAJO VENTUARI',329),('CM. LA ESMERALDA',330),('HUACHAMACARE',330),('MARAWAKA',330),('MAVACA',330),('SIERRA PARIMA',330),('SAN JOSE',331),('VIRGEN DEL VALLE',331),('SAN RAFAEL',331),('JOSE VIDAL MARCANO',331),('LEONARDO RUIZ PINEDA',331),('MONS. ARGIMIRO GARCIA',331),('MCL.ANTONIO J DE SUCRE',331),('JUAN MILLAN',331),('PEDERNALES',332),('LUIS B PRIETO FIGUERO',332),('CURIAPO',333),('SANTOS DE ABELGAS',333),('MANUEL RENAUD',333),('PADRE BARRAL',333),('ANICETO LUGO',333),('ALMIRANTE LUIS BRION',333),('IMATACA',334),('ROMULO GALLEGOS',334),('JUAN BAUTISTA ARISMEN',334),('MANUEL PIAR',334),('5 DE JULIO',334),('CARABALLEDA',335),('CARAYACA',335),('CARUAO',335),('CATIA LA MAR',335),('LA GUAIRA',335),('MACUTO',335),('MAIQUETIA',335),('NAIGUATA',335),('EL JUNKO',335),('PQ RAUL LEONI',335),('PQ CARLOS SOUBLETTE',335);

-- Inserta datos de pruebas
INSERT INTO persons (identity_card,first_name,first_last_name,gender_id) VALUES (28076011,'Nicolas','Zapata',2);
INSERT INTO location (person_id,state_id,municipality_id,parish_id,address) VALUES (1,13,177,610,'Calle 8');
INSERT INTO auth.users (username,password,person_id,role_id,department_id) VALUES ('nicoadmin','$2a$10$iTHAxSj1ooB.J1vCPQEnCel21TUE5qimteBFg6HtL0nDwQ5IWC6Ze',1,1,2);
-- password = 123456
--Fin del SQL