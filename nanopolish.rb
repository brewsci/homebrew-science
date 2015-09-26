class Nanopolish < Formula
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  # doi "10.1038/nmeth.3444"
  # tag "bioinformatics"

  # Does not include htslib nor fast5.
  # url "https://github.com/jts/nanopolish/archive/v0.3.0.tar.gz"
  url "https://github.com/jts/nanopolish.git",
    :tag => "v0.3.0", :revision => "832b678d88e26379887c1f123a4e92fb1b074470"
  head "https://github.com/jts/nanopolish.git"
  revision 1

  bottle do
    cellar :any
    sha256 "4b15a0afde48482d41582c89e8f0453622a369472b41c61ee42cd98160d46d8a" => :yosemite
    sha256 "dc95e46b3e42fd7f68ac6580857fba3ff4b54d0b3631e2b37f9a1d2786e23f2c" => :mavericks
    sha256 "79f2f51948ec3066a3422660ab040c6569abda872861f8f031bbc71fc13e52f6" => :mountain_lion
  end

  needs :cxx11
  needs :openmp

  depends_on "hdf5"
  depends_on "htslib"

  def install
    # Fix error: ld: library not found for -lrt
    inreplace "Makefile", "-lrt", "" if OS.mac?

    system "make", "-C", "htslib"
    system "make"

    prefix.install "consensus.make", "nanopolish", Dir["*.pl"], Dir["*.py"]
    bin.install_symlink "../nanopolish"
    doc.install "LICENSE", "README.md"
  end

  test do
    system "#{bin}/nanopolish", "--help"
  end
end
