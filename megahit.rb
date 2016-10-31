class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v1.0.6.1.tar.gz"
  sha256 "f86c9d64b0ea859cda4ddf2531bdc59d66150380d09e5375fdb92758d19f600f"
  head "https://github.com/voutcn/megahit.git"

  bottle do
    sha256 "0c9ecbdd7936b04b96bb7d3b234a41117f84b6f8c582b4d9286463984ec08057" => :sierra
    sha256 "e8d64afae8ac19d7ab5042ee3958b1cc900bab4b7121cd74d1519fe5d9dd032c" => :el_capitan
    sha256 "404a411f1e0d3d083e28657ae25f57730d7b10c0f3d5345dbb2e6f01633c0c2e" => :yosemite
    sha256 "64087f32df776f05be312cfeef56a334d0f266c3dd29f0919d7a6864c939c9dc" => :x86_64_linux
  end

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
    llvm-g++ does not support -mpopcnt, -std=c++0x
    options
    EOS
  end

  needs :openmp

  depends_on :python

  def install
    system "make"
    bin.install Dir["megahi*"]
    pkgshare.install "example"
  end

  test do
    outdir = "megahit.outdir"
    system "#{bin}/megahit", "--12", "#{pkgshare}/example/readsInterleaved1.fa.gz", "-o", outdir
    assert File.exist?("#{outdir}/final.contigs.fa")
    assert_match outdir, File.read("#{outdir}/opts.txt")
  end
end
