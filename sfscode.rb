class Sfscode < Formula
  desc "Population genetics simulator"
  homepage "http://sfscode.sourceforge.net/SFS_CODE/index/index.html"
  url "https://downloads.sourceforge.net/project/sfscode/sfscode/sfscode_20140719/sfscode_20140719.tgz"
  sha256 "1f69ed96e20f1453df2882ce78171b49cb3378b25538a3cacd18db00e07c979a"

  bottle do
    cellar :any
    sha256 "8e3adc0429a8e5e7b80b52cb1ca7ed6ef2fbed2e154687612fb6622cc42888ec" => :yosemite
    sha256 "22fc81e423c179ac776a0e78d74d678609929d5d17c2d377dd7cba6185a3c26a" => :mavericks
    sha256 "87c0cc3e34e84861a2d460ce1997adfeb8f05dc0f8aff21859752a72a3cbb135" => :mountain_lion
  end

  def install
    ENV.j1
    system "make", "CC=#{ENV.cc}", "EXEDIR=#{bin}"
    doc.install "doc/SFS_CODE_doc.pdf"
  end

  test do
    system bin/"sfs_code", "1", "1"
  end
end
