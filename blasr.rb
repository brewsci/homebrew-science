require 'formula'

class Blasr < Formula
  homepage 'https://github.com/PacificBiosciences/blasr'
  head 'https://github.com/PacificBiosciences/blasr.git'

  depends_on 'hdf5' => 'enable-cxx'

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      error: destructor type 'HDFWriteBuffer<int>' in object
      destruction expression does not match the type
      'BufferedHDFArray<int>' of the object being destroyed
    EOS
  end

  def install
    system 'make'
    system 'make', 'install', 'PREFIX=' + prefix
  end

  test do
    system 'blasr'
  end
end
