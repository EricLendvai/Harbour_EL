#!/bin/bash

echo "BuildMode = ${BuildMode}"

if [ -z "${LIBName}" ]; then
    echo "Missing Environment Variables LIBName"
elif [ -z "${BuildMode}" ]; then
    echo "Missing Environment Variables BuildMode"
elif [ -z "${HB_COMPILER}" ]; then
    echo "Missing Environment Variables HB_COMPILER"
elif [ "${BuildMode}" != "debug" ] && [ "${BuildMode}" != "release" ] ; then
    echo "You must set Environment Variable BuildMode as \"debug\" or \"release\""
elif [ "${HB_COMPILER}" != "gcc" ]; then
    echo "You must set Environment Variable HB_COMPILER to \"gcc\""
else
    if [ ! -f "${LIBName}_linux.hbp" ]; then
        echo "Invalid Workspace Folder. Missing file ${LIBName}_linux.hbp"
    else

        echo "HB_COMPILER = ${HB_COMPILER}"

        mkdir -p build/lin64/${HB_COMPILER}/${BuildMode}/hbmk2 2>/dev/null

        now=$(date +'%m/%d/%Y %H:%M:%S')
        echo local l_cBuildInfo := \"${HB_COMPILER} ${BuildMode} ${now}\">BuildInfo.txt

        # Due to an issue in lubuntu had to remove double quotes.
        rm build/lin64/${HB_COMPILER}/${BuildMode}/*.* 2>/dev/null
        
        if [ -f "build/lin64/${HB_COMPILER}/${BuildMode}/lib${LIBName}.a" ] ; then
            echo "Could not delete previous version of lib${LIBName}.a"
        else

            #  -b        = debug
            #  -w3       = warn for variable declarations
            #  -es2      = process warning as errors
            #  -gc3      = Pure C code with no HVM
            #  -p        = Leave generated ppo files

            cp *.ch  build/lin64/${HB_COMPILER}/${BuildMode}/
            cp *.hbc build/lin64/${HB_COMPILER}/${BuildMode}/

            # cp /usr/lib/x86_64-linux-gnu/libpython3.11.so build/lin64/%{HB_COMPILER}/${BuildMode}/

            # rm build/lin64/${HB_COMPILER}/${BuildMode}/*.ppo
            #since this is a library will also fail on warnings.
            if [ "${BuildMode}" == "debug" ] ; then
                hbmk2 "${LIBName}_linux.hbp" "vscode_debugger.prg" -b -p -w3 -es2 -shared
            else
                hbmk2 "${LIBName}_linux.hbp" -w3 -es2 -fullstatic
            fi

            nHbmk2Status=$?
            if [ ! -f  "build/lin64/${HB_COMPILER}/${BuildMode}/lib${LIBName}.a" ]; then
                echo "Failed To build lib${LIBName}.a"
            else
                if [ $nHbmk2Status -eq 0 ]; then
                    cp ${LIBName}_linux.hbx build/lin64/${HB_COMPILER}/${BuildMode}/ >/dev/null
                    rm ${LIBName}_linux.hbx >/dev/null

                    echo ""
                    echo "No Errors"
                    echo Current time is ${now}

                    echo ""
                    echo "Ready            BuildMode = ${BuildMode}          C Compiler = ${HB_COMPILER}"
                    
                else
                    echo "Compilation Error"
                    echo Current time is ${now}

                    if [ $nHbmk2Status -eq  1 ]; then echo "Unknown platform" ; fi
                    if [ $nHbmk2Status -eq  2 ]; then echo "Unknown compiler" ; fi
                    if [ $nHbmk2Status -eq  3 ]; then echo "Failed Harbour detection" ; fi
                    if [ $nHbmk2Status -eq  5 ]; then echo "Failed stub creation" ; fi
                    if [ $nHbmk2Status -eq  6 ]; then echo "Failed in compilation (Harbour, C compiler, Resource compiler)" ; fi
                    if [ $nHbmk2Status -eq  7 ]; then echo "Failed in final assembly (linker or library manager)" ; fi
                    if [ $nHbmk2Status -eq  8 ]; then echo "Unsupported" ; fi
                    if [ $nHbmk2Status -eq  9 ]; then echo "Failed to create working directory" ; fi
                    if [ $nHbmk2Status -eq 10 ]; then echo "Dependency missing or disabled" ; fi
                    if [ $nHbmk2Status -eq 19 ]; then echo "Help" ; fi
                    if [ $nHbmk2Status -eq 20 ]; then echo "Plugin initialization" ; fi
                    if [ $nHbmk2Status -eq 30 ]; then echo "Too deep nesting" ; fi
                    if [ $nHbmk2Status -eq 50 ]; then echo "Stop requested" ; fi

                fi
            fi


        fi
    fi
fi
