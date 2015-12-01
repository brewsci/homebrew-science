class Quake < Formula
  homepage "http://www.cbcb.umd.edu/software/quake/"
  # doi "10.1186/gb-2010-11-11-r116"
  # tag "bioinformatics"

  url "http://www.cbcb.umd.edu/software/quake/downloads/quake-0.3.5.tar.gz"
  sha256 "8ded707213117463675553bb989c4c69c5d01b122945b1e265c79d7e4e34eebd"

  bottle do
    cellar :any
    sha256 "e2f419b64306ff4bdd0fca1bb861f7b80751f2c619e6a6a252e6d1885b068d99" => :yosemite
    sha256 "9b9f35ad47303fc9714d55987d9bcd45f1f49df852e8120a5e101229cdcc30b8" => :mavericks
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
