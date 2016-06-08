class Proteinortho < Formula
  homepage "http://www.bioinf.uni-leipzig.de/Software/proteinortho/"
  url "http://www.bioinf.uni-leipzig.de/Software/proteinortho/proteinortho_v5.11.tar.gz"
  sha256 "25f3374854dfeefaf29d701e85d60013fc2b4a035257c4b0ef0d8ba304ac80cc"
  bottle do
    cellar :any
    sha256 "ecfd27b026b742c4b48d64e5b727b8f3dcb6207e905d27406a8d58205bfed3a6" => :yosemite
    sha256 "c90ddf8615f5781064c2b7886ad442d4524009a4c92a65d2c35f8a573b01f3e2" => :mountain_lion
    sha256 "c0158b7c561ce1a175443ac084a261c71f5164d775a8eb12e180e140274c0740" => :x86_64_linux
  end

  # tag "bioinformatics"
  # doi "10.1186/1471-2105-12-124"

  depends_on "blast"
  depends_on "Thread::Queue" => :perl
  depends_on "File::Basename" => :perl

  def install
    rm "proteinortho5_clean_edges"
    rm "proteinortho5_clustering"
    system "make"
    bin.install %w[proteinortho5.pl proteinortho5_clustering proteinortho5_clean_edges2.pl proteinortho5_singletons.pl ffadj_mcs.py]
    doc.install "manual.html"
  end

  test do
    assert_match "orthology", shell_output("proteinortho5.pl 2>&1", 0)
  end
end
