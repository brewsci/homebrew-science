class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v1.0.2.tar.gz"
  sha256 "32765430cf5b48f823d94737f50396d28efa04a494b635e4e83ba0eba0bbf64b"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    sha256 "b672168bf3c29490f200075b67ee73e8be2f16ce6e59b592e46d819052d0d10b" => :el_capitan
    sha256 "fdb5b496fd1b97ed0d8dbf4dd1a884a79fe13270c39ae6733994ce3d2cb9b000" => :yosemite
    sha256 "6911d3ea68226bb6cae9f2684bfc4dd6e42d44457447f5f18086ac194c29d4cf" => :mavericks
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
    pkgshare.install "example"
  end

  test do
    outdir = "megahit.outdir"
    system "#{bin}/megahit", "--12", "#{pkgshare}/example/readsInterleaved1.fa.gz", "-o", outdir
    assert File.exist?("#{outdir}/final.contigs.fa")
    assert_match outdir, File.read("#{outdir}/opts.txt")
  end
end
