-- creating tables and primary / foreign keys

CREATE TABLE school (
  id integer PRIMARY KEY,
  name varchar(20) NOT NULL,
  address varchar(50) NOT NULL,
  number integer NOT NULL,
  unique (name, address, number)
);

ALTER TABLE school
ADD CHECK CHECK(DATALENGTH(number)=9);

CREATE TABLE teacher (
  id integer PRIMARY KEY,
  name varchar(20) NOT NULL,
  address varchar(50) NOT NULL,
  contact integer NOT NULL,
  UNIQUE(name, address, contact)
  );

ALTER TABLE teacher
ADD CHECK CHECK(DATALENGTH(contact)=9);
 
 CREATE TABLE schools_teachers(
 	FOREIGN KEY (school_id) integer REFERENCES school(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (teacher_id) integer REFERENCES teacher(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY(school_id, teacher_id)
 );
 
 CREATE TABLE guardian(
 	id int PRIMARY KEY,
  name varchar(20) NOT NULL,
  contact integer UNIQUE NOT NULL,
  notes varchar(200),
 );

ALTER TABLE guardian
ADD CHECK CHECK(DATALENGTH(contact)=9);
 
 CREATE TABLE student(
	id integer PRIMARY KEY,
  name varchar(20) NOT NULL,
  date_of_enrollment date,
  notes varchar(200),
  FOREIGN KEY (teacher_id) integer REFERENCES teacher(id)ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (school_id) integer REFERENCES school(id)ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (guardian_id) integer REFERENCES guardian(id) ON DELETE CASCADE ON UPDATE CASCADE
 );
 
 -- inserting data into tables
 
  INSERT INTO school VALUES 
 (1, 'Campo Grande', 'Rua de Campo Grande, Lisboa, 1900-650', 945222345),
 (2, 'Avenida de Liberdade', 'Avenida de Liberdade, Lisboa, 1600-960', 945310945),
 (3, 'Avenida de Roma', 'Avenida de Roma, Lisboa, 1700-650', 805223745),
 (4, 'Parque das Nações', 'Rua de Oceanos, Lisboa, 1800-540', 904510955)
 ;
 
 INSERT INTO teacher VALUES
 (1, 'Rob_Davidson', 'Rua Lucinda Do Carmo 5, Lisbon, 1900-500', 555904923),
 (2, 'Sarah_Jones', 'Avenida dos Estados Unidos 17a, Lisbon, 1795-850', 555904923),
 (3, 'Darren_Wilkinson', 'Rua Cor de Rosa, Lisbon, 1566-800', 555904923)
 ;

 INSERT INTO student VALUES 
(1, 'Paulo Costa',	'2008-11-11' , 'long time student', 2, 3),
(2, 'Eduarda Da Silva',	'2023-05-15' , 'recently arrived from Brazil', 2, 2),
(3, 'Pedro Alves',	'2000-06-11' , 'business student', 1, 4),
(4, 'Francisco Rocha', '2022-01-11', 'long time student', 3, 3)
;

INSERT INTO guardian VALUES 
(1, 2 , 'Madalena Silva',	555904956 , 'parent to multiple kids at the school'),
(2, 3, 'Jandira Neto', 546758745 , 'very interetsed in childs performance, needs updating'),
(3, 4, 'Rodrigo Aldo',	905222059 , 'does not speak English, needs translation of evaluations etc')
;

-- adjusting teacher table to add school id

ALTER TABLE teacher
ADD COLUMN FOREIGN KEY (school_id) integer REFERENCES school(id)ON DELETE CASCADE ON UPDATE CASCADE;

UPDATE teacher
SET school_id = 1
WHERE id = 1;

UPDATE teacher
SET school_id = 2
WHERE id = 2;

UPDATE teacher
SET school_id = 1
WHERE id = 3;

-- populating the schools_teachers table to link the two

 INSERT INTO schools_teachers
 VALUES
 (1, 3),
 (2, 2),
 (1, 1);

 -- creating a new column in students to link the guardian, so the link can go both ways

 ALTER TABLE guardians
 ADD COLUMN FOREIGN KEY (student_id) integer REFERENCES student(id) ON DELETE CASCADE ON UPDATE CASCADE;

 UPDATE student
SET guardian_id = 3
WHERE id = 1;

UPDATE student
SET guardian_id = 3
WHERE id = 2;

UPDATE student
SET guardian_id = 1
WHERE id = 3;

UPDATE student
SET guardian_id = 2
WHERE id = 4;

-- creating roles for admin, head_teachers and teachers

SELECT current_user;

CREATE ROLE admin WITH LOGIN SUPERUSER CREATEROLE CREATEDB;

CREATE ROLE head_teachers WITH LOGIN;

CREATE ROLE teachers WITH LOGIN;

-- column / row level security

GRANT SELECT (id, name, address, school_id) ON teacher to teachers;

CREATE POLICY emp_rls_policy ON teacher FOR UPDATE 
TO teachers USING (name=current_user);

ALTER TABLE teacher ENABLE ROW LEVEL SECURITY;

GRANT SELECT (id, student_id, name, notes) ON guardian to teachers;

CREATE ROLE Rob_Davidson WITH LOGIN IN ROLE teachers;




