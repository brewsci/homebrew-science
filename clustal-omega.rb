class ClustalOmega < Formula
  homepage "http://www.clustal.org/omega/"
  # doi "10.1038/msb.2011.75"
  # tag "bioinformatics"

  url "http://www.clustal.org/omega/clustal-omega-1.2.1.tar.gz"
  sha256 "0ef32727aa25c6ecf732083e668a0f45bc17085c28a5c7b4459f4750419f2b0a"

  bottle do
    cellar :any
    sha256 "2e1ee794f4b1e2c7875f2bfb053281227a068a9accfcb9d3988b810a84b32bc3" => :yosemite
    sha256 "1d00c72cb42d76b62a58d9cb760ff8a0f74603934e7ecfb86be85f6f98a75439" => :mavericks
    sha256 "e0f045938866b33480339d6ecccd8c9af97a9f8e7b1295fe7fcd862a93cb3b54" => :mountain_lion
    sha256 "3321d5a3ac87002656db10037563576dd2502865c036baecbfaae483d973f6f4" => :x86_64_linux
  end

  depends_on "argtable"

  def install
    system "./configure", "--prefix=#{prefix}",
      "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/clustalo", "--version"
  end
end
