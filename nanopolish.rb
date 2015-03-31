class Nanopolish < Formula
  homepage "https://github.com/jts/nanopolish"
  # doi "10.1101/015552"
  # tag "bioinformatics"

  # Does not include htslib nor fast5.
  # url "https://github.com/jts/nanopolish/archive/v0.2.0.tar.gz"
  url "https://github.com/jts/nanopolish.git",
    :tag => "v0.2.0", :revision => "e14e34d523add8db94aa4a5d403db6cd74488215"

  sha256 "24cb601d67b867cfba084fca3f20c669693fdf89567482b0903f92af612594a1"
  head "https://github.com/jts/nanopolish.git"

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
