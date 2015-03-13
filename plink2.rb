class Plink2 < Formula
  url "https://github.com/chrchang/plink-ng/archive/v1.90b3.tar.gz"
  version "1.90b3"
  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "26d74e4add75728f538e98911b19a30a45936592b4447bce4ee3b71504a4bcfc" => :yosemite
    sha256 "e30eccab2712c8479c62e5d89ac510e74192ceecaf8f18b40cca279db1737e99" => :mavericks
    sha256 "fbdfe8f84c6385fc052080646ade2c6bb6f0f3081afc6c242e6c84bd9f99a9c1" => :mountain_lion
  end

  # doi "10.1186/s13742-015-0047-8"
  # tag "bioinformatics"
  homepage "https://www.cog-genomics.org/plink2"
  sha256 "2f4afc193c288b13af4410e4587358ee0a6f76ed7c98dd77ca1317aac28adf0d"

  depends_on :fortran
  depends_on "openblas"

  def install
    mv "Makefile.std", "Makefile"
    system "./plink_first_compile"
    system "make", "plink"
    bin.install "plink" => "plink2"
  end

  test do
    system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
    assert File.exist?("dummy_cc1.bed")
  end
end
