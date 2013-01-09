require 'formula'

class Trilinos < Formula
  homepage 'http://trilinos.sandia.gov'
  url 'http://trilinos.sandia.gov/download/files/trilinos-11.0.3-Source.tar.gz'
  sha1 '375319eec8ae06845da126e3def72f13b59bf635'

  option "with-boost",    "Enable Boost support"
  # We have build failures with scotch. Help us on this, if you can!
  # option "with-scotch",   "Enable Scotch partitioner"
  option "with-netcdf",   "Enable Netcdf support"
  option "with-teko",     "Enable 'Teko' secondary-stable package"
  option "with-shylu",    "Enable 'ShyLU' experimental package"

  depends_on MPIDependency.new(:cc, :cxx)
  depends_on 'cmake' => :build
  depends_on 'boost'      if build.include? 'with-boost'
  depends_on 'scotch'     if build.include? 'with-scotch'
  depends_on 'netcdf'     if build.include? 'with-netcdf'

  def install

    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=ON"
    args << "-DTPL_ENABLE_MPI:BOOL=ON"
    args << "-DTPL_ENABLE_BLAS=ON"
    args << "-DTPL_ENABLE_LAPACK=ON"
    args << "-DTPL_ENABLE_Zlib:BOOL=ON"
    args << "-DTrilinos_ENABLE_ALL_PACKAGES=ON"
    args << "-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=ON"
    args << "-DTrilinos_ENABLE_Fortran:BOOL=OFF"
    args << "-DTrilinos_ENABLE_EXAMPLES:BOOL=OFF"
    args << "-DTrilinos_VERBOSE_CONFIGURE:BOOL=OFF"
    args << "-DZoltan_ENABLE_ULLONG_IDS:Bool=ON"

    # Extra non-default packages
    args << "-DTrilinos_ENABLE_ShyLU:BOOL=ON"  if build.include? 'with-shylu'
    args << "-DTrilinos_ENABLE_Teko:BOOL=ON"   if build.include? 'with-teko'

    # Third-party libraries
    args << "-DTPL_ENABLE_Boost:BOOL=ON"    if build.include? 'with-boost'
    args << "-DTPL_ENABLE_Scotch:BOOL=ON"   if build.include? 'with-scotch'
    args << "-DTPL_ENABLE_Netcdf:BOOL=ON"   if build.include? 'with-netcdf'

    mkdir 'build' do
      system "cmake", "..", *args
      system "make install"
    end

  end

end
