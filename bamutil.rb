require 'formula'

class Bamutil < Formula
  homepage 'http://genome.sph.umich.edu/wiki/BamUtil'
  url 'http://genome.sph.umich.edu/w/images/7/77/BamUtilLibStatGen.1.0.11.tar.gz'
  sha1 'aada189439704d3881378566e16cb2cc789f43a1'

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
