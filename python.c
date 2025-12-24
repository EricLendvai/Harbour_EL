// Some of the source code came originaly from https://github.com/FiveTechSoft/harbour_python
// Added new functions and minor changes.

// https://docs.python.org/3/c-api/unicode.html

#include <hbapi.h>
#include <hbapiitm.h>
#include <Python.h>

HB_FUNC( PY_INITIALIZE )   // Initializes the embedded Python interpreter (cPython). Call this once before any other Python operations.
{
   Py_Initialize();
}

HB_FUNC( PY_FINALIZE )   // Finalizes the Python interpreter. Call this when you're done using Python.
{
   Py_Finalize();
   // _M_ inhance this by using Py_FinalizeEx() -> int status code
}

HB_FUNC( PY_GETLASTERRORTEXT )   // Fetches the last Python exception and returns it as a string.
{
   PyObject * type, * value, * traceback;
   PyErr_Fetch( &type, &value, &traceback );

   if( value ) 
   {
      void * str_exc = PyObject_Str(value);
      const char * c_str_exc = PyUnicode_AsUTF8(str_exc);
      hb_retc( c_str_exc );
    }
}

HB_FUNC( PY_CREATEPYTHONFLOAT )   // Create a new Python Float (Object) from a Harbour numeric.
{
   hb_retptr( PyFloat_FromDouble( hb_parnd( 1 ) ) );

   // https://docs.python.org/3/c-api/float.html
   // PyObject *PyFloat_FromDouble(double v)
   //  Return value: New reference. Part of the Stable ABI.
   //  Create a PyFloatObject object from v, or NULL on failure.

}

HB_FUNC( PY_CREATEPYTHONINTEGER )   // Create a new Python Integer (Object) from a Harbour numeric (integer).
{
   int nValue = hb_parni(1);
   hb_retptr( PyLong_FromLong( (long) nValue ) );
}

HB_FUNC( PY_GETPYTHONFLOATVALUE )   // Get the Harbour numeric value from a Python float object.
{

   //https://docs.python.org/3/c-api/float.html
   // double PyFloat_AsDouble(PyObject *pyfloat)
   //    Part of the Stable ABI.
   //    Return a C double representation of the contents of pyfloat. If pyfloat is not a Python floating point object but has a __float__() method, this method will first be called to convert pyfloat into a float. If __float__() is not defined then it falls back to __index__(). This method returns -1.0 upon failure, so one should call PyErr_Occurred() to check for errors.
   //    Changed in version 3.8: Use __index__() if available.

   hb_retnd( PyFloat_AsDouble( hb_parptr( 1 ) ) );   
}

HB_FUNC( PY_CREATEPYTHONSTRING )   // Create a new Python String (Object) from a Harbour UTF string.
{
   hb_retptr( PyUnicode_FromString( hb_parc( 1 ) ) );
}

HB_FUNC( PY_GETPYTHONSTRINGVALUE )
{

   //https://docs.python.org/3/c-api/unicode.html
   // PyObject *PyUnicode_AsUTF8String(PyObject *unicode)
   //    Return value: New reference. Part of the Stable ABI.
   //    Encode a Unicode object using UTF-8 and return the result as Python bytes object. Error handling is “strict”. Return NULL if an exception was raised by the codec.

   PyObject *pStr = ( PyObject * ) hb_parptr( 1 );
   if( pStr && PyUnicode_Check( pStr ) )
   {
      const char *cStr = PyUnicode_AsUTF8( pStr );
      hb_retc( cStr ? cStr : "" );
   }
   else
   {
      hb_retc( "" );
   }
}

HB_FUNC( PY_ISPYTHONSTRING )   // Checks whether the given Python object is a string (Unicode).
{
   PyObject * obj = ( PyObject * ) hb_parptr( 1 );

   if( obj && PyUnicode_Check( obj ) )
      hb_retl( 1 );
   else
      hb_retl( 0 );
}

HB_FUNC( PY_CREATEPYTHONLIST )   // Creates a new Python list of the given size.
{
   hb_retptr( PyList_New( hb_parni( 1 ) ) );
}

HB_FUNC( PY_SETPYTHONLISTITEM )   // Sets an item in a Python list at the specified index.
{
   PyList_SetItem( hb_parptr( 1 ), hb_parni( 2 ), hb_parptr( 3 ) );
}

HB_FUNC( PY_GETPYTHONLISTITEM )   // Returns a pointer to the item at the given nIndex in a Python list.
{
   PyObject *pList = ( PyObject * ) hb_parptr( 1 );
   Py_ssize_t index = ( Py_ssize_t ) hb_parnint( 2 );
   if( pList && PyList_Check( pList ) )
   {
      hb_retptr( PyList_GetItem( pList, index ) );
   }
   else
   {
      hb_retptr( NULL );
   }
}

HB_FUNC( PY_ISPYTHONLIST )   // Checks whether the given Python object is a list.
{
   PyObject * obj = ( PyObject * ) hb_parptr( 1 );

   if( obj && PyList_Check( obj ) )
      hb_retl( 1 );
   else
      hb_retl( 0 );
}


HB_FUNC( PY_GETPYTHONLISTSIZE )   // Returns the number of elements in a Python list.
{
   PyObject *pList = ( PyObject * ) hb_parptr( 1 );
   if( pList && PyList_Check( pList ) )
   {
      hb_retni( ( int ) PyList_Size( pList ) );
   }
   else
   {
      hb_retni( 0 );
   }
}

HB_FUNC( PY_RELEASEVARIABLEUSE )   // Release Python Variable Reference.
{
   if (hb_pcount() >= 1) {
      Py_XDECREF( hb_parptr( 1 ) );
      if (hb_parinfo(1) & HB_IT_BYREF)
      {
         PHB_ITEM pItem = hb_param( 1, HB_IT_BYREF );
         if( pItem )
            hb_itemClear( pItem );
      }
   }
}

HB_FUNC( PY_IMPORTPYTHONMODULE )
{
   hb_retptr( PyImport_ImportModule( hb_parc( 1 ) ) );
}

HB_FUNC( PY_GETOBJECTATTRIBUTEVALUEBYNAME )
{
   hb_retptr( PyObject_GetAttrString( hb_parptr( 1 ), hb_parc( 2 ) ) );
   //https://docs.python.org/3/c-api/object.html
   //PyObject *PyObject_GetAttrString(PyObject *o, const char *attr_name)
   //  Return value: New reference. Part of the Stable ABI.
   //  Retrieve an attribute named attr_name from object o. Returns the attribute value on success, or NULL on failure. This is the equivalent of the Python expression o.attr_name.

}




//----------------------------------------------------------------------------------------------------------------------------------------------------







HB_FUNC( PY_CALLFUNCTION )   // Calls a Python user created function with up to 12 arguments.
{
   //https://docs.python.org/3/c-api/call.html#c.PyObject_CallFunctionObjArgs
   // Call a callable Python object callable, with a variable number of PyObject* arguments. The arguments are provided as a variable number of parameters followed by NULL.
   // Return the result of the call on success, or raise an exception and return NULL on failure.
   // This is the equivalent of the Python expression: callable(arg1, arg2, ...).

   switch( hb_pcount() )
   {
      case 1:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1), NULL ) );
         break;
      case 2:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2), NULL ) );
         break;
      case 3:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3), NULL ) );
         break;
      case 4:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4), NULL ) );
         break;
      case 5:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5), NULL ) );
         break;
      case 6:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),NULL) );
         break;
      case 7:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),NULL) );
         break;
      case 8:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),NULL) );
         break;
      case 9:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),NULL) );
         break;
      case 10:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10),NULL) );
         break;
      case 11:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10),hb_parptr(11),NULL) );
         break;
      case 12:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10),hb_parptr(11),hb_parptr(12),NULL) );
         break;
      case 13:
         hb_retptr( PyObject_CallFunctionObjArgs(hb_parptr(1),hb_parptr(2),hb_parptr(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10),hb_parptr(11),hb_parptr(12),hb_parptr(13),NULL) );
         break;
      default:
         // generate error reporting increase this switch
         break;   
   }
}

HB_FUNC( PY_CALLMETHOD )   // Calls a named method of a Python object.
{
   //https://docs.python.org/3/c-api/call.html#c.PyObject_CallFunctionObjArgs

   // PyObject *PyObject_CallMethod(PyObject *obj, const char *name, const char *format, ...)
   //    Return value: New reference. Part of the Stable ABI.
   //    Call the method named name of object obj with a variable number of C arguments. The C arguments are described by a Py_BuildValue() format string that should produce a tuple.
   //    The format can be NULL, indicating that no arguments are provided.
   //    Return the result of the call on success, or raise an exception and return NULL on failure.
   //    This is the equivalent of the Python expression: obj.name(arg1, arg2, ...).
   //    Note that if you only pass PyObject* args, PyObject_CallMethodObjArgs() is a faster alternative.
   //    Changed in version 3.4: The types of name and format were changed from char *.

   switch( hb_pcount() )
   {
      case 2:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2), NULL ) );
         break;
      case 3:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parptr(3), NULL ) );
         break;
      case 4:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4), NULL ) );
         break;
      case 5:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5), NULL ) );
         break;
      case 6:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6), NULL ) );
         break;
      case 7:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7), NULL ) );
         break;
      case 8:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8), NULL ) );
         break;
      case 9:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9), NULL ) );
         break;
      case 10:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10), NULL ) );
         break;
      case 11:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10),hb_parptr(11), NULL ) );
         break;
      case 12:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10),hb_parptr(11),hb_parptr(12), NULL ) );
         break;
      case 13:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10),hb_parptr(11),hb_parptr(12),hb_parptr(13), NULL ) );
         break;
      case 14:
         hb_retptr( PyObject_CallMethod(hb_parptr(1),hb_parc(2),hb_parc(3),hb_parptr(4),hb_parptr(5),hb_parptr(6),hb_parptr(7),hb_parptr(8),hb_parptr(9),hb_parptr(10),hb_parptr(11),hb_parptr(12),hb_parptr(13),hb_parptr(14), NULL ) );
         break;
      default:
         // generate error reporting increase this switch
         break;   
   }
}

HB_FUNC( PY_ERROROCCURRED )   // Checks if a Python error has occurred.
{
   hb_retl( PyErr_Occurred() != NULL );
}

HB_FUNC( PY_PRINTLASTERROR )   // Prints the last Python error (if any) to stderr (useful for debugging).
{
   PyErr_Print();
}

HB_FUNC( PY_GETTYPE )     // Get the type of a Python pointer.
{
    PyObject * pObj = (PyObject *) hb_parptr( 1 );

    if( pObj && Py_TYPE( pObj ) && Py_TYPE( pObj )->tp_name )
        hb_retc( Py_TYPE( pObj )->tp_name );
    else
        hb_retc( "null" );
}
