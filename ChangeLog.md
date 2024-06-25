# Harbour Extended Library - Change Log

## 06/23/2024 v 4.4
* Added el_UTCOffsetMinToText(<Minute>) -> text. For example el_UTCOffsetMinToText(420) will return "-07:00".   
  Can be used when querying PostgreSQL timestamp with time zone fields with "AT TIME ZONE '-07:00'".   

## 04/02/2024 v 4.3
* Added precompiler constants CR and LF

## 03/25/2024 v 4.2
* Added documentation in README.md.
* el_dbf() now requires its parameter, and will return a blank string if the alias does not exists.
* Added el_AddPs(cPath) -> cPath   
  Add trailing Path Separator if missing, as long as cPath is not empty (Equivalent to VFP AddBs())   

## 02/19/2024 v 4.1
* Renamed hb_el_SendToDebugView to el_SendToDebugView

## 02/19/2024 v 4.0
* This is a fork from the Harbour_VFP repo. It will not be restricted to add VFP support to Harbour, but have any features that can be used in Web and Desktop applications. Some of the features are inspired from VFP. Most of the other repos in the Eric Lendvai Github account,depend on this library.

The following is the list of Harbour_VFP functions renamed to Harbour_EL functions:

* VFP_DATETIME     -> EL_DATETIME
* VFP_SEEK         -> EL_SEEK
* VFP_BETWEEN      -> EL_BETWEEN
* VFP_StrToFile    -> EL_StrToFile
* VFP_dbf          -> EL_dbf
* EL_INLIST        -> EL_InlistPos
* VFP_INLIST       -> EL_IsInlist
* VFP_STRREPLACE   -> EL_STRREPLACE
* VFP_STRTRAN      -> EL_STRTRAN
* HB_VFP_ROOT      -> HB_EL_ROOT
* hb_vfp_buildinfo -> hb_el_buildinfo
* VFP_GetCompatibilityPackVersion -> EL_GetVersion
* hb_vfp_SendToDebugView          -> hb_el_SendToDebugView
