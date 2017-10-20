class Bamutil < Formula
  desc "Collection of tools to work with SAM/BAM files."
  homepage "https://genome.sph.umich.edu/wiki/BamUtil"
  # tag "bioinformatics"
  url "https://genome.sph.umich.edu/w/images/7/70/BamUtilLibStatGen.1.0.13.tgz"
  sha256 "16c1d01c37d1f98b98c144f3dd0fda6068c1902f06bd0989f36ce425eb0c592b"
  head "https://github.com/statgen/bamUtil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe2cef19aab52f2edf598ce2fae36d72b8d4c506e3ca3740a30c085c1f801618" => :yosemite
    sha256 "3446b278dabe53013db787888815423b9b52afb11f92243b12299f4ee0dfe39f" => :mavericks
    sha256 "2ac9a6a23b1af9afe1c03eab6630a92cfabd0c3127155c8c3bc7865cde8c3eb4" => :mountain_lion
    sha256 "c9e090d4767a73db7dd4907c85faff1cb84cb25fa39decb93cfb21cb64e1354c" => :x86_64_linux
  end

  def install
    ENV.deparallelize
    system "make", "cloneLib" if build.head?
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    system "bam 2>&1 |grep -q BAM"
  end
end
