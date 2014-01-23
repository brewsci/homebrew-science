require 'formula'

class Dsk < Formula
  homepage 'http://minia.genouest.org/dsk/'
  url 'http://minia.genouest.org/dsk/dsk-1.6066.tar.gz'
  sha1 '9b7779ca64ab8aa92cf1e8d7d6a7e3d6c745607c'

  def install
    args = []
    args << 'osx=1' if OS.mac?
    args << 'omp=1' if OS.linux?
    system 'make', *args
    bin.install 'dsk'
    libexec.install *%w[parse_results parse_results.py plot_distrib.R]
    doc.install 'README'
  end

  test do
    system 'dsk --version'
  end
end
