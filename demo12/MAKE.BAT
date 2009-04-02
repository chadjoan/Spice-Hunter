@echo off
mtasc -swf Driver.swf -main -header 800:650:60 Driver.as -mx
IF errorlevel 1 pause