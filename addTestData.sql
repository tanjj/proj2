-- addTestData.sql test data for testing SQL 
-- for testing sql scripts
insert into workers (name,username,password,department)
  values ('admin','root',md5('root'),'admin');
insert into workers (name,username,password,department)
  values ('Jane Doe','janedoe',md5('janedoe'),'deptA');
insert into workers (name,username,password,department)
  values ('John Doe','john',md5('john'),'deptA');
insert into workers (name,username,password,department)
  values ('Bill Gates','bill',md5('bill'),'deptB');
insert into workers (name,username,password,department)
  values ('Bruce Perens','perens',md5('openguru'),'deptB');
insert into workers (name,username,password,department)
  values ('Eric Raymond','esr',md5('catb'),'deptC');
  
insert into workshops (title) values ('Workshop 1');
insert into workshops (title) values ('Workshop 2');
insert into workshops (title) values ('Workshop 3');
insert into workshops (title) values ('Intro to Rails');
insert into workshops (title) values ('Intro to PostgreSQL');
insert into workshops (title) values ('Writing plpgsql functions');

insert into worker_workshop (worker_id,workshop_id)
  values (2,1);
insert into worker_workshop (worker_id,workshop_id)
  values (3,1);
insert into worker_workshop (worker_id,workshop_id)
  values (2,2);
