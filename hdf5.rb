class Hdf5 < Formula
  homepage "http://www.hdfgroup.org/HDF5"
  url "http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.14/src/hdf5-1.8.14.tar.bz2"
  sha1 "3c48bcb0d5fb21a3aa425ed035c08d8da3d5483a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 2
    sha256 "167816e82ce219b054419289c29debb70638ae25d8013c53485d1e31868e3905" => :yosemite
    sha256 "54de74a2a43c4802ab5c94f406655af72058f707366799611a5d7dfb8194952e" => :mavericks
    sha256 "bcbe32e875373859b9871cf33c2c0f152d7fcad052fd83d9a2f533e19eb04a8e" => :mountain_lion
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
      --enable-filters=all
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
    (testpath/"test.cpp").write <<-EOS.undent
      #include <stdio.h>
      #include "H5public.h"
      int main()
      {
        printf(\"%d.%d.%d\\n\",H5_VERS_MAJOR,H5_VERS_MINOR,H5_VERS_RELEASE);
        return 0;
      }
    EOS
    system "h5cc", "test.cpp"
    assert `./a.out`.include?(version)
  end
end
