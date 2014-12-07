require "formula"

class Netcdf < Formula
  homepage "http://www.unidata.ucar.edu/software/netcdf"
  url "ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.3.2.tar.gz"
  mirror "http://www.gfd-dennou.org/library/netcdf/unidata-mirror/netcdf-4.3.2.tar.gz"
  sha1 "6e1bacab02e5220954fe0328d710ebb71c071d19"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "af12e8d6b0cf4afee76f944ae97ccb174e297819" => :yosemite
    sha1 "d20838cd139c3022429ba0fa28e4ba2f6ef2ae3c" => :mavericks
    sha1 "a4857f759d7b05df9fb318c7f2a78b400e5c4db8" => :mountain_lion
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
    sha1 "0bb4a0807f10060f98745e789b6dc06deddf30ff"
  end

  resource "cxx-compat" do
    url "http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx-4.2.tar.gz"
    mirror "http://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-cxx-4.2.tar.gz"
    sha1 "bab9b2d873acdddbdbf07ab35481cd0267a3363b"
  end

  resource "fortran" do
    url "http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.4.1.tar.gz"
    mirror "http://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-fortran-4.4.1.tar.gz"
    sha1 "452a1b7ef12cbcace770dcc728a7b425cf7fb295"
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
