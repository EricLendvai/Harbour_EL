//=================================================================================================================
function el_UTCOffsetMinToText(par_nUTCOffset)
local l_cUTCOffset
if par_nUTCOffset <= 0
    l_cUTCOffset := "+"+strtran(str(int(-par_nUTCOffset/60),2)+":"+str(mod(-par_nUTCOffset,60),2)," ","0")
else
    l_cUTCOffset := "-"+strtran(str(int(par_nUTCOffset/60),2)+":"+str(mod(par_nUTCOffset,60),2)," ","0")
endif
return l_cUTCOffset
//=================================================================================================================
