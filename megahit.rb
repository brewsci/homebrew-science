class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v1.1.2.tar.gz"
  sha256 "d0d3965dd49c6fdaea958ef66146cb6b30b7d51acbbfe94194c437f15a424cb5"
  head "https://github.com/voutcn/megahit.git"

  bottle do
    sha256 "26d0bcb8c712ce86fec05bf10718d33b1503a8983ebde799426622588c032742" => :sierra
    sha256 "e4098da7910cecfbda5f52fc327208d942becf9c533d024e25b02745ff38f7a8" => :el_capitan
    sha256 "d15260c4dd2962299e946762455aea48d5db69d0a24a3f590e4cee9bcc73027d" => :yosemite
    sha256 "29491322bac7d65c72420cb22e5f2bc3b372da3abcc797120c26caf27724a424" => :x86_64_linux
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
