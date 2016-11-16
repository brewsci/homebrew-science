class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "http://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.18.tar.bz2"
  sha256 "01c6deadf4211f86922400da82c7a8b5b50dc8fc1ce0b5912de3066af316a48c"

  bottle do
    sha256 "d025f1b8f3559742c9d3e713f82fd89f80d2d1d7fbd2ad3da1b456ffa4031c88" => :sierra
    sha256 "11afa17299b35cf660cb4d330e2c23962dd8d56d94c76a792d50a109e048fe6a" => :el_capitan
    sha256 "f723827a399c907f1f36d32f7f16f3d758b1b3fc3d0a93492fe67a80101b4a6e" => :yosemite
    sha256 "22841e96b70ac08d949102c60acbaa94cc24954685b6e3a0bfdf86ef4bb700ee" => :x86_64_linux
  end

  deprecated_option "enable-fortran" => "with-fortran"
  deprecated_option "enable-threadsafe" => "with-threadsafe"
  deprecated_option "enable-parallel" => "with-mpi"
  deprecated_option "enable-fortran2003" => "with-fortran2003"
  deprecated_option "enable-cxx" => "with-cxx"
  deprecated_option "with-check" => "with-test"

  option :universal
  option "with-test", "Run build-time tests"
  option "with-threadsafe", "Trade performance for C API thread-safety"
  option "with-fortran2003", "Compile Fortran 2003 bindings (requires --with-fortran)"
  option "with-mpi", "Compile with parallel support (unsupported with thread-safety)"
  option "without-cxx", "Disable the C++ interface"
  option "with-unsupported", "Allow unsupported combinations of configure options"
  option :cxx11

  depends_on :fortran => :optional
  depends_on "szip"
  depends_on :mpi => [:optional, :cc, :cxx, :f90]
  depends_on "zlib" unless OS.mac?

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.universal_binary if build.universal?

    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in tools/misc/h5cc.in],
      "${libdir}/libhdf5.settings", "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am", "settingsdir=$(libdir)",
                                 "settingsdir=#{pkgshare}"

    system "autoreconf", "-fiv"

    args = %W[
      --prefix=#{prefix}
      --enable-production
      --enable-debug=no
      --disable-dependency-tracking
      --with-zlib=#{OS.mac? ? "/usr" : Formula["zlib"].opt_prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-static=yes
      --enable-shared=yes
    ]
    args << "--enable-unsupported" if build.with? "unsupported"
    args << "--enable-threadsafe" << "--with-pthread=/usr" if build.with? "threadsafe"

    if build.with?("cxx") && build.without?("mpi")
      args << "--enable-cxx"
    else
      args << "--disable-cxx"
    end

    if build.with? "fortran"
      args << "--enable-fortran"
      args << "--enable-fortran2003" if build.with? "fortran2003"
    else
      args << "--disable-fortran"
    end

    if build.with? "mpi"
      args << "--enable-parallel"
      ENV["CC"] = ENV["MPICC"]
      ENV["CXX"] = ENV["MPICXX"]
      ENV["FC"] = ENV["MPIFC"]
    end

    system "./configure", *args
    system "make"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf(\"%d.%d.%d\\n\",H5_VERS_MAJOR,H5_VERS_MINOR,H5_VERS_RELEASE);
        return 0;
      }
    EOS
    system "#{bin}/h5cc", "test.c"
    assert_match(/#{version}/, shell_output("./a.out"))
  end
end
