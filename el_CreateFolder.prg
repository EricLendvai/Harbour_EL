function el_CreateFolder(par_cFolder)
//par_cFolder must be a complete path, from the root of the drive or Linux file system.

//Harbour already has a hb_DirBuild(), which it is also implemented with Harbour Code, but it does not match the logic below.

local l_cSeparator := hb_ps()
local l_cPath := el_AddPs(par_cFolder)
local l_nSearchPosition
// local l_nPathLength := len(l_cPath)
local l_cProgressivePath

if l_cSeparator == "\"   // Windows
    if substr(l_cPath,2,2) == ":\"  // Local Drive Letter
        if hb_DirExists(left(l_cPath,3))   // Test if the root of the drive letter exists
            l_nSearchPosition := 4
        else
            l_nSearchPosition := 0  // NOT SUPPORTED, in Windows should alway have the drive letter first.
        endif
    elseif left(l_cPath,2) == "\\"  //UNC path.  \\ServerName\ShareName\Path\To\
        l_nSearchPosition := hb_at(l_cSeparator,l_cPath,3)   // Find the end of the ServerName
        if l_nSearchPosition > 0
            l_nSearchPosition := hb_at(l_cSeparator,l_cPath,l_nSearchPosition+1) // Find the end of the ShareName. We can not create them!
            if l_nSearchPosition > 0
                if hb_DirExists(left(l_cPath,l_nSearchPosition))  // Test if the root of the ShareName exists
                    l_nSearchPosition++
                else
                    l_nSearchPosition := 0
                endif
            endif
        endif
    endif
else  //Linux
    if left(l_cPath,1) == l_cSeparator
        l_nSearchPosition := 2
    else
        l_nSearchPosition := 0
    endif
endif

if l_nSearchPosition > 0
// altd()
    l_nSearchPosition := hb_At(l_cSeparator,l_cPath,l_nSearchPosition)
    do while l_nSearchPosition > 0 //.and. l_nSearchPosition <= l_nPathLength
        l_cProgressivePath := left(l_cPath,l_nSearchPosition-1)
        if !hb_DirExists(l_cProgressivePath)
            if hb_DirCreate(l_cProgressivePath) > 0 //Failed to add the folder
                l_nSearchPosition := 0
            endif
        endif
        if l_nSearchPosition > 0
            l_nSearchPosition := hb_At(l_cSeparator,l_cPath,l_nSearchPosition+1)
        endif
    enddo
endif

return hb_DirExists(l_cPath)
