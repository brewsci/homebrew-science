class Fasttree < Formula
  homepage "http://microbesonline.org/fasttree/"
  #doi "10.1371/journal.pone.0009490"
  #tag "bioinformatics"

  url "http://microbesonline.org/fasttree/FastTree-2.1.8.c"
  sha256 "b172d160f1b12b764d21a6937c3ce01ba42fa8743d95e083e031c6947762f837"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "369bb09b371ed05d55a403750738c5749fb95c07" => :yosemite
    sha1 "829bfc5f6fc144a6642c29b8a2e6a4e078998e8c" => :mavericks
    sha1 "acad8b55ad7eb9f6a63cf6b96ef3961e1d01ed79" => :mountain_lion
  end

  needs :openmp # => :recommended

  option "with-double", "Use double precision maths for accurate branch lengths (disables SSE)"
  option "without-openmp", "Disable multithreading support"
  option "without-sse", "Disable SSE parallel instructions"

  # See discussion (https://github.com/Homebrew/homebrew-science/pull/2134#issuecomment-94607619)
  fails_with :llvm

  fails_with :clang do
    build 425
    cause "segmentation fault when running Fasttree"
    # See also discussion to use -DNO_SSE (https://github.com/Homebrew/homebrew-science/pull/96)
  end

  def install
    opts = "-O3 -finline-functions -funroll-loops -Wall"
    opts << " -DOPENMP -fopenmp" if build.with? "openmp"
    opts << " -DUSE_DOUBLE" if build.with? "double"
    opts << " -DNO_SSE" if build.without? "sse"
    system "#{ENV.cc} #{opts} -o FastTree FastTree-#{version}.c -lm"
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
