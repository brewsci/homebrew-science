require 'formula'

class Bamutil < Formula
  homepage 'http://genome.sph.umich.edu/wiki/BamUtil'
  url 'http://genome.sph.umich.edu/w/images/5/52/BamUtilLibStatGen.1.0.9.tgz'
  sha1 '5997481f5668d6cc1c9570f3aae1383262af28c3'
  head 'https://github.com/statgen/bamUtil.git'

  def install
    ENV.j1
    system 'make', 'cloneLib' if build.head?
    system 'make', 'install', "INSTALLDIR=#{bin}"
  end

  test do
    system 'bam 2>&1 |grep -q BAM'
  end
end
