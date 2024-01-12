set /p place=< s:\place.txt
cd BACKUP
call _backupMSU.bat 
cd ..
git add .
git commit -m "AUTO FROM %place% %date% %time%"
git config --global http.version HTTP/1.1
git push
rem git push origin --force
git config --global http.version HTTP/2
pause