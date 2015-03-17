class Gnudatalanguage < Formula
  homepage "http://gnudatalanguage.sourceforge.net"
  url "https://downloads.sourceforge.net/project/gnudatalanguage/gdl/0.9.5/gdl-0.9.5.tar.gz"
  sha256 "cc9635e836b5ea456cad93f8a07d589aed8649668fbd14c4aad22091991137e2"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "plplot"
  depends_on "gsl"
  depends_on "readline"
  depends_on "graphicsmagick"
  depends_on "netcdf"
  depends_on "homebrew/versions/hdf4" => :optional
  depends_on "hdf5"
  depends_on "libpng"
  depends_on "udunits"
  depends_on "gsl"
  depends_on "fftw"
  depends_on "eigen"
  depends_on :x11
  depends_on :python => :optional

  # part 1 taken from macports https://trac.macports.org/browser/trunk/dports/math/gnudatalanguage/files/patch-CMakeLists.txt.diff
  # other parts taken from https://github.com/freebsd/freebsd-ports/tree/master/science/gnudatalanguage/files
  patch :p0, :DATA

  def install
    args = std_cmake_args
    args << "-DHDF=OFF" if build.without?("hdf4")
    args << "-DPYTHON=OFF" if build.without?("python")
    args << "-DWXWIDGETS=OFF" << "-DPSLIB=OFF"
    system "cmake", ".", *args
    system "make"
    # several tests fail
    # system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/gdl", "--version"
  end
end

__END__
--- CMakeLists.txt.orig	2014-10-07 22:21:14.000000000 +0900
+++ CMakeLists.txt	2014-10-13 17:36:18.000000000 +0900
@@ -878,14 +878,14 @@

 # create a link src/gdl -> ${BUILD}/.../gdl
 # for windows, just copy the file
-if(NOT PYTHON_MODULE)
-	get_target_property(GDLLOCATION gdl LOCATION)
-	if(WIN32)
-	add_custom_target(copy_gdl ALL ${CMAKE_COMMAND} -E copy ${GDLLOCATION} ${CMAKE_SOURCE_DIR}/src/gdl DEPENDS gdl)
-	else(WIN32)
-	add_custom_target(symlink_gdl ALL ${CMAKE_COMMAND} -E create_symlink ${GDLLOCATION} ${CMAKE_SOURCE_DIR}/src/gdl DEPENDS gdl)
-	endif(WIN32)
-endif(NOT PYTHON_MODULE)
+#if(NOT PYTHON_MODULE)
+#	get_target_property(GDLLOCATION gdl LOCATION)
+#	if(WIN32)
+#	add_custom_target(copy_gdl ALL ${CMAKE_COMMAND} -E copy ${GDLLOCATION} ${CMAKE_SOURCE_DIR}/src/gdl DEPENDS gdl)
+#	else(WIN32)
+#	add_custom_target(symlink_gdl ALL ${CMAKE_COMMAND} -E create_symlink ${GDLLOCATION} ${CMAKE_SOURCE_DIR}/src/gdl DEPENDS gdl)
+#	endif(WIN32)
+#endif(NOT PYTHON_MODULE)

 # display macro
 macro(MODULE MOD NAME)
--- src/base64.hpp.orig	2014-10-10 23:11:19.000000000 +0200
+++ src/base64.hpp	2014-10-10 23:17:21.000000000 +0200
@@ -147,7 +147,7 @@
						Warning("base64 decode error: unexpected fill char -- offset read?");
						return false;
					}
-					if(!(isspace(data[i-1]))) {
+					if(!(std::isspace(data[i-1]))) {
						//cerr << "base 64 decode error: illegal character '" << data[i-1] << "' (0x" << std::hex << (int)data[i-1] << std::dec << ")" << endl;
						Warning("base 64 decode error: illegal character");
						return false;
@@ -165,7 +165,7 @@
						Warning("base64 decode error: unexpected fill char -- offset read?");
						return false;
					}
-					if(!(isspace(data[i-1]))) {
+					if(!(std::isspace(data[i-1]))) {
						//cerr << "base 64 decode error: illegal character '" << data[i-1] << '\'' << endl;
						Warning("base 64 decode error: illegal character");
						return false;
@@ -190,7 +190,7 @@
					if(fillchar == data[i-1]) {
						return true;
					}
-					if((!isspace(data[i-1]))) {
+					if((!std::isspace(data[i-1]))) {
						//cerr << "base 64 decode error: illegal character '" << data[i-1] << '\'' << endl;
						Warning("base 64 decode error: illegal character");
						return false;
@@ -215,7 +215,7 @@
					if(fillchar == data[i-1]) {
						return true;
					}
-					if(!(isspace(data[i-1]))) {
+					if(!(std::isspace(data[i-1]))) {
						//cerr << "base 64 decode error: illegal character '" << data[i-1] << '\'' << endl;
						Warning("base 64 decode error: illegal character");
						return false;
--- src/basic_fun.cpp.orig	2014-10-10 23:18:05.000000000 +0200
+++ src/basic_fun.cpp	2014-10-10 23:21:54.000000000 +0200
@@ -6483,7 +6483,7 @@
       while (p < e)
       {
         // scheme = 1*[ lowalpha | digit | "+" | "-" | "." ]
-        if (!(isalpha(*p)) && !(isdigit(*p)) && (*p != '+') && (*p != '.') && (*p != '-'))
+        if (!(std::isalpha(*p)) && !(std::isdigit(*p)) && (*p != '+') && (*p != '.') && (*p != '-'))
         {
           if (e + 1 < ue) goto parse_port;
           else goto just_path;
@@ -6501,7 +6501,7 @@
       {
         // check if the data we get is a port this allows us to correctly parse things like a.com:80
         p = e + 1;
-        while (isdigit(*p)) p++;
+        while (std::isdigit(*p)) p++;
	if ((*p == '\0' || *p == '/') && (p - e) < 7) goto parse_port;
         urlstru->InitTag("SCHEME", DStringGDL(string(s, (e - s))));
         length -= ++e - s;
--- src/gsl_fun.cpp.orig	2014-10-09 22:55:52.000000000 +0200
+++ src/gsl_fun.cpp	2014-10-09 22:55:52.000000000 +0200
@@ -3183,7 +3183,7 @@
       e->AssureScalarPar<DStringGDL>(0, tmpname);
       name.reserve(tmpname.length());
       for (string::iterator it = tmpname.begin(); it < tmpname.end(); it++)
-        if (*it != ' ' && *it != '_') name.append(1, (char)tolower(*it));
+        if (*it != ' ' && *it != '_') name.append(1, (char)std::tolower(*it));
     }

 #ifdef USE_UDUNITS
--- ./src/str.cpp.orig	2014-04-08 16:53:53.954118000 +0200
+++ ./src/str.cpp	2014-04-08 16:58:59.524163473 +0200
@@ -180,7 +180,7 @@
   ArrayGuard<char> guard( r);
   r[len]=0;
   for(unsigned i=0;i<len;i++)
-    r[i]=toupper(sCStr[i]);
+    r[i]=std::toupper(sCStr[i]);
   return string(r);
 }
 void StrUpCaseInplace( string& s)
@@ -191,7 +191,7 @@
 //   ArrayGuard<char> guard( r);
 //   r[len]=0;
   for(unsigned i=0;i<len;i++)
-    s[i]=toupper(s[i]);
+    s[i]=std::toupper(s[i]);
 //   return string(r);
 }

@@ -203,7 +203,7 @@
   ArrayGuard<char> guard( r);
   r[len]=0;
   for(unsigned i=0;i<len;i++)
-    r[i]=tolower(sCStr[i]);
+    r[i]=std::tolower(sCStr[i]);
   return string(r);
 }
 void StrLowCaseInplace(string& s)
@@ -211,7 +211,7 @@
   unsigned len=s.length();
 //   char const *sCStr=s.c_str();
   for(unsigned i=0;i<len;i++)
-    s[i]=tolower(s[i]);
+    s[i]=std::tolower(s[i]);
 //     s[i]=tolower(sCStr[i]);
 }
