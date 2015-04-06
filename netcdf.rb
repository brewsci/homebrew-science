class Netcdf < Formula
  homepage "http://www.unidata.ucar.edu/software/netcdf"
  url "ftp://ftp.unidata.ucar.edu/pub/netcdf/old/netcdf-4.3.2.tar.gz"
  mirror "http://www.gfd-dennou.org/library/netcdf/unidata-mirror/old/netcdf-4.3.2.tar.gz"
  sha256 "57086b4383ce9232f05aad70761c2a6034b1a0c040260577d369b3bbfe6d248e"
  revision 2

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "a39f1334dd22660576e0b8532f24b5e9109808b97e340d79122d63c85850c452" => :yosemite
    sha256 "939e80bf768bd82cefe0dbd79e7d566de784c8b002a0ca83a20dddd4ff10795e" => :mavericks
    sha256 "e34e32cecf44dd109609ce5c2245c6e8e9709379c3f2c273c8e159102aa8da91" => :mountain_lion
  end

  deprecated_option "enable-fortran" => "with-fortran"
  deprecated_option "disable-cxx" => "without-cxx"
  deprecated_option "enable-cxx-compat" => "with-cxx-compat"

  option "without-cxx", "Don't compile C++ bindings"
  option "with-cxx-compat", "Compile C++ bindings for compatibility"
  option "without-check", "Disable checks (not recommended)"

  depends_on :fortran => :optional
  depends_on "hdf5"

  resource "cxx" do
    url "https://github.com/Unidata/netcdf-cxx4/archive/v4.2.1.tar.gz"
    sha256 "bad56abfc99f321829070c04aebb377fc8942a4d09e5a3c88ad2b6547ed50ebc"
  end

  resource "cxx-compat" do
    url "http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx-4.2.tar.gz"
    mirror "http://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-cxx-4.2.tar.gz"
    sha256 "95ed6ab49a0ee001255eac4e44aacb5ca4ea96ba850c08337a3e4c9a0872ccd1"
  end

  resource "fortran" do
    url "http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.4.1.tar.gz"
    mirror "http://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-fortran-4.4.1.tar.gz"
    sha256 "9f3ee25e55aa61d69eab95c6ac059b2bbdbe287005a63faa292c70c02d98d4b8"
  end

  # HDF5 1.8.13 removes symbols related to MPI POSIX VFD, leading to
  # errors when linking hdf5 and netcdf5 such as "undefined reference to
  # `_H5Pset_fapl_mpiposix`". This patch fixes those errors, and has been
  # added upstream. It should be unnecessary once NetCDF releases a new
  # stable version.
  patch do
    url "https://github.com/Unidata/netcdf-c/commit/435d8a03ed28bb5ad63aff12cbc6ab91531b6bc8.diff"
    sha1 "770ee66026e4625b80711174600fb8c038b48f5e"
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
    ENV.deparallelize if build.with? "check" # Required for `make check`.
    system "make", "check" if build.with? "check"
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
        system "make", "check" if build.with? "check"
        system "make", "install"
      end
    end

    if build.with? "cxx-compat"
      resource("cxx-compat").stage do
        system "./configure", *common_args
        system "make"
        system "make", "check" if build.with? "check"
        system "make", "install"
      end
    end

    if build.with? "fortran"
      resource("fortran").stage do
        system "./configure", *common_args
        system "make"
        system "make", "check" if build.with? "check"
        system "make", "install"
      end
    end
  end
end
