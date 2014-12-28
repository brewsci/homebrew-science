class Ncl < Formula
  homepage "http://ncl.sourceforge.net/"
  #doi "10.1093/bioinformatics/btg319"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/ncl/NCL/ncl-2.1.18/ncl-2.1.18.tar.gz"
  sha1 "54e4f1ff4fef52cfd633b467a839e57a2670a397"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
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

    share.install "data", "example", "test"
  end

  test do
    cp "#{share}/data/sample.tre", "."
    system "#{bin}/NCLconverter", "sample.tre"
    assert File.exist?("out.xml")
  end
end
