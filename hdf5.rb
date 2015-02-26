class Hdf5 < Formula
  homepage "http://www.hdfgroup.org/HDF5"
  url "http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.14/src/hdf5-1.8.14.tar.bz2"
  sha1 "3c48bcb0d5fb21a3aa425ed035c08d8da3d5483a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 1
    sha1 "bb05237bc790a3ee91fe29ee156fca1e99bede36" => :yosemite
    sha1 "52c328ec0133756690f6d38ac24ed943806e85fb" => :mavericks
    sha1 "b7e1cd355a8d64bffc87b0143ce207ca8541a0ec" => :mountain_lion
  end

  deprecated_option "enable-fortran" => "with-fortran"
  deprecated_option "enable-threadsafe" => "with-threadsafe"
  deprecated_option "enable-parallel" => "with-mpi"
  deprecated_option "enable-fortran2003" => "with-fortran2003"
  deprecated_option "enable-cxx" => "with-cxx"

  option :universal
  option "with-check", "Run build-time tests"
  option "with-threadsafe", "Trade performance and C++ or Fortran support for thread safety"
  option "with-fortran2003", "Compile Fortran 2003 bindings. Requires with-fortran"
  option "with-cxx", "Compile C++ bindings"
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
    ]

    args << "--enable-parallel" if build.with? :mpi

    if build.with? "threadsafe"
      fail "--enable-threadsafe conflicts with Fortran bindings" if build.with? :fortran
      fail "--enable-threadsafe conflicts with C++ support" if build.cxx11? || build.with?("cxx")
      args.concat %w[--with-pthread=/usr --enable-threadsafe]
    else
      ENV.cxx11 if build.cxx11?
      args << "--enable-cxx" if build.cxx11? || build.with?("cxx")

      if build.with? :fortran
        args << "--enable-fortran"
        args << "--enable-fortran2003" if build.with? "fortran2003"
      end
    end

    if build.with? :mpi
      ENV["CC"] = ENV["MPICC"]
      ENV["CXX"] = ENV["MPICXX"]
      ENV["FC"] = ENV["MPIFC"]
    end

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
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
