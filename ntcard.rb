class Ntcard < Formula
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/archive/1.0.0.tar.gz"
  sha256 "22f02ff4fef0a525990202e3711ac5ce972014020d3bc32ce593a6f92d01c1cc"
  head "https://github.com/bcgsc/ntCard"
  # doi "10.1093/bioinformatics/btw832"
  # tag "bioinformatics"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  needs :openmp

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ntcard", "--version"
  end
end
