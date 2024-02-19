# Harbour Extended Library - Change Log

## 02/19/2024 v 4.0
* This is a fork from the Harbour_VFP repo. It will not be restricted to add VFP support to Harbour, but have any features that can be used in Web and Desktop applications. Some of the features are inspired from VFP. Most of the other repos in the Eric Lendvai Github account,depend on this library.

The following is the list of Harbour_VFP functions renamed to Harbour_EL functions:

* VFP_DATETIME     ->  EL_DATETIME
* VFP_SEEK         ->  EL_SEEK
* VFP_BETWEEN      ->  EL_BETWEEN
* VFP_StrToFile    ->  EL_StrToFile
* VFP_dbf          ->  EL_dbf
* VFP_INLIST       ->  EL_IsInlist
* EL_INLIST        ->  EL_InlistPos
* VFP_STRREPLACE   -> EL_STRREPLACE
* VFP_STRTRAN      -> EL_STRTRAN
* HB_VFP_ROOT      -> HB_EL_ROOT
* hb_vfp_buildinfo -> hb_el_buildinfo
* VFP_GetCompatibilityPackVersion -> EL_GetVersion
* hb_vfp_SendToDebugView -> hb_el_SendToDebugView
