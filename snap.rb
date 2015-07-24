class Snap < Formula
  homepage "http://korflab.ucdavis.edu/software.html"
  # doi "10.1186/1471-2105-5-59"
  # tag "bioinformatics"

  version "2013-11-29"
  url "http://korflab.ucdavis.edu/Software/snap-#{version}.tar.gz"
  sha1 "0ff0612ecb7040dfaa58b4330396d025abc0b758"

  bottle do
    cellar :any
    sha1 "c7973c56253ee5bd6208a563aad10004e82fe220" => :yosemite
    sha1 "4ff738f010788c7cee6eba6a3e1a571d970239bf" => :mavericks
    sha1 "27a4a9373fe3559494d63331bda09dc8308c89ea" => :mountain_lion
  end

  def install
    system "make"
    bin.install *(%w[exonpairs fathom forge hmm-info snap] + Dir["*.pl"])
    doc.install *%w[00README LICENSE example.zff ]
    prefix.install *%w[DNA HMM Zoe]
  end

  def caveats; <<-EOS.undent
    Set the ZOE environment variable:
      export ZOE=#{opt_prefix}
    EOS
  end

  test do
    system "#{bin}/snap", "-help"
  end
end
