class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v1.0.6.1.tar.gz"
  sha256 "f86c9d64b0ea859cda4ddf2531bdc59d66150380d09e5375fdb92758d19f600f"
  head "https://github.com/voutcn/megahit.git"

  bottle do
    sha256 "7f4912f5884915f4a9f95c60880e72aaafe16c5e632449777859bb313302e542" => :sierra
    sha256 "9828d04f35fbbc5106dad0e696d8eb5d4b85a522aaba03061355939d36972244" => :el_capitan
    sha256 "4628d5e3c19988808e15c631ebc08a20eef96d5a4f7773c67163fb715f721ef9" => :yosemite
    sha256 "cbe3c26c1b373422fac89b257ff7b805c8ef62b3c74573c492e6b5654ea1e17b" => :x86_64_linux
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
