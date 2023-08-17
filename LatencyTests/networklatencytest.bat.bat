@echo off
rem Script to run Ping tests to check network latency to YourTexasBenefits HHSSC site, and my AWS EC2 
rem instances in different regions and local zone.   for testing
rem Code will run 20 pings to each point and summarize the errors and latency
rem Core of the code is from Stack Overflow location
rem https://stackoverflow.com/questions/26969524/network-latency-monitoring-script-windows
setlocal enabledelayedexpansion


set obj[0].Name="yourtexasbenefits.com web site in Winters Data Center (Austin)"
set obj[0].IP="yourtexasbenefits.com" 

set obj[1].Name="EC2 in AWS Dallas LocalZone"
set obj[1].IP="15.181.201.88" 

set obj[2].Name="EC2 in AWS Ohio Region"
set obj[2].IP="18.116.88.241" 

set obj[3].Name="EC2 in AWS Northern Virginia Region"
set obj[3].IP="3.87.189.237" 


for /l %%i in (0,1,3) do (
    call :PingTest !obj[%%i].Name! , !obj[%%i].IP!
)
endlocal
exit /B %ERRORLEVEL%

:PingTest
    echo Running 20 Pings
    echo Target=%~1
    echo IP=%~2
    
    set "pct="
    set "avg="

    rem Run the ping and filter to only read the required lines
    rem The first line will contain the loss percentage
    rem The second line will contain the average roundtrip
    for /f "delims=" %%a in ('
        ping -n 20 %~2 ^| findstr /r /c:"= [0-9]*ms" /c:"([0-9]*%% "
    ') do if not defined pct (

        rem Extract the % loss from the line
        for /f "tokens=2 delims=(%%" %%b in ("%%a") do set "pct=%%b"

    ) else (

        rem Retrieve the last element in the line (the average)
        for %%b in (%%a) do set "avg=%%b"
    )

    rem Remove the ms literal from the average    
    for /f "delims=m" %%a in ("%avg%") do set "avg=%%a"

    rem Echo the retrieved values
   

    echo Percentage Loss=[%pct%] 
    echo Average Latency=[%avg%]
    echo.




exit /B 0








EXIT /B 0


