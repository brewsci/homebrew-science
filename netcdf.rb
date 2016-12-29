class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "http://www.unidata.ucar.edu/software/netcdf"
  url "ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz"
  mirror "http://www.gfd-dennou.org/library/netcdf/unidata-mirror/netcdf-4.4.1.1.tar.gz"
  sha256 "4d44c6f4d02a8faf10ea619bfe1ba8224cd993024f4da12988c7465f663c8cae"

  bottle do
    cellar :any
    sha256 "3d36f340ba0e51aca1a31528b351fc4420f1d8fd9efd08fafb6b901420d634a1" => :sierra
    sha256 "c707bcaafe1b95b3ad70212b3d54bb33d3f42327f4c72a74585e16433edf17bd" => :el_capitan
    sha256 "276d6bf376b82e7fc89097e205ee1ac173cf23f1681870e1028247366c85029e" => :yosemite
    sha256 "71f7085b4fb4df95bd2314c733562ed77a75cf1e8754c74f19366b84cd8cb16d" => :x86_64_linux
  end

  option "without-cxx", "Don't compile C++ bindings"
  option "with-cxx-compat", "Compile C++ bindings for compatibility"
  option "without-test", "Disable checks (not recommended)"

  deprecated_option "enable-fortran" => "with-fortran"
  deprecated_option "disable-cxx" => "without-cxx"
  deprecated_option "enable-cxx-compat" => "with-cxx-compat"
  deprecated_option "without-check" => "without-test"

  depends_on :fortran => :optional
  depends_on "hdf5"

  resource "cxx" do
    url "https://github.com/Unidata/netcdf-cxx4/archive/v4.3.0.tar.gz"
    sha256 "25da1c97d7a01bc4cee34121c32909872edd38404589c0427fefa1301743f18f"
  end

  resource "cxx-compat" do
    url "http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx-4.2.tar.gz"
    mirror "http://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-cxx-4.2.tar.gz"
    sha256 "95ed6ab49a0ee001255eac4e44aacb5ca4ea96ba850c08337a3e4c9a0872ccd1"
  end

  resource "fortran" do
    url "ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.4.tar.gz"
    mirror "http://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-fortran-4.4.4.tar.gz"
    sha256 "b2d395175f8d283e68c8be516e231a96b191ade67ad0caafaf7fa01b1e6b5d75"
  end

  def install
    if build.with? "fortran"
      # fix for ifort not accepting the --force-load argument, causing
      # the library libnetcdff.dylib to be missing all the f90 symbols.
      # http://www.unidata.ucar.edu/software/netcdf/docs/known_problems.html#intel-fortran-macosx
      # https://github.com/mxcl/homebrew/issues/13050
      ENV["lt_cv_ld_force_load"] = "no" if ENV.fc == "ifort"
    end

    # Intermittent availability of the DAP endpoints tested means that sometimes
    # a perfectly working build fails. This has been documented
    # [by others](http://www.unidata.ucar.edu/support/help/MailArchives/netcdf/msg12090.html),
    # and distributions like PLD linux
    # [also disable these tests](http://lists.pld-linux.org/mailman/pipermail/pld-cvs-commit/Week-of-Mon-20110627/314985.html)
    # because of this issue.

    common_args = %W[
      --disable-dependency-tracking
      --disable-dap-remote-tests
      --prefix=#{prefix}
      --enable-static
      --enable-shared
    ]

    args = common_args.clone
    args << "--enable-netcdf4" << "--disable-doxygen"

    system "./configure", *args
    system "make"
    ENV.deparallelize if build.with? "test" # Required for `make check`.
    system "make", "check" if build.with? "test"
    system "make", "install"

    # Add newly created installation to paths so that binding libraries can
    # find the core libs.
    ENV.prepend_path "PATH", bin
    ENV.prepend "CPPFLAGS", "-I#{include}"
    ENV.prepend "LDFLAGS", "-L#{lib}"

    if build.with? "cxx"
      resource("cxx").stage do
        system "./configure", *common_args
        system "make"
        system "make", "check" if build.with? "test"
        system "make", "install"
      end
    end

    if build.with? "cxx-compat"
      resource("cxx-compat").stage do
        system "./configure", *common_args
        system "make"
        system "make", "check" if build.with? "test"
        system "make", "install"
      end
    end

    if build.with? "fortran"
      resource("fortran").stage do
        # fixes "error while loading shared libraries: libnetcdf.so.7".
        # see https://github.com/Homebrew/homebrew-science/issues/2521#issuecomment-121851582
        # this should theoretically be enough: ENV.prepend "LDFLAGS", "-L#{lib}", but it is not.
        ENV.prepend "LD_LIBRARY_PATH", lib
        system "./configure", *common_args
        system "make"
        system "make", "check" if build.with? "test"
        system "make", "install"
      end
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "netcdf_meta.h"
      int main()
      {
        printf(NC_VERSION);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lnetcdf", "-o", "test"
    assert_equal `./test`, version.to_s
  end
end
