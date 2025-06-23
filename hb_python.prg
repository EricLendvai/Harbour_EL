//====================================================================================
function PythonGetSysPath()  // Returns an Array
local l_hSys
local l_hPath
local l_i
local l_nCount
local l_hItem
local l_cPath
local l_aResult := {}

l_hSys  := py_ImportPythonModule( "sys" )
l_hPath := py_GetObjectAttributeValueByName( l_hSys, "path" )
if !Empty( l_hPath ) .and. py_IsPythonList( l_hPath )
    l_nCount := py_GetPythonListSize( l_hPath )
    for l_i := 0 to l_nCount - 1
        l_hItem := py_GetPythonListItem( l_hPath, l_i )
        if py_IsPythonString( l_hItem )
        l_cPath := py_GetPythonStringValue( l_hItem )
        if l_cPath == NIL
            ? "[NULL string]"
        elseif len( l_cPath ) == 0
            ? "[empty string]"
        else
            AAdd(l_aResult,l_cPath)
        endif
        else
        ? "[non-Unicode entry]"
        endif
    endfor
else
    ? "Could not retrieve sys.path"
endif

py_ReleaseVariableUse( l_hPath )
py_ReleaseVariableUse( l_hSys )
return l_aResult
//====================================================================================


// local hSys, hPath, i, count
// local hItem, cPath