require "formula"

class Hdf5 < Formula
  homepage "http://www.hdfgroup.org/HDF5"
  url "http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.13/src/hdf5-1.8.13.tar.bz2"
  mirror "http://www.mirrorservice.org/sites/distfiles.macports.org/hdf5/hdf5-1.8.13.tar.bz2"
  sha1 "712955025f03db808f000d8f4976b8df0c0d37b5"

  deprecated_option "enable-fortran" => "with-fortran"
  deprecated_option "enable-threadsafe" => "with-threadsafe"
  deprecated_option "enable-parallel" => "with-mpi"
  deprecated_option "enable-fortran2003" => "with-fortran2003"
  deprecated_option "enable-cxx" => "with-cxx"

  option :universal
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

    args << "--enable-parallel" if build.with? "mpi"

    if build.with? "threadsafe"
      raise "--enable-threadsafe conflicts with Fortran bindings" if build.with? "fortran"
      raise "--enable-threadsafe conflicts with C++ support" if build.cxx11? or build.with? "cxx"
      args.concat %w[--with-pthread=/usr --enable-threadsafe]
    else
      ENV.cxx11 if build.cxx11?
      args << "--enable-cxx" if build.cxx11? or build.with? "cxx"

      if build.with? "fortran"
        args << "--enable-fortran"
        args << "--enable-fortran2003" if build.with? "fortran2003"
      end
    end

    if build.with? "mpi"
      ENV["CC"] = "mpicc"
      ENV["FC"] = "mpif90"
    end

    system "./configure", *args
    system "make", "install"
    share.install "#{lib}/libhdf5.settings"
  end
end
