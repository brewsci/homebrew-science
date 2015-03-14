class Proteinortho < Formula
  homepage "http://www.bioinf.uni-leipzig.de/Software/proteinortho/"
  url "http://www.bioinf.uni-leipzig.de/Software/proteinortho/proteinortho_v5.11.tar.gz"
  sha256 "25f3374854dfeefaf29d701e85d60013fc2b4a035257c4b0ef0d8ba304ac80cc"
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
