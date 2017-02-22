class Racon < Formula
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/isovic/racon"
  url "https://github.com/isovic/racon/files/741519/racon-v0.5.0.tar.gz"
  sha256 "298934749d5ce76be3645f62a5cc9194572bb62f5ba646c153df1dac2983e084"
  head "https://github.com/isovic/racon.git"
  bottle do
    sha256 "4e0064b7bbbbe9d0b2a48483cd6dbc6628125ef7aaf3353cc2b7c442cc38c334" => :sierra
    sha256 "05fa8ab4a53f66f2f03e3ff13445b3d3a8237524c85f3aa87f3514066a26b2ec" => :el_capitan
    sha256 "2180eb1ef4474e637ffb73c38307899f009203ba29d137a80f0a38d57d9efd0d" => :yosemite
    sha256 "70751396400020dae47ea26c15a6043472dad23cc764decb50cd999a60afb072" => :x86_64_linux
  end

  # doi "10.1101/gr.214270.116"
  # tag "bioinformatics"

  needs :cxx11
  needs :openmp

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "bin/racon"
  end

  test do
    assert_match "Options", shell_output("#{bin}/racon 2>&1", 1)
  end
end
