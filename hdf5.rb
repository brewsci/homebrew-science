require "formula"

class Hdf5 < Formula
  homepage "http://www.hdfgroup.org/HDF5"
  url "http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.13/src/hdf5-1.8.13.tar.bz2"
  mirror "https://distfiles.macports.org/hdf5-18/hdf5-1.8.13.tar.bz2"
  sha1 "712955025f03db808f000d8f4976b8df0c0d37b5"

  # TODO - warn that these options conflict
  option :universal
  option "enable-fortran", "Compile Fortran bindings"
  option "enable-threadsafe", "Trade performance and C++ or Fortran support for thread safety"
  option "enable-parallel", "Compile parallel bindings"
  option "enable-fortran2003", "Compile Fortran 2003 bindings. Requires enable-fortran"
  option "enable-cxx", "Compile C++ bindings"
  option :cxx11

  depends_on :fortran if build.include? "enable-fortran" or build.include? "enable-fortran2003"
  depends_on "szip"
  depends_on :mpi => [:cc, :cxx, :f90] if build.include? "enable-parallel"

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

    args << "--enable-parallel" if build.include? "enable-parallel"

    if build.include? "enable-threadsafe"
      raise "--enable-threadsafe conflicts with Fortran bindings" if build.include? "enable-fortran"
      raise "--enable-threadsafe conflicts with C++ support" if build.cxx11? or build.include? "enable-cxx"
      args.concat %w[--with-pthread=/usr --enable-threadsafe]
    else
      ENV.cxx11 if build.cxx11?
      args << "--enable-cxx" if build.cxx11? or build.include? "enable-cxx"

      if build.include? "enable-fortran" or build.include? "enable-fortran2003"
        args << "--enable-fortran"
        args << "--enable-fortran2003" if build.include? "enable-fortran2003"
      end
    end

    if build.include? "enable-parallel"
      ENV["CC"] = "mpicc"
      ENV["FC"] = "mpif90"
    end

    system "./configure", *args
    system "make", "install"
    share.install "#{lib}/libhdf5.settings"
  end
end
