class Proteinortho < Formula
  desc "Detection of orthologs in large-scale analysis"
  homepage "http://www.bioinf.uni-leipzig.de/Software/proteinortho/"
  # doi "10.1186/1471-2105-12-124"
  # tag "bioinformatics"

  url "http://www.bioinf.uni-leipzig.de/Software/proteinortho/proteinortho_v5.15_src.tar.gz"
  version "5.15"
  sha256 "718af74289a4fc0075f9dce2b12fe3fa1c7d96718c7ec8d9ddca94beac658a17"

  bottle do
    cellar :any
    sha256 "ecfd27b026b742c4b48d64e5b727b8f3dcb6207e905d27406a8d58205bfed3a6" => :yosemite
    sha256 "c90ddf8615f5781064c2b7886ad442d4524009a4c92a65d2c35f8a573b01f3e2" => :mountain_lion
    sha256 "c0158b7c561ce1a175443ac084a261c71f5164d775a8eb12e180e140274c0740" => :x86_64_linux
  end

  depends_on "blast"
  depends_on "Thread::Queue" => :perl
  depends_on "File::Basename" => :perl

  def install
    system "make"
    mkdir bin
    system "make", "INSTALLDIR=#{bin}", "install"
    doc.install "manual.html"
    pkgshare.install "tools", "test"
  end

  test do
    assert_match "orthology", shell_output("#{bin}/proteinortho5.pl 2>&1", 0)
  end
end
