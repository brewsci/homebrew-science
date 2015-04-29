class Bwa < Formula
  homepage "http://bio-bwa.sourceforge.net/"
  # doi "10.1093/bioinformatics/btp324"
  # tag "bioinformatics"
  url "https://downloads.sf.net/project/bio-bwa/bwa-0.7.12.tar.bz2"
  sha1 "6389ca75328bae6d946bfdd58ff4beb0feebaedd"
  head "https://github.com/lh3/bwa.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "476b7108c5755990eca5a49b071861d800d405d6" => :yosemite
    sha1 "b6536565e0660cc6e9e6351c1c0420c4f9c2059d" => :mavericks
    sha1 "f90f7796e699f43d903414d645062510be77fab7" => :mountain_lion
    sha256 "30a4bd731dc643001364bf5133e9441073583f4417dedf7dd48ebcb71fdf702e" => :x86_64_linux
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    doc.install %w[README.md NEWS.md]
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write ">0\nMEEPQSDPSV\n"
    system "#{bin}/bwa index test.fasta"
    assert File.exist?("test.fasta.bwt")
  end
end
