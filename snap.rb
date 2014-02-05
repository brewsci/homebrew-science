require 'formula'

class Snap < Formula
  homepage 'http://korflab.ucdavis.edu/software.html'
  version '2013-11-29'
  url "http://korflab.ucdavis.edu/Software/snap-#{version}.tar.gz"
  sha1 '0ff0612ecb7040dfaa58b4330396d025abc0b758'

  def install
    system 'make'
    bin.install *(%w[exonpairs fathom forge hmm-info snap] + Dir['*.pl'])
    doc.install *%w[00README LICENSE example.zff ]
    libexec.install *%w[DNA HMM Zoe]
  end

  def caveats; <<-EOS.undent
    Set the ZOE environment variable:
      export ZOE=#{opt_prefix}/libexec/Zoe
    EOS
  end

  test do
    system 'snap -help'
  end
end
