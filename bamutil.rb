class Bamutil < Formula
  homepage "http://genome.sph.umich.edu/wiki/BamUtil"
  # tag "bioinformatics"
  url "http://genome.sph.umich.edu/w/images/5/5e/BamUtilLibStatGen.1.0.12.tar.gz"
  sha1 "55fb13337c71e1bcd3301bac5636d62b13cd2388"
  head "https://github.com/statgen/bamUtil.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "3e59cc21fe42f8399875c07f4797f6eab76fc5c5" => :yosemite
    sha1 "18fd138775828456a819567b8b57e97999d8cfb9" => :mavericks
    sha1 "ea3f2e30e44016b1adeff118bb6a627df2a4b905" => :mountain_lion
  end

  def install
    ENV.j1
    system "make", "cloneLib" if build.head?
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    system "bam 2>&1 |grep -q BAM"
  end
end
