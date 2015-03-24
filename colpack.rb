class Colpack < Formula
  homepage "http://www.cscapes.org/coloringpage/software.htm"
  url "http://cscapes.cs.purdue.edu/download/ColPack/ColPack-1.0.9.tar.gz"
  sha1 "c963424c3e97a7bc3756d3feb742418e89721e48"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "8f58497acfce27796968d081d92aa416222d200e112e4e4b653ba928c472ad3a" => :yosemite
    sha256 "c7bde703529bca89fd52670e1b39e340753e609cfa27eb768b8580bcb0775c7b" => :mavericks
    sha256 "8aaa29a13ed9a4276387f55ff2edd60bb782600529bb7efedbd9ce4f9d43ca3e" => :mountain_lion
  end

  def install
    ENV.libcxx
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
