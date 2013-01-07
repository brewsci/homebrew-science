require 'formula'

class Fasttree < Formula
  homepage 'http://meta.microbesonline.org/fasttree/'
  url 'http://meta.microbesonline.org/fasttree/FastTree.c'
  version '2.1.3'
  sha1 '371f12d6177822f20d240327b4cdfd7c4a6923e4'

  fails_with :clang do
    build 421
    cause "segmentation fault when running Fasttree"
  end

  def install
    system "#{ENV.cc} -lm -O3 -finline-functions -funroll-loops -Wall -o FastTree FastTree.c"
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
