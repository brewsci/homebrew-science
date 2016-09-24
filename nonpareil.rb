class Nonpareil < Formula
  desc "Estimates coverage in metagenomic datasets."
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"
  bottle do
    cellar :any_skip_relocation
    sha256 "0bd41c4db6e54923722528c9bef95c1c5e6384b1a26cb3438860380415136ad4" => :el_capitan
    sha256 "5a4d9f0cb3ad0c168fc2497bc6a27899c4a20e756cbffe083f6839333a1eca25" => :yosemite
    sha256 "1e74c7ca447adc503f9bccc3f123b18f9b7dd6c9400c33d2fa8504ee31a8d2da" => :mavericks
    sha256 "0bd66f915cf9b85f8618996a178b200914a83e0aa93e428509032572c1700aca" => :x86_64_linux
  end

  # doi "10.1093/bioinformatics/btt584"
  # tag "bioinformatics"
  url "https://github.com/lmrodriguezr/nonpareil/archive/v2.4.01.tar.gz"
  sha256 "ca5955e877098ed4a679404ac87635e28a855d15d6970ca51a6be422266c0999"
  head "https://github.com/lmrodriguezr/nonpareil.git"
  revision 1

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
