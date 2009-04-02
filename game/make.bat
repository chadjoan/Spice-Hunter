@echo off
a3 src\stable\SpiceHunter.as -outputtemp -default-frame-rate=200 -debug=true
IF errorlevel 1 pause
