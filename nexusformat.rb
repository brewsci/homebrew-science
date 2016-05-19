class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/4.3.3.tar.gz"
  sha256 "fef979ded3b2b4a455514671eac4483d431aeb7c8b25428bbb666bc7d50cace3"

  option :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libmxml"
  depends_on "readline" => :recommended
  if build.cxx11?
    depends_on "hdf5" => "c++11"
  else
    depends_on "hdf5"
  end
  depends_on "homebrew/versions/hdf4" => :recommended
  depends_on "doxygen" => :optional

  # make check fails to find libNeXus.0.dylib
  # https://github.com/nexusformat/code/issues/427
  patch :DATA if MacOS.version >= :el_capitan

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-debug
      --with-hdf4=#{Formula["homebrew/versions/hdf4"].opt_prefix}
    ]
    system "/bin/sh", "autogen.sh"
    ENV.cxx11 if build.cxx11?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/nxdir"
  end
end

__END__
diff --git a/test/Makefile.am b/test/Makefile.am
index 9e866e5..c768d20 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -118,7 +118,7 @@ nxtranslate:

 # this sets the test running environment - in case we
 # have got built with shared HDF libraries we need to set LD_LIBRARY_PATH
-TESTS_ENVIRONMENT=env PYTHON=$(PYTHON) IDL_PATH="@abs_top_srcdir@/bindings/idl:<IDL_DEFAULT>" IDL_DLM_PATH="@abs_top_builddir@/bindings/idl:<IDL_DEFAULT>" LD_LIBRARY_PATH=@abs_top_builddir@/src/.libs:@abs_top_builddir@/bindings/cpp/.libs:@abs_top_builddir@/bindings/idl:$${LD_LIBRARY_PATH}:@EXTRA_LD_LIBRARY_PATH@:/usr/local/lib DYLD_LIBRARY_PATH=@abs_top_builddir@/src/.libs:@abs_top_builddir@/bindings/cpp/.libs:@abs_top_builddir@/bindings/idl:$${DYLD_LIBRARY_PATH}:@EXTRA_LD_LIBRARY_PATH@:/usr/local/lib
+TESTS_ENVIRONMENT=env PYTHON=$(PYTHON) IDL_PATH="@abs_top_srcdir@/bindings/idl:<IDL_DEFAULT>" IDL_DLM_PATH="@abs_top_builddir@/bindings/idl:<IDL_DEFAULT>" LD_LIBRARY_PATH=@abs_top_builddir@/src/.libs:@abs_top_builddir@/bindings/cpp/.libs:@abs_top_builddir@/bindings/idl:$${LD_LIBRARY_PATH}:@EXTRA_LD_LIBRARY_PATH@:/usr/local/lib DYLD_LIBRARY_PATH=@abs_top_builddir@/src/.libs:@abs_top_builddir@/bindings/cpp/.libs:@abs_top_builddir@/bindings/idl:$${DYLD_LIBRARY_PATH}:@EXTRA_LD_LIBRARY_PATH@:/usr/local/lib NEXUSLIB=@abs_top_builddir@/src/.libs/libNeXus.0.dylib

 run_test_SOURCES=run_test.c
 run_test_LDFLAGS=-static $(HDF4_LDFLAGS) $(HDF5_LDFLAGS) $(XML_LDFLAGS) $(LDFLAGS)
