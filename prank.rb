class Prank < Formula
  desc "A multiple alignment program for DNA, codon and amino-acid sequences"
  homepage "http://wasabiapp.org/software/prank/"
  url "http://wasabiapp.org/download/prank/prank.source.170427.tgz"
  sha256 "623eb5e9b5cb0be1f49c3bf715e5fabceb1059b21168437264bdcd5c587a8859"

  head "https://github.com/ariloytynoja/prank-msa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ab7158ba5b9ee5ab22d14be9b6eb451f475578b7edd8caa96c5c77435e79f26" => :high_sierra
    sha256 "dff62b6c346bc089c2a941d76f98f4796f985518b49f33fb1a0633f9fcf44174" => :sierra
    sha256 "535477c82397b4de4f74732345040448a99fa908a7c45532a3e730e0aff2cde6" => :el_capitan
    sha256 "7d08424bdb8b26c063d796b31c10dfd8bc841888b4cc80380baa5c7fa8056277" => :x86_64_linux
  end

  depends_on "mafft"
  depends_on "exonerate"

  def install
    cd "src" do
      system "make"
      bin.install "prank"
      man1.install "prank.1"
    end
  end

  test do
    system "#{bin}/prank", "-help"
  end
end
