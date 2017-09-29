class Nonpareil < Formula
  desc "Estimates coverage in metagenomic datasets."
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"

  # doi "10.1093/bioinformatics/btt584"
  # tag "bioinformatics"
  url "https://github.com/lmrodriguezr/nonpareil/archive/v3.1.1.tar.gz"
  sha256 "a29fb3a8d81cce78b3d6bb9b135af1bad0af1a2263a0ca215fee71890a1f1f5d"
  head "https://github.com/lmrodriguezr/nonpareil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79ba3db2b4c7a817bb3d91aeef1a47bc32d78c461d2ae49534474e486e686a43" => :high_sierra
    sha256 "9da40351040a7c1259539ac37fe1d509282f9932967d029aeae0905ca66f0734" => :sierra
    sha256 "cc8904e3f870bf130609f3e53f469f1c2fbd8407d64fe202134323a950cbaf2f" => :el_capitan
    sha256 "7b6edc1db05e82532fbd20166d1d7236bb4e353ee75dae7cb70a8e9b6d8d5fc3" => :x86_64_linux
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
