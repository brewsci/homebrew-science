class Blasr < Formula
  desc "PacBio long read aligner"
  homepage "https://github.com/PacificBiosciences/blasr"
  # doi "10.1186/1471-2105-13-238"
  # tag "bioinformatics"

  url "https://github.com/PacificBiosciences/blasr/archive/smrtanalysis-2.1.tar.gz"
  sha256 "12b20c05fcfdd166d654971402ba872dc23cb948e46e5cd40a432fb6c1b814f1"

  head "https://github.com/PacificBiosciences/blasr.git"

  depends_on "hdf5"

  fails_with :clang do
    build 602
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
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/blasr"
  end
end
