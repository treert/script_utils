﻿# set source group recursive
# > https://www.cnblogs.com/zjutzz/p/7284114.html
# > https://stackoverflow.com/questions/31422680/how-to-set-visual-studio-filters-for-nested-sub-directory-using-cmake
function(assign_source_group)
    foreach(_source IN ITEMS ${ARGN})
        if (IS_ABSOLUTE "${_source}")
            file(RELATIVE_PATH _source_rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_source}")
        else()
            set(_source_rel "${_source}")
        endif()
        get_filename_component(_source_path "${_source_rel}" PATH)
        string(REPLACE "/" "\\" _source_path_msvc "${_source_path}")
        source_group("${_source_path_msvc}" FILES "${_source}")
    endforeach()
endfunction(assign_source_group)

function(my_add_executable _exe)
    foreach(_source IN ITEMS ${ARGN})
        assign_source_group("${_source}")
    endforeach()
    add_executable(${ARGV})
endfunction(my_add_executable)

function(my_add_library _exe)
    foreach(_source IN ITEMS ${ARGN})
        assign_source_group("${_source}")
    endforeach()
    add_library(${ARGV})
endfunction(my_add_library)

function(my_get_c_files _ret_var)
    set(_ret "")
    foreach(_dir ${ARGN})
        # cmake 不推荐使用file，推荐把文件路径直接写在CMakeLists里。这样文件增减，可以自动构建工程，然而这样很不方便。
        # AUX_SOURCE_DIRECTORY(src v_SRC)
        file(GLOB_RECURSE _files RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${_dir}/*.h" "${_dir}/*.hpp" "${_dir}/*.c" "${_dir}/*.cc" "${_dir}/*.cpp")
        # message(STATUS "${_dir} = ${_files}")
        set(_ret ${_ret} ${_files})
    endforeach()
    set(${_ret_var} ${_ret} PARENT_SCOPE)
endfunction(my_get_c_files)