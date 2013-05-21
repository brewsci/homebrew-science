require 'formula'

class Bamutil < Formula
  homepage 'http://genome.sph.umich.edu/wiki/BamUtil'
  url 'https://github.com/statgen/bamUtil/archive/v1.0.7.tar.gz'
  sha1 'a9d4790e0455aeab925896806871c707424b5c50'
  head 'https://github.com/statgen/bamUtil.git'

  def install
    ENV.j1
    system 'make', 'cloneLib'
    system 'make', 'install', "INSTALLDIR=#{bin}"
  end

  test do
    system 'bam 2>&1 |grep -q BAM'
  end
end
