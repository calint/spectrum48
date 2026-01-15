set PASMO_HOME=..\pasmo-0.5.3
set FUSE_HOME=..\fuse

cd resources
call update.bat
cd ..
%PASMO_HOME%\pasmo -I src --alocal --tapbas src/main.asm main.tap
%FUSE_HOME%\fuse main.tap
