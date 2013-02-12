require 'formula'

class Fasttree < Formula
  homepage 'http://meta.microbesonline.org/fasttree/'
  url 'http://www.microbesonline.org/fasttree/FastTree-2.1.7.c'
  version '2.1.7'
  sha1 'd9381924829e7d19d56154ebbde0e44044b4b7ab'

  fails_with :clang do
    build 425
    cause "segmentation fault when running Fasttree"
    # See also discussion to use -DNO_SSE (https://github.com/Homebrew/homebrew-science/pull/96)
  end

  def install
    system "#{ENV.cc} -lm -O3 -finline-functions -funroll-loops -Wall -o FastTree FastTree-#{@version}.c"
    bin.install "FastTree"
  end

  test do
    Pathname.new('test.fa').write <<-EOF.undent
      >1
      LCLYTHIGRNIYYGSYLYSETWNTTTMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >2
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >3
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGTTLPWGQMSFWGATVITNLFSAIPYIGTNLV
    EOF
    `#{bin}/FastTree test.fa` =~ /1:0.\d+,2:0.\d+,3:0.\d+/ ? true : false
  end
end
