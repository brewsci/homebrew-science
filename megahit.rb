class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v1.0.6.tar.gz"
  sha256 "16dde39241e11c69f20f7b55c0d28db40860ace9e624db9e43e06e34cb052c11"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    sha256 "f0c6ad32a8ce2b8699843e122a11603ecf038d8cd1994ecfa53d84a298b9fbff" => :el_capitan
    sha256 "73807f684e62e5720227c81d4c9f85a1df9935b23f637f7a9d710e59adb01462" => :yosemite
    sha256 "020cb2ec6ec0c4f5c8aac9431aa71ca1b86b474500b87434a147fb89bbfd4b16" => :mavericks
    sha256 "83b0355a318e06e493e655d3cbd2b5ae3aed2764ac24322c66b24cba1eff7eb4" => :x86_64_linux
  end

  # Fix error: 'HashGraph::HashGraph(const HashGraph&)' is private within this context
  # Fixed upstream: https://github.com/voutcn/megahit/issues/96
  patch do
    url "https://github.com/voutcn/megahit/commit/a9f7e90e537f79684fc2d76da971b60cac48bfa0.patch"
    sha256 "5ec070ae1611df9b0c12e3566f7a6bf6c9f933c3b3e62f46edf2ca1fd5ab5ed1"
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
