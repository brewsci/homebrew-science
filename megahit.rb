class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.3.0-beta3.tar.gz"
  version "3.0b3"
  sha256 "bc45ac0c7a62f8cb96521cc1a74b0f657bc81280101dfd5afc1863c16d904add"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "c3dbc085c578e6110f2af2ce1aecfd5737b936ac18a902aca2e7b48cdcbc285d" => :yosemite
    sha256 "3173ed97b7b230965812a35ff91d4d92a87c9de4d8b900a4778a7a1b50d45943" => :mavericks
    sha256 "89f238296db52b731e8f769ff8dc62bb23165e075576bef5ec2e60fe1db5e829" => :mountain_lion
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
    assert File.read("#{outdir}/opts.txt").include?(outdir)
  end
end
