class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/htslib/archive/1.2.1.tar.gz"
  sha256 "4f67f0fc73ae86f3ed4336d8d8f6da3c12066e9cb5f142b685622dd6b8f9ae42"
  head "https://github.com/samtools/htslib.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "7dcc5ba144967b427807c858256753c1077af19c" => :yosemite
    sha1 "526fdef181ed7c54cd68b3384346e78f4c18fb26" => :mavericks
    sha1 "cbb4da3ff94024485eca163d7a42b3c0bfd7c25b" => :mountain_lion
  end

  conflicts_with "tabix", :because => "both htslib and tabix install bin/tabix"

  def install
    system "make", "install", "prefix=#{prefix}"
    (share/"htslib").install "test"
  end

  test do
    sam = share/"htslib/test/ce#1.sam"
    assert_match "SAM", shell_output("htsfile #{sam}")
    system "bgzip -c #{sam} > sam.gz"
    assert File.exist?("sam.gz")
    system "tabix", "-p", "sam", "sam.gz"
    assert File.exist?("sam.gz.tbi")
  end
end
