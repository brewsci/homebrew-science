class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.3.3.tar.gz"
  sha256 "f6c5edb6a42e020e82fa2d670ed803022fae243c9aea19f948d3176aa52e3fce"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "41a61c841545d46ef17a5ab3f7d4c29f4eb6a177be26b2d4849fa570ba400f8e" => :yosemite
    sha256 "6702ed1aadd3fac6797e53adf2dd783ec222993829c87f80c8783a3d4a8e8576" => :mavericks
    sha256 "f9823210aee5b6d6383d06bb91a4771d8352ff0da4ffa2837901562dc814b48c" => :mountain_lion
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
