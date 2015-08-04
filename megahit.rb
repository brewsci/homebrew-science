class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v1.0.1.tar.gz"
  sha256 "c938a8c64c07b14dbed346eda2d286a129d9b4b57e70ee7503e9d8556c510fc5"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    sha256 "39bcf4cec53c187adffd5e4105ca19b5726d3715e67427206887e437462cecd6" => :yosemite
    sha256 "afd1ffa9738d466fee70cdca229f1c4d908eccc76652afe5405c5d172615a5fb" => :mavericks
    sha256 "e993b4ee192dbddd4b5b29be589b14cc40f70094abc5aa30255d1b239d738d63" => :mountain_lion
  end

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
    llvm-g++ does not support -mpopcnt, -std=c++0x
    options
    EOS
  end

  # Fix error: 'omp.h' file not found
  needs :openmp

  def install
    system "make"
    bin.install Dir["megahi*"]
    doc.install "LICENSE", "ChangeLog.md", "README.md"
    (share/"megahit").install "example"
  end

  test do
    outdir = "megahit.outdir"
    system "#{bin}/megahit", "--12", "#{share}/megahit/example/readsInterleaved1.fa.gz", "-o", outdir
    assert File.exist?("#{outdir}/final.contigs.fa")
    assert_match outdir, File.read("#{outdir}/opts.txt")
  end
end
