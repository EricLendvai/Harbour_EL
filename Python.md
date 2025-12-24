# Harbour Python Integration functions
Note: Harbour functions, even user defined function are case insensitive.   

## Py_Initialize()
**Purpose**: Initializes the embedded Python interpreter (cPython). Call this once before any other Python operations.   
**Returns**: Nothing.   

## Py_Finalize()
**Purpose**: Finalizes the Python interpreter. Call this when you're done using Python.   
**Returns**: Nothing.   

## Py_GetLastErrorText()
**Purpose**: Fetches the last Python exception and returns it as a string.   
**Returns**: The last Python error message as a UTF08 string (if any).   

## py_CreatePythonFloat(nValue)
**Purpose**: Create a new Python Float (Object) from a Harbour numeric.   
**Parameters**:
- nValue: Number value   

**Returns**: pPyObject   
**Note**: To avoid memory leaks, you must release the variable.   

## py_CreatePythonInteger(nValue)
**Purpose**: Create a new Python Integer (Object) from a Harbour numeric (integer).   
**Parameters**:
- nValue: Number (integer) value   

**Returns**: pPyObject   
**Note**: To avoid memory leaks, you must release the variable.   

## py_GetPythonFloatValue(pPyObject)
**Purpose**: Get the Harbour numeric value from a Python float object.   
**Parameters**:    
- pPyObject: Python float object   

**Returns**: Harbour numeric value.

## py_CreatePythonString(cText)
**Purpose**: Create a new Python String (Object) from a Harbour UTF string.   
**Parameters**:
- cText: String value (Harbour Text, which is already UTF)   

**Returns**: pPyObject   

## py_GetPythonStringValue(pPyObject)
**Purpose**: Get the Harbour String value from a Python string object (UTF-8 encoded).  
**Parameters**:    
- pPyObject: Python string object   

**Returns**: cString (Harbour Strings are UTF8)

## py_IsPythonString
**Purpose**: Checks whether the given Python object is a string (Unicode).   
**Parameters**:   
- pObj: A pointer to any Python object.   

**Returns**: lIsUnicode, .T. if it's a Unicode string (str in Python 3), .F. otherwise.

## py_CreatePythonList(nSize)
**Purpose**: Creates a new Python list of the given size.   
**Returns**: pPyObject   

## py_SetPythonListItem(pList, nIndex, pItem)
**Purpose**: Sets an item in a Python list at the specified index.
**Parameters**:   
- pList: Python list object. It must already be created with enough space to hold an element at index.   
- nIndex: The index in the list to set. Must be in the range 0 <= index < PyList_Size(list).   
- pItem: The new item to put at position index. Can be NULL, in which case it sets a None value (but use with caution).   

**Returns**: Nothing.

PyList_SetItem() "steals" a reference to item.   
- You should not Py_INCREF(item) before passing it in.
- Do not call Py_DecRef() on it afterward.
- If replacing an existing item, Python will handle Py_DecRef() for the old value.

## py_GetPythonListItem( pPyObject, nIndex )
**Purpose**: Returns a pointer to the item at the given nIndex in a Python list.   
**Parameters**:   
- pPyObject: A pointer to a Python list object.   
- nIndex: The 0-based index of the element to retrieve.   

**Returns**: pPyObject, a pointer to the Python object at that position, or NIL if the input is invalid or the index is out of bounds.   

**Note**: This returns a borrowed reference. Do not Py_DecRef() it directly.  

## py_IsPythonList( pPyObject )
**Purpose**: Checks whether the given Python object is a list.   
**Parameters**:   
- pPyObject: A pointer to any Python object.   

**Returns**: lIsList, .T. if it's a list, .F. otherwise.

## py_GetPythonListSize( pPyObject )
**Purpose**: Returns the number of elements in a Python list.
**Parameters:**    
- pPyObject: A pointer to a Python list object.   

**Returns**: nSize, the list size as a Harbour integer (0 if input is invalid or not a list).   

## Py_ReleaseVariableUse(pPyObject)
**Purpose**: Decrease the reference count of a PyObject *. This is crucial for memory management because CPython uses reference counting to determine when to free an object. Call Py_DecRef(pPyObject) when you're done using a PyObject * that: You own a reference to, and no longer need to keep it alive.   
**Parameters:**    
- pPyObject: A pointer to a Python variable object. if pPyObject is passed by reference it will be set to NULL.

**Returns**: Nothing.   

## py_ImportPythonModule(cModuleName)
**Purpose**: Imports a Python module by name.   
**Parameters**:   
- cModuleName: Name of module (e.g. "math"). The module can be a local folder with a ```__init__.py``` file.   

**Returns**: Pointer to PyObject*.   

## py_GetObjectAttributeValueByName(pPyObject, cAttributeName)
**Purpose**: Gets an attribute value from a Python object by name.   
**Parameters**:   
- pPyObject: PyObject pointer   
- cAttributeName: Attribute name   

**Returns**: pPyObject (attribute value or NULL)   

## py_CallFunction(pFunction,[..])
**Purpose**: Calls a Python user created function with up to 12 arguments.   
**Parameters**:   
- pFunction: reference to a Python function   
- 0 to maximum 12 arguments   

**Returns**: PyObject* (return value of function call)   

## py_CallMethod(pObj,cMethodName,[..])
**Purpose**: Calls a named method of a Python object.   
**Parameters**:   
- pObj: Python object   
- cMethodName: Name of method   

**Returns**: PyObject*

## py_ErrorOccurred()
**Purpose**: Checks if a Python error has occurred.   
**Returns**: .T. if error occurred, .F. if no error exists.   

## py_PrintLastError()
**Purpose**: Prints the last Python error (if any) to stderr (useful for debugging).   
**Returns**: Nothing.   

## py_GetType(pObj)
**Purpose**: Get the Python type name of a Python object.   
**Returns**: String. Could be "null".   
