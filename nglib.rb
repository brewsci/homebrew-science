class Nglib < Formula
  desc "C++ Library of NETGEN's tetrahedral mesh generator"
  homepage "https://sourceforge.net/projects/netgen-mesher/"
  url "https://downloads.sourceforge.net/project/netgen-mesher/netgen-mesher/5.3/netgen-5.3.1.tar.gz"
  sha256 "cb97f79d8f4d55c00506ab334867285cde10873c8a8dc783522b47d2bc128bf9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "89dcf7bde5bec5a03f8c6810cfb5848082c64f68bcdd816714f0f925b98fd3b5" => :sierra
    sha256 "6eb7f3cf7a00c68f351816970408f780264855d7d86365a427d19c81e803d606" => :el_capitan
    sha256 "60161c1f084017f4ff9ece29807988924137150e979f176d2ad4ebad3e0fd64c" => :yosemite
  end

  # These two conflict with each other, so we'll have at most one.
  depends_on "opencascade" => :optional
  depends_on "oce" => :optional

  # Patch three issues:
  #   Makefile - remove TCL scripts that aren't reuquired without NETGEN.
  #   configure - remove TCL libs that caused issues with ld (#3624).
  #   Partition_Loop2d.cxx - Fix PI that was used rather than M_PI
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gui
      --enable-nglib
    ]

    if build.with?("opencascade") || build.with?("oce")
      args << "--enable-occ"

      cad_kernel = Formula[build.with?("opencascade") ? "opencascade" : "oce"]

      if build.with? "opencascade"
        args << "--with-occ=#{cad_kernel.opt_prefix}/include"

        # A couple mesh output functions were dropped in OpenCASCADE 6.8.1
        # Would fix via patch, but the relevant files has windows line endings,
        # which seem to cause problems when embedded in DATA section patches.
        system "sed", "-i", "-e", "s/\\(.*RelativeMode.*\\)/\\/\\/ \\1/",
          "#{buildpath}/libsrc/occ/occgeom.cpp"
        system "sed", "-i", "-e", "s/\\(.*SetDeflection.*\\)/\\/\\/ \\1/",
          "#{buildpath}/libsrc/occ/occgeom.cpp"
      else
        args << "--with-occ=#{cad_kernel.opt_prefix}/include/oce"

        # These fix problematic hard-coded paths in the netgen make file
        args << "CPPFLAGS=-I#{cad_kernel.opt_prefix}/include/oce"
        args << "LDFLAGS=-L#{cad_kernel.opt_prefix}/lib/"
      end
    end

    system "./configure", *args

    system "make", "install"

    # The nglib installer doesn't include some important headers by default.
    # This follows a pattern used on other platforms to make a set of sub
    # directories within include/ to contain these headers.
    subdirs = ["csg", "general", "geom2d", "gprim", "include", "interface",
               "linalg", "meshing", "occ", "stlgeom", "visualization"]
    subdirs.each do |subdir|
      (include/"netgen"/subdir).mkpath
      (include/"netgen"/subdir).install Dir.glob("libsrc/#{subdir}/*.{h,hpp}")
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include<iostream>
      namespace nglib {
          #include <nglib.h>
      }
      int main(int argc, char **argv) {
          nglib::Ng_Init();
          nglib::Ng_Mesh *mesh(nglib::Ng_NewMesh());
          nglib::Ng_DeleteMesh(mesh);
          nglib::Ng_Exit();
          return 0;
      }
    EOS
    system ENV.cxx, "-Wall", "-o", "test", "test.cpp",
           "-I#{include}", "-L#{lib}", "-lnglib"
    system "./test"
  end
end

__END__
diff -ur a/configure b/configure
--- a/configure	2014-10-07 00:04:36.000000000 +1300
+++ b/configure	2016-11-12 21:43:00.000000000 +1300
@@ -15354,7 +15354,7 @@

	OCCFLAGS="-DOCCGEOMETRY -I$occdir/inc -I/usr/include/opencascade"

-	OCCLIBS="-L$occdir/lib -lTKernel -lTKGeomBase -lTKMath -lTKG2d -lTKG3d -lTKXSBase -lTKOffset -lTKFillet -lTKShHealing -lTKMesh -lTKMeshVS -lTKTopAlgo -lTKGeomAlgo -lTKBool -lTKPrim -lTKBO -lTKIGES -lTKBRep -lTKSTEPBase -lTKSTEP -lTKSTL -lTKSTEPAttr -lTKSTEP209 -lTKXDESTEP -lTKXDEIGES -lTKXCAF -lTKLCAF -lFWOSPlugin"
+	OCCLIBS="-L$occdir/lib -lFWOSPlugin"


 #  -lTKDCAF
diff -ur a/libsrc/occ/Partition_Loop2d.cxx b/libsrc/occ/Partition_Loop2d.cxx
--- a/libsrc/occ/Partition_Loop2d.cxx	2016-03-16 07:44:06.000000000 -0700
+++ b/libsrc/occ/Partition_Loop2d.cxx	2016-03-16 07:45:40.000000000 -0700
@@ -52,6 +52,10 @@
 #include <gp_Pnt.hxx>
 #include <gp_Pnt2d.hxx>

+#ifndef PI
+    #define PI M_PI
+#endif
+
 //=======================================================================
 //function : Partition_Loop2d
 //purpose  :
diff -ur a/ng/Makefile.in b/ng/Makefile.in
--- a/ng/Makefile.in	2014-10-06 04:04:37.000000000 -0700
+++ b/ng/Makefile.in	2016-03-19 14:43:51.000000000 -0700
@@ -327,10 +327,7 @@
 #   /opt/netgen/lib/libngsolve.a /opt/netgen/lib/libngcomp.a /opt/netgen/lib/libngcomp.a  /opt/netgen/lib/libngfemng.a   /opt/netgen/lib/libngmg.a  /opt/netgen/lib/libngla.a  /opt/netgen/lib/libngbla.a  /opt/netgen/lib/libngstd.a -L/opt/intel/mkl/10.2.1.017/lib/em64t /opt/intel/mkl/10.2.1.017/lib/em64t/libmkl_solver_lp64.a  -lmkl_intel_lp64  -lmkl_gnu_thread -lmkl_core
 #
 #
-dist_bin_SCRIPTS = dialog.tcl menustat.tcl ngicon.tcl ng.tcl	  \
-ngvisual.tcl sockets.tcl drawing.tcl nghelp.tcl ngshell.tcl	  \
-ngtesting.tcl parameters.tcl variables.tcl csgeom.tcl stlgeom.tcl \
-occgeom.tcl acisgeom.tcl netgen.ocf
+dist_bin_SCRIPTS =

 netgen_LDFLAGS = -export-dynamic
 all: all-am
