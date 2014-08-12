require "formula"

class Quake < Formula
  homepage "http://www.cbcb.umd.edu/software/quake/"
  #doi "10.1186/gb-2010-11-11-r116"

  url "http://www.cbcb.umd.edu/software/quake/downloads/quake-0.3.5.tar.gz"
  sha1 "5ee22ae15415b97ef88e55f0dc786d07ed7aff7b"

  fails_with :clang do
    build 503
    cause "error: 'omp.h' file not found"
  end

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
    system "#{bin}/quake.py --help"
  end
end
