class Snap < Formula
  desc "Gene prediction tool"
  homepage "http://korflab.ucdavis.edu/software.html"
  # doi "10.1186/1471-2105-5-59"
  # tag "bioinformatics"

  url "http://korflab.ucdavis.edu/Software/snap-2013-11-29.tar.gz"
  version "2013-11-29"
  sha256 "e2a236392d718376356fa743aa49a987aeacd660c6979cee67121e23aeffc66a"

  bottle do
    cellar :any
    sha256 "c0ec159c4a9c5bddeb57fb42decf22d40cc0070f6f7c15b5be6977410a068721" => :yosemite
    sha256 "905b52ab0dbf8f2244b8441d1c7c1996e6533eadc765ed8deab1dc36046c97d1" => :mavericks
    sha256 "64f63ceb2d5f6423ea4499c317d6b49c3608da0b55fca35e0bce8197872a7d7c" => :mountain_lion
  end

  def install
    system "make"
    bin.install %w[exonpairs fathom forge hmm-info snap]
    bin.install Dir["*.pl"]
    doc.install %w[00README LICENSE example.zff]
    prefix.install %w[DNA HMM Zoe]
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
