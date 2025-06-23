//Copyright (c) 2025 Eric Lendvai MIT License

request DBFCDX
request DBFFPT
request HB_CODEPAGE_EN

#include "hb_el.ch"
#include "dbinfo.ch"


//=================================================================================================================
Function Main()

local cVal1 := "x"
local cVal2 := "y"
local cVal3 := "z"
local cVal4 := {-1}

?el_CreateFolder("d:\Test001\Test002\Test004")
?el_CreateFolder("d:\Test001\Test002\Test003\Test005")
?

TestPythonIntegration()

?"Process ID: ",el_GetProcessID()

?el_AUnpack({"Hello1",25,"World1",{41,2,1}},,@cVal2,@cVal3,@cVal4)

?"Will suspend"
altd()

?"cVal1",cVal1
?"cVal2",cVal2
?"cVal3",cVal3
?"cVal4[1]",cVal4[1],cVal4[2],cVal4[3]

cVal1 := NIL
cVal2 := NIL
?el_AUnpack(ReturnArray(),@cVal1,@cVal2)

?nvl(1,2)
?nvl(nil,2)
?nvl(nil,nil)

hb_cdpSelect("EN")
set delete on
UpdateSchema()


//Under Linux Docker, may not open the tables in Shared mode. This is a known issue under Docker.
if .f. .and. OpenTable("client" ,.f.,.f.) .and.;
OpenTable("invoice",.f.,.f.) .and.;
OpenTable("item"   ,.f.,.f.)

    ?"Test---------------------------------------------------------------------------------"
    ?el_dbf("client")

    if client->(reccount()) == 0  //Only add records if none are present
        if client->(dbappend())
            client->name :="Marie Curie"
            client->(dbRUnlock())

            if invoice->(dbappend())
                invoice->p_client := client->key
                invoice->number   := "00001"
                invoice->(dbRUnlock())

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 10
                    item->desc      := "tables"
                    item->(dbRUnlock())
                endif

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 40
                    item->desc      := "chairs"
                    item->(dbRUnlock())
                endif

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 5
                    item->desc      := "carpets"
                    item->(dbRUnlock())
                endif
            endif

            if invoice->(dbappend())
                invoice->p_client := client->key
                invoice->number   := "00002"
                invoice->(dbRUnlock())

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 1
                    item->desc      := "Monitor"
                    item->(dbRUnlock())
                endif

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 2
                    item->desc      := "Monitors"
                    item->(dbRUnlock())
                endif

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 1
                    item->desc      := "Printer"
                    item->(dbRUnlock())
                endif
            endif

            if invoice->(dbappend())
                invoice->p_client := client->key
                invoice->number   := "00003"
                invoice->(dbRUnlock())

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 22
                    item->desc      := "Hamers"
                    item->(dbRUnlock())
                endif

            endif

        endif

        if client->(dbappend())
            client->name :="Albert Einstein"
            client->(dbRUnlock())

            if invoice->(dbappend())
                invoice->p_client := client->key
                invoice->number   := "00151"
                invoice->(dbRUnlock())

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 2
                    item->desc      := "cups"
                    item->(dbRUnlock())
                endif

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 1
                    item->desc      := "bottle"
                    item->(dbRUnlock())
                endif

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 3
                    item->desc      := "forks"
                    item->(dbRUnlock())
                endif
            endif


            if invoice->(dbappend())
                invoice->p_client := client->key
                invoice->number   := "00202"
                invoice->(dbRUnlock())

                if item->(dbappend())
                    item->p_invoice := invoice->key
                    item->qty       := 6
                    item->desc      := "spoons"
                    item->(dbRUnlock())
                endif

            endif

        endif

    endif

?"Will call el_Seek"
?el_Seek("00202","invoice","number")

    client->(ordSetFocus("tag1"))
    invoice->(ordSetFocus("number"))
    item->(ordSetFocus("key"))

    //The SCAN ... ENDSCAN commands behaves as documented in https://harbour.wiki/index.asp?page=ShowVFPHelp&ID=3741
    //One of the most important features of the SCAN command is that the workarea is always reset to the one before entering the loop.
    //The LOOP command will execute the closest SCAN command.
    //The EXIT command will exit the most inner SCAN ... ENDSCAN and not reset the workarea.

    select client
    scan all
        ?"Client: "+Trim(client->name)
        select invoice
        scan all for invoice->p_client == client->key
            ?"  Invoice #: "+Trim(invoice->number)
            select item
            scan all for item->p_invoice == invoice->key
                if item->qty > 30
                    select client  //This line will have no effect, since the "scan" will be executed, the workarea with switch back to "item"
                    loop
                endif
                ?"    Item Qty/Description: "+Ltrim(str(item->qty))+" - "+Trim(item->desc)
            endscan
        endscan
    endscan

//The 3 SCAN ... ENDSCAN loops will output the following:
//Client: Albert Einstein
//  Invoice #: 00151
//    Item Qty/Description: 2 - cups
//    Item Qty/Description: 1 - bottle
//    Item Qty/Description: 3 - forks
//  Invoice #: 00202
//    Item Qty/Description: 6 - spoons
//Client: Marie Curie
//  Invoice #: 00001
//    Item Qty/Description: 10 - tables
//    Item Qty/Description: 5 - carpets
//  Invoice #: 00002
//    Item Qty/Description: 1 - Monitor
//    Item Qty/Description: 2 - Monitors
//    Item Qty/Description: 1 - Printer
//  Invoice #: 00003
//    Item Qty/Description: 22 - Hamers

endif

(select("client"))->(dbCloseArea())
(select("invoice"))->(dbCloseArea())
(select("item"))->(dbCloseArea())


return nil
//=================================================================================================================
static function ReturnArray()
return {"","Hello"}
//=================================================================================================================
//=================================================================================================================
function TestPythonIntegration()

local l_cPythonInstallPath := "C:\Pythons\3_11-64"     // Download Python 3.11 from https://www.python.org/downloads/. Update this path to your own install location
// local l_cPythonDllFile     := "python311.dll"
// local l_iCounter
local l_aPath
local l_cPath

if hb_osIsWin7()  // Will also be valid for any versions after 7
    hb_SetEnv("PYTHONHOME",l_cPythonInstallPath)      // Only needed in Windows.
endif

Py_Initialize()


l_aPath := PythonGetSysPath()
for each l_cPath in l_aPath
    ?l_cPath
endfor



Py_Finalize()

return nil