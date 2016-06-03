class Fasttree < Formula
  homepage "http://microbesonline.org/fasttree/"
  # doi "10.1371/journal.pone.0009490"
  # tag "bioinformatics"

  url "http://microbesonline.org/fasttree/FastTree-2.1.8.c"
  sha256 "b172d160f1b12b764d21a6937c3ce01ba42fa8743d95e083e031c6947762f837"

  bottle do
    cellar :any
    revision 1
    sha256 "aa51e0bac1e69fdcca6b7bc3ce2f991cd8ebddccda9bd017dd9d7c97c37d3b9f" => :yosemite
    sha256 "8fc2e85716afb2b6230faa5ddf48398cc3e8905106a0d429193add343e24dbc4" => :mavericks
    sha256 "4118a55ddf727c3069c9380d164d716e403554b2dff6b5bb833686cb21a3ec19" => :mountain_lion
    sha256 "642dfb0168fb2ebfcb8314206da71aa9d4aa70c7d4ee7d77fe1a882e2f4e0c3b" => :x86_64_linux
  end

  option "with-double", "Use double precision maths for accurate branch lengths (disables SSE)"
  option "without-openmp", "Disable multithreading support"
  option "without-sse", "Disable SSE parallel instructions"

  needs :openmp

  def install
    opts = %w[-O3 -finline-functions -funroll-loops]
    opts << "-DOPENMP" << "-fopenmp" if build.with? "openmp"
    opts << "-DUSE_DOUBLE" if build.with? "double"
    opts << "-DNO_SSE" if build.without? "sse"
    system ENV.cc, "-o", "FastTree", "FastTree-#{version}.c", "-lm", *opts
    bin.install "FastTree"
  end

  test do
    (testpath/"test.fa").write <<-EOF.undent
      >1
      LCLYTHIGRNIYYGSYLYSETWNTTTMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >2
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >3
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGTTLPWGQMSFWGATVITNLFSAIPYIGTNLV
    EOF
    assert_match(/1:0.\d+,2:0.\d+,3:0.\d+/, `#{bin}/FastTree test.fa`)
  end
end
