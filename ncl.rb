class Ncl < Formula
  desc "A C++ library for parsing NEXUS files"
  homepage "http://ncl.sourceforge.net/"
  # doi "10.1093/bioinformatics/btg319"
  # tag "bioinformatics"
  url "https://downloads.sourceforge.net/project/ncl/NCL/ncl-2.1.18/ncl-2.1.18.tar.gz"
  sha256 "6e792ede614f6969a0cd342fea1505b4ea3e3e4c0f50a1c0c16a3af67bfe9737"

  bottle do
    sha1 "b947e17defc2915c7b8eb80727c5105e33a97a4c" => :yosemite
    sha1 "78b8bced22543506a48bba1ab2d86b72263c2d06" => :mavericks
    sha1 "f20283932a9b76677fe96f97e8d34b2238da8c8b" => :mountain_lion
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
