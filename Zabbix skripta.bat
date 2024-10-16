@echo off

echo Did you change the hostname in the config file? (y/n)
set /p hostname_changed=

if /i "%hostname_changed%" NEQ "y" (
    echo Please change the hostname in the config file before running this script.
    pause
    exit /b
)

echo Adding firewall rule...
timeout /t 2 /nobreak >nul
netsh advfirewall firewall add rule name="Zabbix rule" protocol=TCP dir=in localport=10050-10051 action=allow

echo Changing directory to Zabbix bin directory...
timeout /t 2 /nobreak >nul
cd c:\zabbix\bin

echo Installing Zabbix agent service...
timeout /t 2 /nobreak >nul
zabbix_agentd.exe --config C:\zabbix\conf\zabbix_agentd.win.conf --install

echo Starting Zabbix agent service...
timeout /t 2 /nobreak >nul
zabbix_agentd.exe --start

echo Setting service failure actions...
timeout /t 2 /nobreak >nul
sc failure "Zabbix Agent" reset= 0 actions= restart/60000/restart/60000/""/60000

echo Script executed successfully.
pause