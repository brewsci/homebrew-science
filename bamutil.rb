class Bamutil < Formula
  homepage "http://genome.sph.umich.edu/wiki/BamUtil"
  # tag "bioinformatics"
  url "http://genome.sph.umich.edu/w/images/5/5e/BamUtilLibStatGen.1.0.12.tar.gz"
  sha1 "55fb13337c71e1bcd3301bac5636d62b13cd2388"
  head "https://github.com/statgen/bamUtil.git"

  def install
    ENV.j1
    system "make", "cloneLib" if build.head?
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    system "bam 2>&1 |grep -q BAM"
  end
end
