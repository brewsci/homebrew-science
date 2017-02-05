class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "http://www.unidata.ucar.edu/software/netcdf"
  url "ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz"
  mirror "http://www.gfd-dennou.org/library/netcdf/unidata-mirror/netcdf-4.4.1.1.tar.gz"
  sha256 "4d44c6f4d02a8faf10ea619bfe1ba8224cd993024f4da12988c7465f663c8cae"
  revision 3

  bottle do
    rebuild 2
    sha256 "c8c7d60ce50d6af7d17122784f03396b85e70fd8a4dd14260ef79a043156d8b2" => :sierra
    sha256 "55757134f743263e28ca881a3b03bcacfe6af408785196034cb7cdc930338008" => :el_capitan
    sha256 "4c31f4391b95c8e3be88dc7da05403c3ddfdc711d9b38587f36368b4947d1ec6" => :yosemite
  end

  option "without-test", "Disable checks (not recommended)"

  deprecated_option "without-check" => "without-test"
  deprecated_option "enable-fortran" => "with-fortran"

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on :fortran => :optional

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

    common_args = std_cmake_args << "-DBUILD_SHARED_LIBS=ON"
    common_args << "-DBUILD_TESTING=OFF" if build.without? "test"

    mkdir "build" do
      # Intermittent availability of the DAP endpoints tests means that sometimes
      # a perfectly working build fails. This has been documented
      # [by others](http://www.unidata.ucar.edu/support/help/MailArchives/netcdf/msg12090.html),
      # and distributions like PLD linux
      # [also disable these tests](http://lists.pld-linux.org/mailman/pipermail/pld-cvs-commit/Week-of-Mon-20110627/314985.html)
      # because of this issue.
      args = common_args.dup
      args << "-DENABLE_TESTS=OFF" if build.without? "test"
      args << "-DNC_EXTRA_DEPS=-lmpi" if Tab.for_name("hdf5").with? "mpi"
      args << "-DENABLE_DAP_AUTH_TESTS=OFF" << "-DENABLE_NETCDF_4=ON" << "-DENABLE_DOXYGEN=OFF"

      system "cmake", "..", *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end

    # Add newly created installation to paths so that binding libraries can
    # find the core libs.
    args = common_args.dup << "-DNETCDF_C_LIBRARY=#{lib}"

    cxx_args = args.dup
    cxx_args << "-DNCXX_ENABLE_TESTS=OFF" if build.without? "test"
    resource("cxx").stage do
      mkdir "build-cxx" do
        system "cmake", "..", *cxx_args
        system "make"
        system "make", "test" if build.with? "test"
        system "make", "install"
      end
    end

    if build.with? "fortran"
      fortran_args = args.dup
      fortran_args << "-DENABLE_TESTS=OFF" if build.without? "test"
      resource("fortran").stage do
        mkdir "build-fortran" do
          system "cmake", "..", *fortran_args
          system "make"
          system "make", "test" if build.with? "test"
          system "make", "install"
        end
      end
    end

    ENV.prepend "CPPFLAGS", "-I#{include}"
    ENV.prepend "LDFLAGS", "-L#{lib}"
    resource("cxx-compat").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
      system "make", "install"
      if build.with? "test"
        cp Dir["#{lib}/*.dylib"], "cxx/.libs/"
        system "make", "check"
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
