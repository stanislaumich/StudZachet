rem @echo off
del backupMSU_prev.dmp
ren backupMSU.dmp backupMSU_prev.dmp
rem del backupzamer.dmp
sqlplus msu/msu @backupMSU.sql
exp msu/msu parfile=backupMSU.dat
rem del *.log
rar a -m5 -ag_dd.mm.yyyy-hh-mi-ss backupMSU @backupMSU.lst
rem pause