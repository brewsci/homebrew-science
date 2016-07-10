class Quake < Formula
  homepage "http://www.cbcb.umd.edu/software/quake/"
  # doi "10.1186/gb-2010-11-11-r116"
  # tag "bioinformatics"

  url "http://www.cbcb.umd.edu/software/quake/downloads/quake-0.3.5.tar.gz"
  sha256 "8ded707213117463675553bb989c4c69c5d01b122945b1e265c79d7e4e34eebd"
  revision 1

  bottle do
    cellar :any
    sha256 "b76c43979ec8370f99ced3d759c6c01e749782a510de78aea1f24312ae58dc9f" => :el_capitan
    sha256 "2c77da904ef8c7409f0ba8fcc38100f3296f6178365de5211f76b1063b7448b8" => :yosemite
    sha256 "23ba2a9b6fdc08bfb446243d24e7762c79319125532e53688e411b389bc811c6" => :mavericks
    sha256 "b99dd716a06cce5859c63757c635ede84605b044904c57f1e819a71b346c7309" => :x86_64_linux
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
