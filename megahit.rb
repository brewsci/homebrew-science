class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v1.1.1.tar.gz"
  sha256 "09c6b97acbb6a0dca0262e3251ca8823fa73d8adb305a6f8258113b9c6059f86"
  head "https://github.com/voutcn/megahit.git"

  bottle do
    sha256 "278e59d8abd9baad784b49570ad37fe2e2863dc5b85fe52c0d75c1e68bb31764" => :sierra
    sha256 "68222fb694024e331a0dd56ca69e82788c20c6d281d0c4f4a697f0c307650ae5" => :el_capitan
    sha256 "dbf4070e1c2756d728cc49a465f63287c6d86c4bd103f5caf895b6a392253fa8" => :yosemite
    sha256 "40cf2e2c113eb4b1b4cfc7ad4c961bfa66e29eb0325b91bda5fffa507c968825" => :x86_64_linux
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
