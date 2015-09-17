class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "http://www.hdfgroup.org/HDF5"
  url "http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.15-patch1.tar.bz2"
  version "1.8.15"
  sha256 "a5afc630c4443547fff15e9637b5b10404adbed4c00206d89517d32d6668fb32"

  bottle do
    sha256 "5b021fb5ee7c2c95b091988b0184e109caa6dd33bee61f5478fbb1b431d00cb3" => :el_capitan
    sha256 "59253092e8b149b463a79e14daf40feb53863fb80c55756413d90f8c056fa0d4" => :yosemite
    sha256 "eaaa0d43934b3719b51777cd9ed110691e711a9370e60c83552fc965af2f828a" => :mavericks
  end

  deprecated_option "enable-fortran" => "with-fortran"
  deprecated_option "enable-threadsafe" => "with-threadsafe"
  deprecated_option "enable-parallel" => "with-mpi"
  deprecated_option "enable-fortran2003" => "with-fortran2003"
  deprecated_option "enable-cxx" => "with-cxx"

  option :universal
  option "with-check", "Run build-time tests"
  option "with-threadsafe", "Trade performance for C API thread-safety"
  option "with-fortran2003", "Compile Fortran 2003 bindings (requires --with-fortran)"
  option "with-mpi", "Compile with parallel support (unsupported with thread-safety)"
  option "without-cxx", "Disable the C++ interface"
  option :cxx11

  depends_on :fortran => :optional
  depends_on "szip"
  depends_on :mpi => [:optional, :cc, :cxx, :f90]

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --prefix=#{prefix}
      --enable-production
      --enable-debug=no
      --disable-dependency-tracking
      --with-zlib=/usr
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-static=yes
      --enable-shared=yes
      --enable-unsupported
    ]
    args << "--enable-threadsafe" << "--with-pthread=/usr" if build.with? "threadsafe"

    if build.with? "cxx"
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
    system "make", "check" if build.with?("check") || build.bottle?
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
    system "h5cc", "test.c"
    assert_match(/#{version}/, shell_output("./a.out"))
  end
end
