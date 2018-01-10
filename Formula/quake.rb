class Quake < Formula
  homepage "http://www.cbcb.umd.edu/software/quake/"
  # doi "10.1186/gb-2010-11-11-r116"
  # tag "bioinformatics"

  url "http://www.cbcb.umd.edu/software/quake/downloads/quake-0.3.5.tar.gz"
  sha256 "8ded707213117463675553bb989c4c69c5d01b122945b1e265c79d7e4e34eebd"
  revision 3

  bottle :disable, "Test-bot cannot use the versioned gcc formulae"

  needs :openmp

  depends_on "boost"
  depends_on "jellyfish"
  depends_on "r"
  depends_on "gcc@5" if OS.mac?

  fails_with :gcc => "6"

  def install
    system "make", "-C", "src"
    bin.install Dir["{bin,src}/*"].select { |x| File.executable? x }
    pkgshare.install %w[bin/cov_model.r bin/cov_model_qmer.r bin/kmer_hist.r]
  end

  test do
    system "#{bin}/quake.py", "--help"
  end
end
