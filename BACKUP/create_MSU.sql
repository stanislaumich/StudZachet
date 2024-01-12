spool create_user.log
shutdown immediate;
startup restrict;
--ALTER DATABASE CHARACTER SET INTERNAL_USE CL8MSWIN1251;
ALTER DATABASE CHARACTER SET INTERNAL_USE AL32UTF8;
shutdown immediate;
startup;
--alter session set "_ORACLE_SCRIPT"=true;
drop user MSU cascade;
ALTER PROFILE default LIMIT password_life_time UNLIMITED;
create user MSU identified by msu default tablespace users temporary tablespace temp;
grant dba to MSU;
grant create session to MSU;
spool off
exit;