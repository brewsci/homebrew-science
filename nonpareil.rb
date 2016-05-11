class Nonpareil < Formula
  desc "Estimates coverage in metagenomic datasets."
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"
  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "22978031100c62cc41ebd3e2a57f2846ac1bf264e02a5807a8f0c36f93efbfa9" => :el_capitan
    sha256 "592de312bebb22663176aea7bbaafff616df1af4e69ece38be96fb1abd83a983" => :yosemite
    sha256 "5bed7734473ccaae4aafc316f667ac7679968691ec4ad137df6e1f5bb23763cc" => :mavericks
  end

  # doi "10.1093/bioinformatics/btt584"
  # tag "bioinformatics"
  url "https://github.com/lmrodriguezr/nonpareil/archive/v2.4.01.tar.gz"
  sha256 "ca5955e877098ed4a679404ac87635e28a855d15d6970ca51a6be422266c0999"
  head "https://github.com/lmrodriguezr/nonpareil.git"

  depends_on "r"
  depends_on :mpi => [:cxx, :optional]

  def install
    r_library = lib/"R"/r_major_minor
    r_library.mkpath
    inreplace "Makefile", "CMD INSTALL", "CMD INSTALL --library=#{r_library}"
    system "make", "nonpareil"
    system "make", "mpicpp=#{ENV["MPICXX"]}", "nonpareil-mpi" if build.with? :mpi
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
    libexec.install "test/test.fasta"
  end

  def r_major_minor
    `#{Formula["r"].bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
  end

  test do
    cp libexec/"test.fasta", testpath
    system "nonpareil", "-s", "#{testpath}/test.fasta", "-b", "#{testpath}/test"
  end
end
