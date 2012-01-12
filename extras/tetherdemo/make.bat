@echo off
del driver.swf
mtasc -swf Driver.swf -main -header 800:600:20 Driver.as -mx
driver.swf

