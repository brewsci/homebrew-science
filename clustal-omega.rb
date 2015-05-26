class ClustalOmega < Formula
  homepage "http://www.clustal.org/omega/"
  #tag "bioinformatics"
  #doi "10.1038/msb.2011.75"
  url "http://www.clustal.org/omega/clustal-omega-1.2.1.tar.gz"
  sha1 "50f67eb3244c25c9380e7afef0e157161535121b"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "2e1ee794f4b1e2c7875f2bfb053281227a068a9accfcb9d3988b810a84b32bc3" => :yosemite
    sha256 "1d00c72cb42d76b62a58d9cb760ff8a0f74603934e7ecfb86be85f6f98a75439" => :mavericks
    sha256 "e0f045938866b33480339d6ecccd8c9af97a9f8e7b1295fe7fcd862a93cb3b54" => :mountain_lion
  end

  depends_on "argtable"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/clustalo", "--version"
  end
end
