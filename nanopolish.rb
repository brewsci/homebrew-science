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

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "499f50775412507cd99f303bc6724d57ddc8c33b48393e7e45acac9d8b365f10" => :yosemite
    sha256 "48c76d109ec9fa33bfcc1ab723fb93505f9b9b4e370b757f476ea1cd2e3e267f" => :mountain_lion
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
