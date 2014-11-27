require 'formula'

class Blasr < Formula
  homepage 'https://github.com/PacificBiosciences/blasr'
  #doi '10.1186/1471-2105-13-238'
  url 'https://github.com/PacificBiosciences/blasr/archive/smrtanalysis-2.1.tar.gz'
  sha1 'ac6add1ba8a82cac2515da36c0ec53060c20ea0f'
  head 'https://github.com/PacificBiosciences/blasr.git'

  depends_on "hdf5" => "with-cxx"

  fails_with :clang do
    build 503
    cause <<-EOS.undent
      error: destructor type 'HDFWriteBuffer<int>' in object
      destruction expression does not match the type
      'BufferedHDFArray<int>' of the object being destroyed
    EOS
  end

  fails_with :gcc do
    build 5666
    cause <<-EOS.undent
      error: invalid conversion
      from 'void (*)(H5::H5Object&, std::string, void*)'
      to 'void (*)(H5::H5Location&, std::string, void*)'
    EOS
  end

  def install
    hdf5 = Formula["hdf5"]
    system "make", "STATIC=",
      "HDF5INCLUDEDIR=#{hdf5.opt_include}",
      "HDF5LIBDIR=#{hdf5.opt_lib}"
    system 'make', 'install', 'PREFIX=' + prefix
  end

  test do
    system 'blasr'
  end
end
