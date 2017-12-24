class Nonpareil < Formula
  desc "Estimates coverage in metagenomic datasets."
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"

  # doi "10.1093/bioinformatics/btt584"
  # tag "bioinformatics"
  url "https://github.com/lmrodriguezr/nonpareil/archive/v3.2.tar.gz"
  sha256 "caccc665ade312347f29d617e49312ac1f00bee3e262134bdf010afa42dcc369"
  head "https://github.com/lmrodriguezr/nonpareil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3f3dc6aa211f450fdc2bdb8f1c8c03eabac3a39881a3983d7519a989f051c95" => :high_sierra
    sha256 "d1baff97fa30fabf2cdd1cb6128d85abf8192b4b4ab070af714a45202a23c298" => :sierra
    sha256 "3ca5634310fa7c4e09ee0060dd524cf70d99afa60fe10f22660f5915c69dc0cb" => :el_capitan
    sha256 "6247316d927e9b46086d3d4165cb3cde61a162d602a7fbd3b5027b7fcd0f8766" => :x86_64_linux
  end

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
    system bin/"nonpareil", "-s", "#{testpath}/test.fasta", "-T", "alignment",
                            "-b", "#{testpath}/test"
  end
end
