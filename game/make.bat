@echo off
a3 src\SpiceHunter.as -outputtemp -default-frame-rate=30 -compiler.optimize -compiler.include-libraries swfs/pixeldroid.swc -use-network=false -compiler.debug
IF errorlevel 1 pause
