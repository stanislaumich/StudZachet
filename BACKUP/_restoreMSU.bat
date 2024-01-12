chcp 1251
@echo off
s:
cd \
cd studzachet
cd backup
sqlplus sys/manager1 as sysdba @create_MSU.sql
imp msu/msu ignore=y parfile=restoreMSU.dat
