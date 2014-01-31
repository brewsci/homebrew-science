require 'formula'

class Geneid < Formula
  homepage 'http://genome.crg.es/software/geneid/'
  url 'ftp://genome.crg.es/pub/software/geneid/geneid_v1.4.4.Jan_13_2011.tar.gz'
  sha1 '9cbed32d0bfb530252f97b83807da2284967379b'
  version '1.4.4'

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system 'make'
    bin.install Dir['bin/*']
    doc.install 'README', *Dir['docs/*']
    (share/'geneid').install Dir['param/*.param']
  end

  def caveats; <<-EOS.undent
    The parameter files are installed in
      #{HOMEBREW_PREFIX/'share/geneid'}
    EOS
  end

  test do
    system 'geneid -h'
  end
end
