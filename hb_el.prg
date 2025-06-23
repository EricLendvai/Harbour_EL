//Copyright (c) 2025 Eric Lendvai, MIT License

#include "fileio.ch"
#include "dbinfo.ch"

// #define DEVELOPMENTMODE
// #ifdef DEVELOPMENTMODE
// #endif

//=================================================================================================================
function hb_el_buildinfo()
#include "BuildInfo.txt"
return l_cBuildInfo
//=================================================================================================================
// function  hb_el_SendToClipboard(cText)   //_CLIPTEXT = 
//     wvt_SetClipboard(cText)
// return .T.
//=================================================================================================================
//The el_ScanStack is to be used in conjuntion with the "#command SCAN" and "#command ENDSCAN"
function el_ScanStack(par_action)    //action = "push" "pop" "scan" , "clear" (empty the entire stack)
local l_xResult := nil
static iTop   := 0
static aStack := {}     //Will hold an array [WorkArea,.t. if first loop]

hb_default( @par_action, "scan" )

switch par_action
    case "push"
        iTop++
        if len(aStack) < iTop
            ASize( aStack, iTop )
        endif
        aStack[iTop] := {select(),.t.} // Record the current work area and flag to know during "scan" calls if they are going to be the initial "locate" or should be "continue"
        l_xResult := nil
        exit
    case "pop"
        iTop--
        //No need to reduce the size of aStack since will most likely be increased again
        exit
    case "clear"
        iTop   := 0
        ASize( aStack, 0 )
        exit
    otherwise
        select (aStack[iTop,1])
        l_xResult := aStack[iTop,2]
        aStack[iTop,2] := .f.
        exit
endswitch

return l_xResult
//=================================================================================================================
function el_StrToFile(par_cExpression,par_cFileName,par_lAdditive)   //Partial implementation of VFP9's STRTOFILE(). The 3rd parameter only supports a logical

local l_lAdditive
local l_nBytesWritten := 0
local l_nFileHandle

l_lAdditive := hb_defaultValue(par_lAdditive,.f.)

if hb_FileExists(par_cFileName)
    if l_lAdditive
        l_nFileHandle := FOpen(par_cFileName,FO_WRITE)
        FSeek(l_nFileHandle,0,FS_END)  // go to the end of file
    else
        if ferase(par_cFileName) == 0
            l_nFileHandle := FCreate(par_cFileName)
        else
            l_nFileHandle := -1
        endif
    endif
else
    l_nFileHandle := FCreate(par_cFileName)
endif

if l_nFileHandle >= 0
    l_nBytesWritten := fwrite(l_nFileHandle,par_cExpression)
    fclose(l_nFileHandle)
endif

return l_nBytesWritten
//=================================================================================================================
function el_dbf(par_xalias)
local l_cResult
//Sadly will only return the file name, not the fullpath

//Notes for future solution to get the file name with the path
//Following Will return the file handle instead
// el_SendToDebugView("Table File Handle",(par_xalias)->(DbInfo(DBI_FILEHANDLE)))
// See https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfinalpathnamebyhandlea
// See https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfinalpathnamebyhandlew
// See c:\harbour\src\rtl\fslink.c for example code for Windows api call

if ((select( par_xalias ) > 0))
    l_cResult := (par_xalias)->(DbInfo(DBI_FULLPATH))   //Does not include the fullpath!
else
    l_cResult := ""
endif

return l_cResult
//=================================================================================================================
function el_AddPs(par_cPath)   // Add conditionally Path Separator (Equivalent to VFP AddBs())
local l_cPath := par_cPath
local l_cPs

if !empty(l_cPath)
    l_cPs := hb_ps()
    if !(right(l_cPath,1) == l_cPs)
        l_cPath += l_cPs
    endif
endif

return l_cPath
//=================================================================================================================
function el_DiskSizeInScale(par_iDriveTotalSizeB)
local l_nDriveTotalSize
local l_cSizeInScale

l_nDriveTotalSize := par_iDriveTotalSizeB / (1024*1024*1024*1024)
if l_nDriveTotalSize >= 1
    l_cSizeInScale := alltrim(str(round(l_nDriveTotalSize,2)))+" TB"
else
    l_nDriveTotalSize := par_iDriveTotalSizeB / (1024*1024*1024)
    if l_nDriveTotalSize >= 1
        l_cSizeInScale := alltrim(str(round(l_nDriveTotalSize,2)))+" GB"
    else
        l_nDriveTotalSize := par_iDriveTotalSizeB / (1024*1024)
        if l_nDriveTotalSize >= 1
            l_cSizeInScale := alltrim(str(round(l_nDriveTotalSize,2)))+" MB"
        else
            l_nDriveTotalSize := par_iDriveTotalSizeB / (1024)
            if l_nDriveTotalSize >= 1
                l_cSizeInScale := alltrim(str(round(l_nDriveTotalSize,2)))+" KB"
            else
                l_cSizeInScale := alltrim(str(l_nDriveTotalSize))+" B"
            endif
        endif
    endif
endif

return l_cSizeInScale
//=================================================================================================================
function el_occurs(par_cSearchFor,par_cSearchIn,par_lCaseInsensitive)
local l_nCount := 0
local l_nPos := 1
local l_lCaseInsensitive := hb_DefaultValue(par_lCaseInsensitive,.f.)

if l_lCaseInsensitive // The code is a little redundant but the fastest
    do while (l_nPos := hb_AtI(par_cSearchFor, par_cSearchIn,l_nPos)) > 0
        l_nCount++
        l_nPos++
    enddo
else
    do while (l_nPos := hb_At(par_cSearchFor, par_cSearchIn,l_nPos)) > 0
        l_nCount++
        l_nPos++
    enddo
endif

return l_nCount
//=================================================================================================================
function el_SendToDebugView(par_cStep,par_xValue)
local l_cTypeOfxValue
local l_cValue := "Unknown Value"

l_cTypeOfxValue := ValType(par_xValue)

do case
case pcount() < 2
    l_cValue := ""
case l_cTypeOfxValue $ "AH" // Array or Hash
    l_cValue := hb_ValToExp(par_xValue)
case l_cTypeOfxValue == "B" // Block
    //Not coded yet
case l_cTypeOfxValue == "C" // Character (string)
    l_cValue := par_xValue
    //Not coded yet
case l_cTypeOfxValue == "D" // Date
    l_cValue := DTOC(par_xValue)
case l_cTypeOfxValue == "L" // Logical
    l_cValue := IIF(par_xValue,"True","False")
case l_cTypeOfxValue == "M" // Memo
    //Not coded yet
case l_cTypeOfxValue == "N" // Numeric
    l_cValue := alltrim(str(par_xValue))
case l_cTypeOfxValue == "O" // Object
    //Not coded yet
case l_cTypeOfxValue == "P" // Pointer
    //Not coded yet
case l_cTypeOfxValue == "S" // Symbol
    //Not coded yet
case l_cTypeOfxValue == "U" // NIL
    l_cValue := "Null"
endcase

if empty(l_cValue)
    hb_el_OutputDebugString("[Harbour] EL "+par_cStep)
else
    hb_el_OutputDebugString("[Harbour] EL "+par_cStep+" - "+l_cValue)
endif

return .T.
//=================================================================================================================
