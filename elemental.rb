class Elemental < Formula
  desc "Distributed-memory dense & sparse linear algebra library"
  homepage "http://libelemental.org/"
  revision 1

  stable do
    url "https://github.com/elemental/Elemental/archive/0.85.tar.gz"
    sha256 "ccf2b8d3b92e99fb0f248b2c82222bef15a7644d7dc3a2826935216b0bd82d9d"
  end

  bottle do
    revision 1
    sha256 "64e4ab14479423b75e2676f70e985605f3eced11ec9d49fa79e61c330d1ad40e" => :yosemite
    sha256 "e531728234b0ce946c0dfb64b25222cbebdfac625a5ac38bbc9de6b9954a7037" => :mavericks
    sha256 "1fd737518f9f95c7892b1dfa44ffbf44fce71561c3e9c840fdd3a87691f1fbe6" => :mountain_lion
  end

  devel do
    url "https://github.com/elemental/Elemental/archive/0.86-rc1.tar.gz"
    sha256 "4f27c55828f27ce1685aaf65018cc149849692b7dfbd9352fc203fed1a96c924"
    version "0.86-rc1"

    option "without-python", "Build without Python 2 bindings"
    depends_on :python => :recommended if MacOS.version <= :snow_leopard
    depends_on "metis"
  end

  head do
    url "https://github.com/elemental/Elemental.git"
    depends_on "metis"
  end

  option "with-test", "Run build time tests (lengthy, not recommended)"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx, :f90]

  depends_on "openblas"  => :optional
  depends_on "qt5"       => :optional
  depends_on "scalapack" => :optional

  needs :cxx11

  # The patch in :DATA patches a bug in Elemental that causes CMake
  # build system errors
  patch :DATA unless build.head?

  def pyver
    Language::Python.major_minor_version "python"
  end

  def install
    ENV.cxx11
    args = ["-DCMAKE_INSTALL_PREFIX=#{libexec}", # Lots of junk ends up in bin.
            "-DCMAKE_FIND_FRAMEWORK=LAST",
            "-DCMAKE_VERBOSE_MAKEFILE=ON",
            "-DCMAKE_C_COMPILER=#{ENV["CC"]}",
            "-DCMAKE_CXX_COMPILER=#{ENV["CXX"]}",
            "-DCMAKE_Fortran_COMPILER=#{ENV["FC"]}",
            "-DMPI_C_COMPILER=#{ENV["MPICC"]}",
            "-DMPI_CXX_COMPILER=#{ENV["MPICXX"]}",
            "-DMPI_Fortran_COMPILER=#{ENV["MPIFC"]}",
            "-Wno-dev"]

    # Python is disabled in stable because there's no way to
    # specify the destination of the Python files.
    if build.without? "python"
      args << "-DINSTALL_PYTHON_PACKAGE=OFF"
    else
      lib_site_packages = lib/"python#{pyver}/site-packages"
      args << "-DPYTHON_SITE_PACKAGES=#{lib_site_packages}"
      mkdir_p lib_site_packages
      (lib_site_packages/"homebrew-elemental.pth").write (opt_lib/"python#{pyver}/site-packages").to_s
    end

    if build.head?
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << ("-DEL_HYBRID=" + ((ENV.compiler == :clang) ? "OFF" : "ON"))
    else
      args << "-DBUILD_KISSFFT=OFF"
      args << ("-DCMAKE_BUILD_TYPE=" + ((ENV.compiler == :clang) ? "Pure" : "Hybrid") + "Release")
    end

    math_libs = ""
    math_libs += "-L#{Formula["scalapack"].opt_lib} -lscalapack " if build.with? "scalapack"
    if build.with? "openblas"
      math_libs += "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      math_libs += (OS.mac? ? "-framework Accelerate" : "-llapack -lblas -lm")
    end
    args << "-DMATH_LIBS=#{math_libs}"

    # METIS / ParMETIS.
    args << "-DBUILD_METIS=OFF"

    if build.devel?
      args += ["-DMANUAL_METIS=ON",
               "-DMETIS_ROOT=#{Formula["metis"].opt_prefix}",
               "-DMETIS_LIBS=-L#{Formula["metis"].opt_lib} -lmetis"]
    end

    # Building against our own ParMETIS seems borderline impossible
    # because of the mess in parmetislib.h.
    if build.head?
      args += ["-DMETIS_INCLUDE_DIRS=#{Formula["metis"].opt_include}",
               "-DMETIS_LIBRARIES=-L#{Formula["metis"].opt_lib} -lmetis",
               "-DBUILD_PARMETIS=ON"]
      # args += ["-DBUILD_PARMETIS=OFF",
      #          "-DPARMETIS_DIR=#{Formula["parmetis"].opt_libexec}",
      #          "-DPARMETIS_INCLUDE_DIR=#{Formula["parmetis"].opt_include}",
      #          "-DPARMETIS_LIB_DIR=#{Formula["parmetis"].opt_lib}"]

    end

    # Bundle tests & examples together for check because examples directory
    # includes code that exercises Qt5 functionality (via spy plots), which
    # requires installing the examples
    args += ["-DEL_TESTS=ON", "-DEL_EXAMPLES=ON"]
    args << "-DEL_USE_QT5=ON" if build.with? "qt5"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"

      if build.with? "test"
        system "make", "test"
      end

      system "make", "install"
      include.install_symlink Dir[libexec/"include/*"]
      lib.install_symlink Dir[libexec/"lib/*"]

      # Install CMake files and Make variable files in pkgshare for
      # users who want to develop their own software using Elemental
      pkgshare.install "conf/ElVars"
      pkgshare.install Dir["etc/elemental/CMake/*"] if build.head?
    end
  end

  test do
    # If running in tmux with Qt5, get the error:
    # PasteBoard: Error creating pasteboard: com.apple.pasteboard.clipboard [-4960]
    # Seems to be a known issue with Qt running in tmux; see
    # https://github.com/ipython/ipython/issues/958.
    # To be safe, also mention other terminal multiplexers.
    opoo "Qt5 tests may return errors if run in tmux or GNU Screen" if build.with? "qt5"

    # Basic smoke test of build for now
    system libexec/"bin/examples/lapack_like/SimpleSVD"
    system "mpiexec", "-np", "2", libexec/"bin/tests/core/DifferentGrids"

    # Qt5 test; if enabled, spy plot of matrix will be made; otherwise,
    # test merely runs without producing spy plot
    system "mpiexec", "-np", "2", libexec/"bin/examples/matrices/Legendre"
  end
end

__END__
diff --git a/external/cmake/CMakeCheckCompilerFlagCommonPatterns.cmake b/external/cmake/CMakeCheckCompilerFlagCommonPatterns.cmake
deleted file mode 100644
index fcc3571..0000000
--- a/external/cmake/CMakeCheckCompilerFlagCommonPatterns.cmake
+++ /dev/null
@@ -1,42 +0,0 @@
-
-#=============================================================================
-# Copyright 2006-2011 Kitware, Inc.
-# Copyright 2006 Alexander Neundorf <neundorf@kde.org>
-# Copyright 2011 Matthias Kretz <kretz@kde.org>
-# Copyright 2013 Rolf Eike Beer <eike@sf-mail.de>
-#
-# Distributed under the OSI-approved BSD License (the "License");
-# see accompanying file Copyright.txt for details.
-#
-# This software is distributed WITHOUT ANY WARRANTY; without even the
-# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-# See the License for more information.
-#=============================================================================
-# (To distribute this file outside of CMake, substitute the full
-#  License text for the above reference.)
-
-# Do NOT include this module directly into any of your code. It is meant as
-# a library for Check*CompilerFlag.cmake modules. It's content may change in
-# any way between releases.
-
-macro (CHECK_COMPILER_FLAG_COMMON_PATTERNS _VAR)
-   set(${_VAR}
-     FAIL_REGEX "unrecognized .*option"                     # GNU
-     FAIL_REGEX "unknown .*option"                          # Clang
-     FAIL_REGEX "ignoring unknown option"                   # MSVC
-     FAIL_REGEX "warning D9002"                             # MSVC, any lang
-     FAIL_REGEX "option.*not supported"                     # Intel
-     FAIL_REGEX "invalid argument .*option"                 # Intel
-     FAIL_REGEX "ignoring option .*argument required"       # Intel
-     FAIL_REGEX "[Uu]nknown option"                         # HP
-     FAIL_REGEX "[Ww]arning: [Oo]ption"                     # SunPro
-     FAIL_REGEX "command option .* is not recognized"       # XL
-     FAIL_REGEX "command option .* contains an incorrect subargument" # XL
-     FAIL_REGEX "not supported in this configuration; ignored"       # AIX
-     FAIL_REGEX "File with unknown suffix passed to linker" # PGI
-     FAIL_REGEX "WARNING: unknown flag:"                    # Open64
-     FAIL_REGEX "Incorrect command line option:"            # Borland
-     FAIL_REGEX "Warning: illegal option"                   # SunStudio 12
-   )
-endmacro ()
-
diff --git a/external/cmake/CMakeParseArguments.cmake b/external/cmake/CMakeParseArguments.cmake
deleted file mode 100644
index 6aa2d63..0000000
--- a/external/cmake/CMakeParseArguments.cmake
+++ /dev/null
@@ -1,289 +0,0 @@
-#.rst:
-# CMakeParseArguments
-# -------------------
-#
-# Parse arguments given to a macro or a function.
-#
-# cmake_parse_arguments() is intended to be used in macros or functions
-# for parsing the arguments given to that macro or function.  It
-# processes the arguments and defines a set of variables which hold the
-# values of the respective options.
-#
-# ::
-#
-#  cmake_parse_arguments(<prefix>
-#                        <options>
-#                        <one_value_keywords>
-#                        <multi_value_keywords>
-#                        [CMAKE_PARSE_ARGUMENTS_SKIP_EMPTY|CMAKE_PARSE_ARGUMENTS_KEEP_EMPTY]
-#                        args...
-#                        )
-#
-# The <options> argument contains all options for the respective macro,
-# i.e.  keywords which can be used when calling the macro without any
-# value following, like e.g.  the OPTIONAL keyword of the install()
-# command.
-#
-# The <one_value_keywords> argument contains all keywords for this macro
-# which are followed by one value, like e.g.  DESTINATION keyword of the
-# install() command.
-#
-# The <multi_value_keywords> argument contains all keywords for this
-# macro which can be followed by more than one value, like e.g.  the
-# TARGETS or FILES keywords of the install() command.
-#
-# When done, cmake_parse_arguments() will have defined for each of the
-# keywords listed in <options>, <one_value_keywords> and
-# <multi_value_keywords> a variable composed of the given <prefix>
-# followed by "_" and the name of the respective keyword.  These
-# variables will then hold the respective value from the argument list.
-# For the <options> keywords this will be TRUE or FALSE.
-#
-# All remaining arguments are collected in a variable
-# <prefix>_UNPARSED_ARGUMENTS, this can be checked afterwards to see
-# whether your macro was called with unrecognized parameters.
-#
-# The cmake CMAKE_PARSE_ARGUMENTS_SKIP_EMPTY (old behaviour) and
-# CMAKE_PARSE_ARGUMENTS_KEEP_EMPTY options decide how empty arguments
-# should be handled. If none of these options is set, for backwards
-# compatibility, if CMAKE_MINIMUM_REQUIRED_VERSION < 3.0.0, the default
-# behaviour is to skip empty arguments, otherwise the default behaviour
-# is to keep them. Using the CMAKE_PARSE_ARGUMENTS_DEFAULT_SKIP_EMPTY
-# directory property the user can explicitly set the default behaviour
-# for a folder and its subfolders.
-#
-#
-#
-# As an example here a my_install() macro, which takes similar arguments
-# as the real install() command:
-#
-# ::
-#
-#    function(MY_INSTALL)
-#      set(options OPTIONAL FAST)
-#      set(oneValueArgs DESTINATION RENAME)
-#      set(multiValueArgs TARGETS CONFIGURATIONS)
-#      cmake_parse_arguments(MY_INSTALL "${options}" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}" )
-#      ...
-#
-#
-#
-# Assume my_install() has been called like this:
-#
-# ::
-#
-#    my_install(TARGETS foo bar DESTINATION bin OPTIONAL blub)
-#
-#
-#
-# After the cmake_parse_arguments() call the macro will have set the
-# following variables:
-#
-# ::
-#
-#    MY_INSTALL_OPTIONAL = TRUE
-#    MY_INSTALL_FAST = FALSE (this option was not used when calling my_install()
-#    MY_INSTALL_DESTINATION = "bin"
-#    MY_INSTALL_RENAME = "" (was not used)
-#    MY_INSTALL_TARGETS = "foo;bar"
-#    MY_INSTALL_CONFIGURATIONS = "" (was not used)
-#    MY_INSTALL_UNPARSED_ARGUMENTS = "blub" (no value expected after "OPTIONAL"
-#
-#
-#
-# You can then continue and process these variables.
-#
-# Keywords terminate lists of values, e.g.  if directly after a
-# one_value_keyword another recognized keyword follows, this is
-# interpreted as the beginning of the new option.  E.g.
-# my_install(TARGETS foo DESTINATION OPTIONAL) would result in
-# MY_INSTALL_DESTINATION set to "OPTIONAL", but MY_INSTALL_DESTINATION
-# would be empty and MY_INSTALL_OPTIONAL would be set to TRUE therefore.
-#
-#
-#
-# If the "CMAKE_PARSE_ARGUMENTS_SKIP_EMPTY" option is set,
-# cmake_parse_argumentswill not consider empty arguments.
-# Therefore
-#
-# ::
-#
-#    my_install(DESTINATION "" TARGETS foo "" bar)
-#
-# Will set
-#
-# ::
-#
-#    MY_INSTALL_DESTINATION = (unset)
-#    MY_INSTALL_MULTI = "foo;bar"
-#
-# Using the "CMAKE_PARSE_ARGUMENTS_SKIP_EMPTY" option instead, will set
-#
-# ::
-#
-#    MY_INSTALL_SINGLE = ""
-#    MY_INSTALL_MULTI = "foo;;bar"
-#
-#
-# It is also important to note that:
-#
-# ::
-#
-#      cmake_parse_arguments(MY_INSTALL "${options}" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}" )
-#      cmake_parse_arguments(MY_INSTALL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
-#
-# Will behave differently, because in the latter case empty arguments
-# are not passed to cmake_parse_arguments.
-
-#=============================================================================
-# Copyright 2010 Alexander Neundorf <neundorf@kde.org>
-#
-# Distributed under the OSI-approved BSD License (the "License");
-# see accompanying file Copyright.txt for details.
-#
-# This software is distributed WITHOUT ANY WARRANTY; without even the
-# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-# See the License for more information.
-#=============================================================================
-# (To distribute this file outside of CMake, substitute the full
-#  License text for the above reference.)
-
-
-if(__CMAKE_PARSE_ARGUMENTS_INCLUDED)
-  return()
-endif()
-set(__CMAKE_PARSE_ARGUMENTS_INCLUDED TRUE)
-
-
-define_property(DIRECTORY PROPERTY "CMAKE_PARSE_ARGUMENTS_DEFAULT_SKIP_EMPTY" INHERITED
-  BRIEF_DOCS "Whether empty arguments should be skipped or not by default."
-  FULL_DOCS
-  "See documentation of the cmake_parse_arguments() function in the "
-  "CMakeParseArguments module."
-  )
-
-
-function(_CMAKE_PARSE_ARGUMENTS prefix _optionNames _singleArgNames _multiArgNames _skipEmpty)
-  set(insideValues FALSE)
-  set(currentArgName)
-
-  if(_skipEmpty)
-    set(_loopARGN ${ARGN})
-  else()
-    set(_loopARGN IN LISTS ARGN)
-  endif()
-
-  # now iterate over all arguments and fill the result variables
-  foreach(currentArg ${_loopARGN})
-    list(FIND _optionNames "${currentArg}" optionIndex)  # ... then this marks the end of the arguments belonging to this keyword
-    list(FIND _singleArgNames "${currentArg}" singleArgIndex)  # ... then this marks the end of the arguments belonging to this keyword
-    list(FIND _multiArgNames "${currentArg}" multiArgIndex)  # ... then this marks the end of the arguments belonging to this keyword
-
-    if(${optionIndex} EQUAL -1  AND  ${singleArgIndex} EQUAL -1  AND  ${multiArgIndex} EQUAL -1)
-      if(insideValues)
-        if("${insideValues}" STREQUAL "SINGLE")
-          if(_skipEmpty)
-            set(${prefix}_${currentArgName} ${currentArg})
-          else()
-            set(${prefix}_${currentArgName} "${currentArg}")
-          endif()
-          set(insideValues FALSE)
-        elseif("${insideValues}" STREQUAL "MULTI")
-          if(_skipEmpty)
-            list(APPEND ${prefix}_${currentArgName} ${currentArg})
-          else()
-            list(APPEND ${prefix}_${currentArgName} "${currentArg}")
-          endif()
-        endif()
-      else()
-        if(_skipEmpty)
-          list(APPEND ${prefix}_UNPARSED_ARGUMENTS ${currentArg})
-        else()
-          list(APPEND ${prefix}_UNPARSED_ARGUMENTS "${currentArg}")
-        endif()
-      endif()
-    else()
-      if(NOT ${optionIndex} EQUAL -1)
-        set(${prefix}_${currentArg} TRUE)
-        set(insideValues FALSE)
-      elseif(NOT ${singleArgIndex} EQUAL -1)
-        set(currentArgName ${currentArg})
-        set(${prefix}_${currentArgName})
-        set(insideValues "SINGLE")
-      elseif(NOT ${multiArgIndex} EQUAL -1)
-        set(currentArgName ${currentArg})
-        set(${prefix}_${currentArgName})
-        set(insideValues "MULTI")
-      endif()
-    endif()
-
-  endforeach()
-
-  # propagate the result variables to the caller:
-  foreach(arg_name ${_singleArgNames} ${_multiArgNames} ${_optionNames} UNPARSED_ARGUMENTS)
-    if(DEFINED ${prefix}_${arg_name})
-      set(${prefix}_${arg_name} "${${prefix}_${arg_name}}" PARENT_SCOPE)
-    endif()
-  endforeach()
-
-endfunction()
-
-
-# This "wrapper" macro is a workaround that allows to use this version of this
-# module with CMake <= 2.8.12
-# Before that version set(VAR "" PARENT_SCOPE) did not set the variable in
-# the parent scope and instead it used to unset it.
-# This wrapper calls the real function, but if necessary (i.e. when empty
-# arguments should not be skipped and CMake < 3.0.0) it parses the arguments
-# again in order to find single and multiple arguments that have not been set
-# and sets them to an empty string in the same variable scope as the caller.
-macro(CMAKE_PARSE_ARGUMENTS prefix _optionNames _singleArgNames _multiArgNames)
-  # first set all result variables to empty/FALSE
-  foreach(arg_name ${_singleArgNames} ${_multiArgNames})
-    set(${prefix}_${arg_name})
-  endforeach()
-
-  foreach(option ${_optionNames})
-    set(${prefix}_${option} FALSE)
-  endforeach()
-
-  set(${prefix}_UNPARSED_ARGUMENTS)
-
-  get_property(_defaultSkipEmptySet DIRECTORY PROPERTY CMAKE_PARSE_ARGUMENTS_DEFAULT_SKIP_EMPTY SET)
-  get_property(_defaultSkipEmpty    DIRECTORY PROPERTY CMAKE_PARSE_ARGUMENTS_DEFAULT_SKIP_EMPTY)
-
-  if("x${ARGN}" MATCHES "^xCMAKE_PARSE_ARGUMENTS_(SKIP|KEEP)_EMPTY;?")
-    if("${CMAKE_MATCH_1}" STREQUAL "SKIP")
-        set(_skipEmpty 1)
-    elseif("${CMAKE_MATCH_1}" STREQUAL "KEEP")
-        set(_skipEmpty 0)
-    endif()
-    string(REGEX REPLACE "^${CMAKE_MATCH_0}" "" ARGN "x${ARGN}")
-  elseif(_defaultSkipEmptySet)
-    set(_skipEmpty "${_defaultSkipEmpty}")
-  elseif(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.0.0)
-   # Keep compatibility with previous releases
-    set(_skipEmpty 1)
-  else()
-    set(_skipEmpty 0)
-  endif()
-
-  _cmake_parse_arguments("${prefix}" "${_optionNames}" "${_singleArgNames}" "${_multiArgNames}" "${_skipEmpty}" "${ARGN}")
-
-  if(NOT _skipEmpty AND CMAKE_VERSION VERSION_LESS 3.0.0)
-    set(__singleArgNames ${_singleArgNames})
-    set(__multiArgNames ${_multiArgNames})
-    foreach(currentArg ${ARGN})
-      if(NOT DEFINED ${prefix}_${currentArg})
-        list(FIND __singleArgNames "${currentArg}" _singleArgIndex)
-        list(FIND __multiArgNames "${currentArg}" _multiArgIndex)
-        if(NOT ${_singleArgIndex} EQUAL -1  OR  NOT ${_multiArgIndex} EQUAL -1)
-          set(${prefix}_${currentArg} "")
-        endif()
-      endif()
-    endforeach()
-    unset(__singleArgNames)
-    unset(__multiArgNames)
-  endif()
-
-endmacro()
diff --git a/external/cmake/CheckCXXCompilerFlag.cmake b/external/cmake/CheckCXXCompilerFlag.cmake
deleted file mode 100644
index 3e7e79c..0000000
--- a/external/cmake/CheckCXXCompilerFlag.cmake
+++ /dev/null
@@ -1,63 +0,0 @@
-#.rst:
-# CheckCXXCompilerFlag
-# --------------------
-#
-# Check whether the CXX compiler supports a given flag.
-#
-# CHECK_CXX_COMPILER_FLAG(<flag> <var>)
-#
-# ::
-#
-#   <flag> - the compiler flag
-#   <var>  - variable to store the result
-#
-# This internally calls the check_cxx_source_compiles macro and sets
-# CMAKE_REQUIRED_DEFINITIONS to <flag>.  See help for
-# CheckCXXSourceCompiles for a listing of variables that can otherwise
-# modify the build.  The result only tells that the compiler does not
-# give an error message when it encounters the flag.  If the flag has
-# any effect or even a specific one is beyond the scope of this module.
-
-#=============================================================================
-# Copyright 2006-2010 Kitware, Inc.
-# Copyright 2006 Alexander Neundorf <neundorf@kde.org>
-# Copyright 2011 Matthias Kretz <kretz@kde.org>
-#
-# Distributed under the OSI-approved BSD License (the "License");
-# see accompanying file Copyright.txt for details.
-#
-# This software is distributed WITHOUT ANY WARRANTY; without even the
-# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-# See the License for more information.
-#=============================================================================
-# (To distribute this file outside of CMake, substitute the full
-#  License text for the above reference.)
-
-include(CheckCXXSourceCompiles)
-include(CMakeCheckCompilerFlagCommonPatterns)
-
-macro (CHECK_CXX_COMPILER_FLAG _FLAG _RESULT)
-   set(SAFE_CMAKE_REQUIRED_DEFINITIONS "${CMAKE_REQUIRED_DEFINITIONS}")
-   set(CMAKE_REQUIRED_DEFINITIONS "${_FLAG}")
-
-   # Normalize locale during test compilation.
-   set(_CheckCXXCompilerFlag_LOCALE_VARS LC_ALL LC_MESSAGES LANG)
-   foreach(v ${_CheckCXXCompilerFlag_LOCALE_VARS})
-     set(_CheckCXXCompilerFlag_SAVED_${v} "$ENV{${v}}")
-     set(ENV{${v}} C)
-   endforeach()
-   CHECK_COMPILER_FLAG_COMMON_PATTERNS(_CheckCXXCompilerFlag_COMMON_PATTERNS)
-   CHECK_CXX_SOURCE_COMPILES("int main() { return 0; }" ${_RESULT}
-     # Some compilers do not fail with a bad flag
-     FAIL_REGEX "command line option .* is valid for .* but not for C\\\\+\\\\+" # GNU
-     ${_CheckCXXCompilerFlag_COMMON_PATTERNS}
-     )
-   foreach(v ${_CheckCXXCompilerFlag_LOCALE_VARS})
-     set(ENV{${v}} ${_CheckCXXCompilerFlag_SAVED_${v}})
-     unset(_CheckCXXCompilerFlag_SAVED_${v})
-   endforeach()
-   unset(_CheckCXXCompilerFlag_LOCALE_VARS)
-   unset(_CheckCXXCompilerFlag_COMMON_PATTERNS)
-
-   set (CMAKE_REQUIRED_DEFINITIONS "${SAFE_CMAKE_REQUIRED_DEFINITIONS}")
-endmacro ()
diff --git a/external/cmake/FindCXXFeatures.cmake b/external/cmake/FindCXXFeatures.cmake
index c48d80e..80bddaa 100644
--- a/external/cmake/FindCXXFeatures.cmake
+++ b/external/cmake/FindCXXFeatures.cmake
@@ -48,7 +48,7 @@ endif ()
 #
 ### Check for needed compiler flags
 #
-include(${CMAKE_CURRENT_LIST_DIR}/CheckCXXCompilerFlag.cmake)
+include(CheckCXXCompilerFlag)

 function(test_set_flag FLAG NAME)
     check_cxx_compiler_flag("${FLAG}" _HAS_${NAME}_FLAG)
@@ -158,7 +158,7 @@ foreach (_cxx_feature IN LISTS CXXFEATURES_FIND_COMPONENTS)
     cxx_check_feature(${_cxx_feature} ${FEATURE_NAME})
 endforeach (_cxx_feature)

-include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
+include(FindPackageHandleStandardArgs)
 set(DUMMY_VAR TRUE)
 find_package_handle_standard_args(CXXFeatures REQUIRED_VARS DUMMY_VAR HANDLE_COMPONENTS)
 unset(DUMMY_VAR)
diff --git a/external/cmake/FindPackageHandleStandardArgs.cmake b/external/cmake/FindPackageHandleStandardArgs.cmake
deleted file mode 100644
index d030418..0000000
--- a/external/cmake/FindPackageHandleStandardArgs.cmake
+++ /dev/null
@@ -1,351 +0,0 @@
-#.rst:
-# FindPackageHandleStandardArgs
-# -----------------------------
-#
-#
-#
-# FIND_PACKAGE_HANDLE_STANDARD_ARGS(<name> ...  )
-#
-# This function is intended to be used in FindXXX.cmake modules files.
-# It handles the REQUIRED, QUIET and version-related arguments to
-# find_package().  It also sets the <packagename>_FOUND variable.  The
-# package is considered found if all variables <var1>...  listed contain
-# valid results, e.g.  valid filepaths.
-#
-# There are two modes of this function.  The first argument in both
-# modes is the name of the Find-module where it is called (in original
-# casing).
-#
-# The first simple mode looks like this:
-#
-# ::
-#
-#     FIND_PACKAGE_HANDLE_STANDARD_ARGS(<name> (DEFAULT_MSG|"Custom failure message") <var1>...<varN> )
-#
-# If the variables <var1> to <varN> are all valid, then
-# <UPPERCASED_NAME>_FOUND will be set to TRUE.  If DEFAULT_MSG is given
-# as second argument, then the function will generate itself useful
-# success and error messages.  You can also supply a custom error
-# message for the failure case.  This is not recommended.
-#
-# The second mode is more powerful and also supports version checking:
-#
-# ::
-#
-#     FIND_PACKAGE_HANDLE_STANDARD_ARGS(NAME [FOUND_VAR <resultVar>]
-#                                            [REQUIRED_VARS <var1>...<varN>]
-#                                            [VERSION_VAR   <versionvar>]
-#                                            [HANDLE_COMPONENTS]
-#                                            [CONFIG_MODE]
-#                                            [FAIL_MESSAGE "Custom failure message"] )
-#
-#
-#
-# In this mode, the name of the result-variable can be set either to
-# either <UPPERCASED_NAME>_FOUND or <OriginalCase_Name>_FOUND using the
-# FOUND_VAR option.  Other names for the result-variable are not
-# allowed.  So for a Find-module named FindFooBar.cmake, the two
-# possible names are FooBar_FOUND and FOOBAR_FOUND.  It is recommended
-# to use the original case version.  If the FOUND_VAR option is not
-# used, the default is <UPPERCASED_NAME>_FOUND.
-#
-# As in the simple mode, if <var1> through <varN> are all valid,
-# <packagename>_FOUND will be set to TRUE.  After REQUIRED_VARS the
-# variables which are required for this package are listed.  Following
-# VERSION_VAR the name of the variable can be specified which holds the
-# version of the package which has been found.  If this is done, this
-# version will be checked against the (potentially) specified required
-# version used in the find_package() call.  The EXACT keyword is also
-# handled.  The default messages include information about the required
-# version and the version which has been actually found, both if the
-# version is ok or not.  If the package supports components, use the
-# HANDLE_COMPONENTS option to enable handling them.  In this case,
-# find_package_handle_standard_args() will report which components have
-# been found and which are missing, and the <packagename>_FOUND variable
-# will be set to FALSE if any of the required components (i.e.  not the
-# ones listed after OPTIONAL_COMPONENTS) are missing.  Use the option
-# CONFIG_MODE if your FindXXX.cmake module is a wrapper for a
-# find_package(...  NO_MODULE) call.  In this case VERSION_VAR will be
-# set to <NAME>_VERSION and the macro will automatically check whether
-# the Config module was found.  Via FAIL_MESSAGE a custom failure
-# message can be specified, if this is not used, the default message
-# will be displayed.
-#
-# Example for mode 1:
-#
-# ::
-#
-#     find_package_handle_standard_args(LibXml2  DEFAULT_MSG  LIBXML2_LIBRARY LIBXML2_INCLUDE_DIR)
-#
-#
-#
-# LibXml2 is considered to be found, if both LIBXML2_LIBRARY and
-# LIBXML2_INCLUDE_DIR are valid.  Then also LIBXML2_FOUND is set to
-# TRUE.  If it is not found and REQUIRED was used, it fails with
-# FATAL_ERROR, independent whether QUIET was used or not.  If it is
-# found, success will be reported, including the content of <var1>.  On
-# repeated Cmake runs, the same message won't be printed again.
-#
-# Example for mode 2:
-#
-# ::
-#
-#     find_package_handle_standard_args(LibXslt FOUND_VAR LibXslt_FOUND
-#                                              REQUIRED_VARS LibXslt_LIBRARIES LibXslt_INCLUDE_DIRS
-#                                              VERSION_VAR LibXslt_VERSION_STRING)
-#
-# In this case, LibXslt is considered to be found if the variable(s)
-# listed after REQUIRED_VAR are all valid, i.e.  LibXslt_LIBRARIES and
-# LibXslt_INCLUDE_DIRS in this case.  The result will then be stored in
-# LibXslt_FOUND .  Also the version of LibXslt will be checked by using
-# the version contained in LibXslt_VERSION_STRING.  Since no
-# FAIL_MESSAGE is given, the default messages will be printed.
-#
-# Another example for mode 2:
-#
-# ::
-#
-#     find_package(Automoc4 QUIET NO_MODULE HINTS /opt/automoc4)
-#     find_package_handle_standard_args(Automoc4  CONFIG_MODE)
-#
-# In this case, FindAutmoc4.cmake wraps a call to find_package(Automoc4
-# NO_MODULE) and adds an additional search directory for automoc4.  Here
-# the result will be stored in AUTOMOC4_FOUND.  The following
-# FIND_PACKAGE_HANDLE_STANDARD_ARGS() call produces a proper
-# success/error message.
-
-#=============================================================================
-# Copyright 2007-2009 Kitware, Inc.
-#
-# Distributed under the OSI-approved BSD License (the "License");
-# see accompanying file Copyright.txt for details.
-#
-# This software is distributed WITHOUT ANY WARRANTY; without even the
-# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-# See the License for more information.
-#=============================================================================
-# (To distribute this file outside of CMake, substitute the full
-#  License text for the above reference.)
-
-include(${CMAKE_CURRENT_LIST_DIR}/FindPackageMessage.cmake)
-include(${CMAKE_CURRENT_LIST_DIR}/CMakeParseArguments.cmake)
-
-# internal helper macro
-macro(_FPHSA_FAILURE_MESSAGE _msg)
-  if (${_NAME}_FIND_REQUIRED)
-    message(FATAL_ERROR "${_msg}")
-  else ()
-    if (NOT ${_NAME}_FIND_QUIETLY)
-      message(STATUS "${_msg}")
-    endif ()
-  endif ()
-endmacro()
-
-
-# internal helper macro to generate the failure message when used in CONFIG_MODE:
-macro(_FPHSA_HANDLE_FAILURE_CONFIG_MODE)
-  # <name>_CONFIG is set, but FOUND is false, this means that some other of the REQUIRED_VARS was not found:
-  if(${_NAME}_CONFIG)
-    _FPHSA_FAILURE_MESSAGE("${FPHSA_FAIL_MESSAGE}: missing: ${MISSING_VARS} (found ${${_NAME}_CONFIG} ${VERSION_MSG})")
-  else()
-    # If _CONSIDERED_CONFIGS is set, the config-file has been found, but no suitable version.
-    # List them all in the error message:
-    if(${_NAME}_CONSIDERED_CONFIGS)
-      set(configsText "")
-      list(LENGTH ${_NAME}_CONSIDERED_CONFIGS configsCount)
-      math(EXPR configsCount "${configsCount} - 1")
-      foreach(currentConfigIndex RANGE ${configsCount})
-        list(GET ${_NAME}_CONSIDERED_CONFIGS ${currentConfigIndex} filename)
-        list(GET ${_NAME}_CONSIDERED_VERSIONS ${currentConfigIndex} version)
-        set(configsText "${configsText}    ${filename} (version ${version})\n")
-      endforeach()
-      if (${_NAME}_NOT_FOUND_MESSAGE)
-        set(configsText "${configsText}    Reason given by package: ${${_NAME}_NOT_FOUND_MESSAGE}\n")
-      endif()
-      _FPHSA_FAILURE_MESSAGE("${FPHSA_FAIL_MESSAGE} ${VERSION_MSG}, checked the following files:\n${configsText}")
-
-    else()
-      # Simple case: No Config-file was found at all:
-      _FPHSA_FAILURE_MESSAGE("${FPHSA_FAIL_MESSAGE}: found neither ${_NAME}Config.cmake nor ${_NAME_LOWER}-config.cmake ${VERSION_MSG}")
-    endif()
-  endif()
-endmacro()
-
-
-function(FIND_PACKAGE_HANDLE_STANDARD_ARGS _NAME _FIRST_ARG)
-
-# set up the arguments for CMAKE_PARSE_ARGUMENTS and check whether we are in
-# new extended or in the "old" mode:
-  set(options  CONFIG_MODE  HANDLE_COMPONENTS)
-  set(oneValueArgs  FAIL_MESSAGE  VERSION_VAR  FOUND_VAR)
-  set(multiValueArgs REQUIRED_VARS)
-  set(_KEYWORDS_FOR_EXTENDED_MODE  ${options} ${oneValueArgs} ${multiValueArgs} )
-  list(FIND _KEYWORDS_FOR_EXTENDED_MODE "${_FIRST_ARG}" INDEX)
-
-  if(${INDEX} EQUAL -1)
-    set(FPHSA_FAIL_MESSAGE ${_FIRST_ARG})
-    set(FPHSA_REQUIRED_VARS ${ARGN})
-    set(FPHSA_VERSION_VAR)
-  else()
-
-    CMAKE_PARSE_ARGUMENTS(FPHSA "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${_FIRST_ARG} ${ARGN})
-
-    if(FPHSA_UNPARSED_ARGUMENTS)
-      message(FATAL_ERROR "Unknown keywords given to FIND_PACKAGE_HANDLE_STANDARD_ARGS(): \"${FPHSA_UNPARSED_ARGUMENTS}\"")
-    endif()
-
-    if(NOT FPHSA_FAIL_MESSAGE)
-      set(FPHSA_FAIL_MESSAGE  "DEFAULT_MSG")
-    endif()
-  endif()
-
-# now that we collected all arguments, process them
-
-  if("${FPHSA_FAIL_MESSAGE}" STREQUAL "DEFAULT_MSG")
-    set(FPHSA_FAIL_MESSAGE "Could NOT find ${_NAME}")
-  endif()
-
-  # In config-mode, we rely on the variable <package>_CONFIG, which is set by find_package()
-  # when it successfully found the config-file, including version checking:
-  if(FPHSA_CONFIG_MODE)
-    list(INSERT FPHSA_REQUIRED_VARS 0 ${_NAME}_CONFIG)
-    list(REMOVE_DUPLICATES FPHSA_REQUIRED_VARS)
-    set(FPHSA_VERSION_VAR ${_NAME}_VERSION)
-  endif()
-
-  if(NOT FPHSA_REQUIRED_VARS)
-    message(FATAL_ERROR "No REQUIRED_VARS specified for FIND_PACKAGE_HANDLE_STANDARD_ARGS()")
-  endif()
-
-  list(GET FPHSA_REQUIRED_VARS 0 _FIRST_REQUIRED_VAR)
-
-  string(TOUPPER ${_NAME} _NAME_UPPER)
-  string(TOLOWER ${_NAME} _NAME_LOWER)
-
-  if(FPHSA_FOUND_VAR)
-    if(FPHSA_FOUND_VAR MATCHES "^${_NAME}_FOUND$"  OR  FPHSA_FOUND_VAR MATCHES "^${_NAME_UPPER}_FOUND$")
-      set(_FOUND_VAR ${FPHSA_FOUND_VAR})
-    else()
-      message(FATAL_ERROR "The argument for FOUND_VAR is \"${FPHSA_FOUND_VAR}\", but only \"${_NAME}_FOUND\" and \"${_NAME_UPPER}_FOUND\" are valid names.")
-    endif()
-  else()
-    set(_FOUND_VAR ${_NAME_UPPER}_FOUND)
-  endif()
-
-  # collect all variables which were not found, so they can be printed, so the
-  # user knows better what went wrong (#6375)
-  set(MISSING_VARS "")
-  set(DETAILS "")
-  # check if all passed variables are valid
-  unset(${_FOUND_VAR})
-  foreach(_CURRENT_VAR ${FPHSA_REQUIRED_VARS})
-    if(NOT ${_CURRENT_VAR})
-      set(${_FOUND_VAR} FALSE)
-      set(MISSING_VARS "${MISSING_VARS} ${_CURRENT_VAR}")
-    else()
-      set(DETAILS "${DETAILS}[${${_CURRENT_VAR}}]")
-    endif()
-  endforeach()
-  if(NOT "${${_FOUND_VAR}}" STREQUAL "FALSE")
-    set(${_FOUND_VAR} TRUE)
-  endif()
-
-  # component handling
-  unset(FOUND_COMPONENTS_MSG)
-  unset(MISSING_COMPONENTS_MSG)
-
-  if(FPHSA_HANDLE_COMPONENTS)
-    foreach(comp ${${_NAME}_FIND_COMPONENTS})
-      if(${_NAME}_${comp}_FOUND)
-
-        if(NOT DEFINED FOUND_COMPONENTS_MSG)
-          set(FOUND_COMPONENTS_MSG "found components: ")
-        endif()
-        set(FOUND_COMPONENTS_MSG "${FOUND_COMPONENTS_MSG} ${comp}")
-
-      else()
-
-        if(NOT DEFINED MISSING_COMPONENTS_MSG)
-          set(MISSING_COMPONENTS_MSG "missing components: ")
-        endif()
-        set(MISSING_COMPONENTS_MSG "${MISSING_COMPONENTS_MSG} ${comp}")
-
-        if(${_NAME}_FIND_REQUIRED_${comp})
-          set(${_FOUND_VAR} FALSE)
-          set(MISSING_VARS "${MISSING_VARS} ${comp}")
-        endif()
-
-      endif()
-    endforeach()
-    set(COMPONENT_MSG "${FOUND_COMPONENTS_MSG} ${MISSING_COMPONENTS_MSG}")
-    set(DETAILS "${DETAILS}[c${COMPONENT_MSG}]")
-  endif()
-
-  # version handling:
-  set(VERSION_MSG "")
-  set(VERSION_OK TRUE)
-  set(VERSION ${${FPHSA_VERSION_VAR}} )
-  if (${_NAME}_FIND_VERSION)
-
-    if(VERSION)
-
-      if(${_NAME}_FIND_VERSION_EXACT)       # exact version required
-        if (NOT "${${_NAME}_FIND_VERSION}" VERSION_EQUAL "${VERSION}")
-          set(VERSION_MSG "Found unsuitable version \"${VERSION}\", but required is exact version \"${${_NAME}_FIND_VERSION}\"")
-          set(VERSION_OK FALSE)
-        else ()
-          set(VERSION_MSG "(found suitable exact version \"${VERSION}\")")
-        endif ()
-
-      else()     # minimum version specified:
-        if ("${${_NAME}_FIND_VERSION}" VERSION_GREATER "${VERSION}")
-          set(VERSION_MSG "Found unsuitable version \"${VERSION}\", but required is at least \"${${_NAME}_FIND_VERSION}\"")
-          set(VERSION_OK FALSE)
-        else ()
-          set(VERSION_MSG "(found suitable version \"${VERSION}\", minimum required is \"${${_NAME}_FIND_VERSION}\")")
-        endif ()
-      endif()
-
-    else()
-
-      # if the package was not found, but a version was given, add that to the output:
-      if(${_NAME}_FIND_VERSION_EXACT)
-         set(VERSION_MSG "(Required is exact version \"${${_NAME}_FIND_VERSION}\")")
-      else()
-         set(VERSION_MSG "(Required is at least version \"${${_NAME}_FIND_VERSION}\")")
-      endif()
-
-    endif()
-  else ()
-    if(VERSION)
-      set(VERSION_MSG "(found version \"${VERSION}\")")
-    endif()
-  endif ()
-
-  if(VERSION_OK)
-    set(DETAILS "${DETAILS}[v${VERSION}(${${_NAME}_FIND_VERSION})]")
-  else()
-    set(${_FOUND_VAR} FALSE)
-  endif()
-
-
-  # print the result:
-  if (${_FOUND_VAR})
-    FIND_PACKAGE_MESSAGE(${_NAME} "Found ${_NAME}: ${${_FIRST_REQUIRED_VAR}} ${VERSION_MSG} ${COMPONENT_MSG}" "${DETAILS}")
-  else ()
-
-    if(FPHSA_CONFIG_MODE)
-      _FPHSA_HANDLE_FAILURE_CONFIG_MODE()
-    else()
-      if(NOT VERSION_OK)
-        _FPHSA_FAILURE_MESSAGE("${FPHSA_FAIL_MESSAGE}: ${VERSION_MSG} (found ${${_FIRST_REQUIRED_VAR}})")
-      else()
-        _FPHSA_FAILURE_MESSAGE("${FPHSA_FAIL_MESSAGE} (missing: ${MISSING_VARS}) ${VERSION_MSG}")
-      endif()
-    endif()
-
-  endif ()
-
-  set(${_FOUND_VAR} ${${_FOUND_VAR}} PARENT_SCOPE)
-
-endfunction()
diff --git a/external/cmake/FindPackageMessage.cmake b/external/cmake/FindPackageMessage.cmake
deleted file mode 100644
index b6a58e4..0000000
--- a/external/cmake/FindPackageMessage.cmake
+++ /dev/null
@@ -1,57 +0,0 @@
-#.rst:
-# FindPackageMessage
-# ------------------
-#
-#
-#
-# FIND_PACKAGE_MESSAGE(<name> "message for user" "find result details")
-#
-# This macro is intended to be used in FindXXX.cmake modules files.  It
-# will print a message once for each unique find result.  This is useful
-# for telling the user where a package was found.  The first argument
-# specifies the name (XXX) of the package.  The second argument
-# specifies the message to display.  The third argument lists details
-# about the find result so that if they change the message will be
-# displayed again.  The macro also obeys the QUIET argument to the
-# find_package command.
-#
-# Example:
-#
-# ::
-#
-#   if(X11_FOUND)
-#     FIND_PACKAGE_MESSAGE(X11 "Found X11: ${X11_X11_LIB}"
-#       "[${X11_X11_LIB}][${X11_INCLUDE_DIR}]")
-#   else()
-#    ...
-#   endif()
-
-#=============================================================================
-# Copyright 2008-2009 Kitware, Inc.
-#
-# Distributed under the OSI-approved BSD License (the "License");
-# see accompanying file Copyright.txt for details.
-#
-# This software is distributed WITHOUT ANY WARRANTY; without even the
-# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-# See the License for more information.
-#=============================================================================
-# (To distribute this file outside of CMake, substitute the full
-#  License text for the above reference.)
-
-function(FIND_PACKAGE_MESSAGE pkg msg details)
-  # Avoid printing a message repeatedly for the same find result.
-  if(NOT ${pkg}_FIND_QUIETLY)
-    string(REGEX REPLACE "[\n]" "" details "${details}")
-    set(DETAILS_VAR FIND_PACKAGE_MESSAGE_DETAILS_${pkg})
-    if(NOT "${details}" STREQUAL "${${DETAILS_VAR}}")
-      # The message has not yet been printed.
-      message(STATUS "${msg}")
-
-      # Save the find details in the cache to avoid printing the same
-      # message again.
-      set("${DETAILS_VAR}" "${details}"
-        CACHE INTERNAL "Details about finding ${pkg}")
-    endif()
-  endif()
-endfunction()
