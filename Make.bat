@ECHO OFF
CD /D %~dp0

:: Look for installed MinGW.

PATH %PATH%;^
C:\MinGW\bin;^
C:\"Program Files"\CodeBlocks\MinGW\bin;^
C:\"Program Files (x86)"\CodeBlocks\MinGW\bin

:: The alternative commands on Windows.

SET CC=gcc
SET DIFF=fc
SET RM=del

:: Make

mingw32-make %*
IF NOT ERRORLEVEL 1 ECHO [Done]
PAUSE

