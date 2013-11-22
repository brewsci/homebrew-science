require 'formula'

class Netcdf < Formula
  homepage 'http://www.unidata.ucar.edu/software/netcdf'
  url 'ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.3.0.tar.gz'
  mirror 'http://www.gfd-dennou.org/library/netcdf/unidata-mirror/netcdf-4.3.0.tar.gz'
  sha1 '246e4963e66e1c175563cc9a714e9da0a19b8b07'

  depends_on :fortran if build.include? 'enable-fortran'
  depends_on 'hdf5'

  option 'enable-fortran', 'Compile Fortran bindings'
  option 'disable-cxx', "Don't compile C++ bindings"
  option 'enable-cxx-compat', 'Compile C++ bindings for compatibility'
  option 'without-check', 'Disable checks (not recommended)'

  resource 'cxx' do
    url 'https://github.com/Unidata/netcdf-cxx4/archive/v4.2.1.tar.gz'
    sha1 '0bb4a0807f10060f98745e789b6dc06deddf30ff'
  end

  resource 'cxx-compat' do
    url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx-4.2.tar.gz'
    sha1 'bab9b2d873acdddbdbf07ab35481cd0267a3363b'
  end

  resource 'fortran' do
    url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.2.tar.gz'
    sha1 'f1887314455330f4057bc8eab432065f8f6f74ef'
  end

  def patches
    # Fix clang issue on Mavericks
    # http://www.unidata.ucar.edu/software/netcdf/docs/known_problems.html#clang-ncgen3
    DATA
  end

  def install
    if build.include? 'enable-fortran'
      # fix for ifort not accepting the --force-load argument, causing
      # the library libnetcdff.dylib to be missing all the f90 symbols.
      # http://www.unidata.ucar.edu/software/netcdf/docs/known_problems.html#intel-fortran-macosx
      # https://github.com/mxcl/homebrew/issues/13050
      ENV['lt_cv_ld_force_load'] = 'no' if ENV.fc == 'ifort'
    end

    common_args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-static
      --enable-shared
    ]

    args = common_args.clone
    args.concat %w[--enable-netcdf4 --disable-doxygen]

    system './configure', *args
    system 'make'
    ENV.deparallelize if build.with? 'check' # Required for `make check`.
    system 'make check' if build.with? 'check'
    system 'make install'

    # Add newly created installation to paths so that binding libraries can
    # find the core libs.
    ENV.prepend_path 'PATH', bin
    ENV.prepend 'CPPFLAGS', "-I#{include}"
    ENV.prepend 'LDFLAGS', "-L#{lib}"

    resource('cxx').stage do
      system './configure', *common_args
      system 'make'
      system 'make check' if build.with? 'check'
      system 'make install'
    end unless build.include? 'disable-cxx'

    resource('cxx-compat').stage do
      system './configure', *common_args
      system 'make'
      system 'make check' if build.with? 'check'
      system 'make install'
    end if build.include? 'enable-cxx-compat'

    resource('fortran').stage do
      system './configure', *common_args
      system 'make'
      system 'make check' if build.with? 'check'
      system 'make install'
    end if build.include? 'enable-fortran'
  end
end

__END__
index d34f85d..276fb6a 100644
--- a/ncgen3/genlib.h
+++ b/ncgen3/genlib.h
@@ -7,6 +7,7 @@
  *********************************************************************/
 #include <stdlib.h>
 #include <limits.h>
+#include "config.h"

 extern const char *progname;   /* for error messages */
 extern const char *cdlname;    /* for error messages */
