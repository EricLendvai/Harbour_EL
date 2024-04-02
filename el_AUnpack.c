//Copyright (c) 2024 Eric Lendvai, MIT License unless specified otherwise

#include "hbapi.h"
#include "hbapiitm.h"

//Made a merge request into harbour and named the function HB_AUNPACK.  2021-02-14  #232

//A different method would be to use the following suggested in the #233 thread:
// #xcommand UNPACK <x1>[, <xN>] := <exp> => hb_ExecFromArray( {| _unpack_<x1>[, _unpack_<xN> ] | <x1> := _unpack_<x1>[, <xN> := _unpack_<xN>] }, <exp> )
// #xcommand UNPACK <x1>[, <xN>] REST <rest> := <exp> => hb_ExecFromArray( {| _unpack_<x1>[, _unpack_<xN> ], ... | <x1> := _unpack_<x1>[, <xN> := _unpack_<xN>], <rest> := { ... } }, <exp> )

HB_FUNC( EL_AUNPACK )
{
    PHB_ITEM pArray = hb_param( 1, HB_IT_ARRAY );
    if( pArray )
    {
        HB_USHORT uiLen = ( HB_USHORT ) hb_arrayLen(pArray);
        HB_USHORT uiIter;
        HB_USHORT uiArgCount = ( HB_USHORT ) hb_pcount();

        for( uiIter = 1; uiIter <= HB_MIN(uiLen,uiArgCount-1); uiIter++ )
        {
            if ( HB_ISBYREF( uiIter+1 ) )
            {
                PHB_ITEM pArrayElement = hb_itemNew( NULL );
                hb_arrayGet( pArray, (HB_ULONG) uiIter, pArrayElement ) ;
                hb_itemParamStore( uiIter+1, pArrayElement );
                hb_itemRelease( pArrayElement );
            }
            if ( uiIter == 1 )
            {
                PHB_ITEM pFirstArrayElement = hb_itemNew( NULL );
                hb_arrayGet( pArray, (HB_ULONG) uiIter, pFirstArrayElement ) ;
                hb_itemReturn( pFirstArrayElement );
            }
        }
    }
}
//=================================================================================================================
