@echo off

r:
cd \Harbour_EL
SET LIBName=hb_el
SET BuildMode=release
SET HB_COMPILER=mingw64
SET SUCCESS=F
CALL BuildLib.bat
if %SUCCESS% == F (
    echo Failed To build Library %BuildMode%  %HB_COMPILER%
    pause
    goto exit
)

r:
cd \Harbour_EL
SET LIBName=hb_el
SET BuildMode=debug
SET HB_COMPILER=mingw64
SET SUCCESS=F
CALL BuildLib.bat
if %SUCCESS% == F (
    echo Failed To build Library %BuildMode%  %HB_COMPILER%
    pause
    goto exit
)

r:
cd \Harbour_EL
SET LIBName=hb_el
SET BuildMode=release
SET HB_COMPILER=msvc64
SET SUCCESS=F
CALL BuildLib.bat
if %SUCCESS% == F (
    echo Failed To build Library %BuildMode%  %HB_COMPILER%
    pause
    goto exit
)

r:
cd \Harbour_EL
SET LIBName=hb_el
SET BuildMode=debug
SET HB_COMPILER=msvc64
SET SUCCESS=F
CALL BuildLib.bat
if %SUCCESS% == F (
    echo Failed To build Library %BuildMode%  %HB_COMPILER%
    pause
    goto exit
)

r:
cd \Harbour_EL
del *.ppo

:exit
