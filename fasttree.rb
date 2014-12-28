require 'formula'

class Fasttree < Formula
  homepage 'http://meta.microbesonline.org/fasttree/'
  url 'http://www.microbesonline.org/fasttree/FastTree-2.1.7.c'
  sha1 'd9381924829e7d19d56154ebbde0e44044b4b7ab'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "369bb09b371ed05d55a403750738c5749fb95c07" => :yosemite
    sha1 "829bfc5f6fc144a6642c29b8a2e6a4e078998e8c" => :mavericks
    sha1 "acad8b55ad7eb9f6a63cf6b96ef3961e1d01ed79" => :mountain_lion
  end

  needs :openmp # => :recommended

  fails_with :clang do
    build 425
    cause "segmentation fault when running Fasttree"
    # See also discussion to use -DNO_SSE (https://github.com/Homebrew/homebrew-science/pull/96)
  end

  def install
    system "#{ENV.cc} -DOPENMP -fopenmp -O3 -finline-functions -funroll-loops -Wall -o FastTree FastTree-#{version}.c -lm"
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
