class Afra < Formula
  desc "Alignmen-free support values"
  homepage "https://github.com/EvolBioInf/afra"
  # tag "bioinformatics"

  url "https://github.com/EvolBioInf/afra/releases/download/v2/afra-v2.tar.gz"
  sha256 "7030ca58f4dd17035a0aeed867d32b08175c1f39d42da7e820d7a267a28a13b6"
  head "https://github.com/EvolBioInf/afra.git"

  needs :openmp

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "quartet", shell_output("#{bin}/afra --help 2>&1", 0)
  end
end
