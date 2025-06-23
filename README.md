# Harbour_EL (Extended Library)


## About this project
This repo takes on from the discontinued Harbour_VFP repo. It to include any functionality that can be used from Web and Desktop applications, and not limited to features equivalent to VFP (Microsoft Visual FoxPro).
This library is to be used with Harbour 64-bit. No support is provided for 32-bit apps.

View [ChangeLog.md](ChangeLog.md) for list of enhancements and fixes.

## Warnings
This library is to be used for 64-bit applications.

The Test folder currently only has one example: hb_el_Test.code-workspace (open with VSCODE)

Please go to https://harbour.wiki for articles, documentation and message board search engine.

## Prerequisites and Installation notes
Python 3.11 64-bit is a requirement since this library will link to CPython. This will allow to run Python functions, and methods from within Harbour applications.   
Currently 3.11 is the most stable version for the CAPI interface.   
View [Python.md](Python.md) for list of Python integration functions.
To view where Python need to be installed, see hb_el.hbc.   
If using a different Python location update the files hb_el.hbc, BuildLIB.bat, BuildLIB.sh, hb_el_windows.hbp, hb_el_linux.hbp, devcontainer.json, Dockerfile. Easiest is to search for "python" case-insensive and update as needed.
Under Windows, the default Python version was build with MSVC. If you are also using MINGW64 you need to port the python .lib files to .a files. Those files are used to bridge into the python.dll or python.so files.   

## Instructions to create Mingw64 compatible Python Library file under Windows
The following instructions are assuming Pyton was installed at c:\Pythons\3_11-64   

- Install MSYS2 from https://www.msys2.org/
- Run "MSYS2 UCRT64 Shell"
- cd /c/Pythons/3_11-64
- gendef python311.dll
- dlltool --dllname python311.dll --def python311.def --output-lib libpython3.11.a
- cp libpython3.11.a /c/Pythons/3_11-64/libs/

## Development Note
When changing the version, update the files hb_el.ch, hb_el.prg (el_GetVersion()).   
For example for calling Python packages, see the sample at https://github.com/EricLendvai/Harbour_Samples/tree/main/HarbourPython   

## Function List
* el_DateTime([nYear],[nMonth],[nDay],[nHour],[nMinute],[nSecond],[nFragment]) - Similar to hb_DateTime but with no milliseconds   
  hb_DateTime([nYear],[nMonth],[nDay],[nHour],[nMinute],[nSecond],[nFragment]) ➔ <tTimeStamp>
Returns a timestamp value from the supplied day, month, year, hour, minute, second values and ignores nfragment. If none of them is supplied, the current date and time is returned.

* el_Seek(xExpression [, nWorkArea | cTableAlias   [, nIndexNumber | cIDXIndexFileName | cTagName]]) -> lFound   

* el_Between(xExpression,xLowValue,xHighValue) -> lResult    
  True if xExpression >= xLowValue and eExpression <= xHighValue   

* el_StrToFile(cExpression,cPathAndFileName,lAdditive) -> nBytesWritten   
  Write the cExpression to file located at cPathAndFileName. Will overwrite the file unless lAdditive is true.   

* el_dbf(nWorkArea | cTableAlias)  -> cTableName   
  Returns the name of a table open in a specified work area or a table name from a table alias. Not the entire file path.   
   
* el_InlistPos(xExpression,xExpression1 ... xExpressionx) -> nPosition   
  nPosition will retun 0 of xExpression is not any of the following expressions, or a value 1 to x to represent which expression is a match.   

* el_IsInlist(xExpression,xExpression1 ... xExpressionx) -> lResult   
  Return true if xExpression is any of the following parameters

* el_StrReplace(cString,cSource|acSource|hReplace,[cDest|acDest]) -> cResult   
  Case insensitive ready version of hb_StrReplace

* el_StrTran(cSearched,cExpressionSought,cReplacement,[nStart],[nCount],[nFlags])   
  If nFlags is -1 the search and replace are case insensitive.

* el_GetProcessID() -> iProcessID   
  Returns a Process ID. Only implemented for MS Windows and Linux

* EL_GetVersion() -> nVersion.  A Numeric with decimals representing the library version number.

* el_SendToDebugView(cMessage,[xValue]) -> .t.    
  Will send to debugview a message cMessage if xValue is missing and cMessage+xValue(converted to text) if xValue is present.

* hb_el_buildinfo() -> Text   
  Returns build information like the C compiler used and a timestamp

* el_AddPs(cPath) -> cPath
 Add trailing Path Separator if missing, as long as cPath is not empty (Equivalent to VFP AddBs())

## Precompiler Instructions
Review hb_el.ch for entire list.   
On of the most practical addition is the "scan / endscan" which was inspired by VFP.

