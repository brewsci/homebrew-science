class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "http://www.unidata.ucar.edu/software/netcdf"
  url "ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz"
  mirror "http://www.gfd-dennou.org/library/netcdf/unidata-mirror/netcdf-4.4.1.1.tar.gz"
  sha256 "4d44c6f4d02a8faf10ea619bfe1ba8224cd993024f4da12988c7465f663c8cae"
  revision 1

  bottle do
    sha256 "71d54671e62356bcb8222975e77007a672872d33dc5f1ccea3075e1997d797c8" => :sierra
    sha256 "8b5d11f39124e32a3e324218f97b35c211f06656c4e12b47909deb6ce72d953c" => :el_capitan
    sha256 "6014370fd4e9d2f09e829233db402e1a9d34fa8c2ddafbc9d8d92def3d503d60" => :yosemite
  end

  option "without-cxx", "Don't compile C++ bindings"
  option "with-cxx-compat", "Compile C++ bindings for compatibility"
  option "without-test", "Disable checks (not recommended)"

  deprecated_option "enable-fortran" => "with-fortran"
  deprecated_option "disable-cxx" => "without-cxx"
  deprecated_option "enable-cxx-compat" => "with-cxx-compat"
  deprecated_option "without-check" => "without-test"

  depends_on "cmake" => :build
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
    ENV.deparallelize
    if build.with? "fortran"
      # fix for ifort not accepting the --force-load argument, causing
      # the library libnetcdff.dylib to be missing all the f90 symbols.
      # http://www.unidata.ucar.edu/software/netcdf/docs/known_problems.html#intel-fortran-macosx
      # https://github.com/mxcl/homebrew/issues/13050
      ENV["lt_cv_ld_force_load"] = "no" if ENV.fc == "ifort"
    end

    common_args = std_cmake_args + %w[
      -DBUILD_SHARED_LIBS=ON
      -BUILD_TESTING=ON
      -BUILD_TESTSETS=ON
    ]

    mkdir "build" do
      # Intermittent availability of the DAP endpoints tests means that sometimes
      # a perfectly working build fails. This has been documented
      # [by others](http://www.unidata.ucar.edu/support/help/MailArchives/netcdf/msg12090.html),
      # and distributions like PLD linux
      # [also disable these tests](http://lists.pld-linux.org/mailman/pipermail/pld-cvs-commit/Week-of-Mon-20110627/314985.html)
      # because of this issue.
      args = common_args.clone
      args << "-DENABLE_DAP_AUTH_TESTS=OFF" << "-DENABLE_NETCDF_4=ON" << "-DENABLE_DOXYGEN=OFF"
      args << ".."

      system "cmake", *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end

    # Add newly created installation to paths so that binding libraries can
    # find the core libs.
    args = common_args.clone
    args << "-DNETCDF_C_LIBRARY=#{lib}"
    args << ".."

    if build.with? "cxx"
      resource("cxx").stage do
        mkdir "build-cxx" do
          system "cmake", *args
          system "make"
          system "make", "test" if build.with? "test"
          system "make", "install"
        end
      end
    end

    if build.with? "cxx-compat"
      resource("cxx-compat").stage do
        mkdir "build-cxx-compat" do
          system "cmake", *args
          system "make"
          system "make", "test" if build.with? "test"
          system "make", "install"
        end
      end
    end

    if build.with? "fortran"
      resource("fortran").stage do
        mkdir "build-fortran" do
          system "cmake", *args
          system "make"
          system "make", "test" if build.with? "test"
          system "make", "install"
        end
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
