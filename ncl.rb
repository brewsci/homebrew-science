class Ncl < Formula
  desc "A C++ library for parsing NEXUS files"
  homepage "https://ncl.sourceforge.io/"
  # doi "10.1093/bioinformatics/btg319"
  # tag "bioinformatics"
  url "https://downloads.sourceforge.net/project/ncl/NCL/ncl-2.1.18/ncl-2.1.18.tar.gz"
  sha256 "6e792ede614f6969a0cd342fea1505b4ea3e3e4c0f50a1c0c16a3af67bfe9737"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ae9815430b8e5f3f13f15aa7a7721cded1418983207f19f6e42d39ee0fa732e3" => :yosemite
    sha256 "ce0281513cf22d3c6dd7e419ced8f672fd649bb32ca57ed6de5872b292c8ddea" => :mavericks
    sha256 "f800df10f205f1fe880877e18bcd7dee1c383b9e7b071f62484ea3c14404fb69" => :mountain_lion
    sha256 "8f7d6a553123a642483c967fa5d18e929037a2f0c5167276dc2dc6a03c03f766" => :x86_64_linux
  end

  def install
    # The option --with-constfuncs is required by garli.
    # --with-constfuncs=yes Defines the NCL_CONST_FUNCS macro so
    # functions that should be const are declared as such
    system "./configure", "--prefix=#{prefix}",
      "--with-constfuncs=yes"
    system "make"
    system "make", "check"
    system "make", "install"

    pkgshare.install "data", "example", "test"
  end

  test do
    cp "#{pkgshare}/data/sample.tre", "."
    system "#{bin}/NCLconverter", "sample.tre"
    assert File.exist?("out.xml")
  end
end
