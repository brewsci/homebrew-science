class Quake < Formula
  homepage "http://www.cbcb.umd.edu/software/quake/"
  #doi "10.1186/gb-2010-11-11-r116"
  #tag "bioinformatics"

  url "http://www.cbcb.umd.edu/software/quake/downloads/quake-0.3.5.tar.gz"
  sha1 "5ee22ae15415b97ef88e55f0dc786d07ed7aff7b"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "5c8f0b65e4a4a53684d9eb79a9e3f49dd2192676" => :yosemite
    sha1 "aaab051aaf0a8d2459ef6a5c8299594cf68977d0" => :mavericks
  end

  needs :openmp

  depends_on "boost"
  depends_on "jellyfish"
  depends_on "r"

  def install
    system "make", "-C", "src"
    doc.install "LICENSE", "README"
    bin.install %w[
      bin/cov_model.py
      bin/cov_model.r
      bin/cov_model_qmer.r
      bin/kmer_hist.r
      bin/quake.py
      src/build_bithash
      src/correct
      src/count-kmers
      src/count-qmers
    ]
  end

  test do
    system "#{bin}/quake.py", "--help"
  end
end
