-- addFuncs.sql

create or replace function get_id(_user text, _pass text)
  returns integer as
  $func$
    declare
      rec record;
    begin
      select * into rec from workers where username=_user;
      if not found then
        return -1;
      elsif rec.password = md5(_pass) then
        return rec.id;
      else
        return -1;
      end if;
    end;
  $func$
  language 'plpgsql';
  
select get_id('janedoe','janey');
select get_id('kljkj','kljkljkl');

create or replace function add_worker_workshops(
  _worker_id integer, _wks_list text)
  returns boolean as
  $func$
    declare
      my_array text[];
    begin
      my_array := string_to_array(_wks_list,',');
      for i in 1..array_length(my_array,1) loop
        insert into worker_workshop (worker_id,
          workshop_id) values (_worker_id, 
            cast(my_array[i] as integer));
      end loop;
      return 't';
    end;
  $func$
  language 'plpgsql';

create or replace function delete_worker_workshops(_workid integer)
  returns boolean as
  $func$
    begin
      delete from worker_workshop where worker_id=_workid;
      return 't';
    end;
  $func$
  language 'plpgsql';

create or replace function 
  update_worker_workshops(_workid integer, _wks_list text)
  returns boolean as
  $func$
    begin
      perform delete_worker_workshops(_workid);
      perform add_worker_workshops(_workid,_wks_list);
      return 't';
    end;
  $func$
  language 'plpgsql';
