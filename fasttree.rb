class Fasttree < Formula
  desc "Approximately-maximum-likelihood phylogenetic trees"
  homepage "http://microbesonline.org/fasttree/"
  # doi "10.1371/journal.pone.0009490"
  # tag "bioinformatics"

  url "http://microbesonline.org/fasttree/FastTree-2.1.10.c"
  sha256 "54cb89fc1728a974a59eae7a7ee6309cdd3cddda9a4c55b700a71219fc6e926d"

  bottle do
    cellar :any
    sha256 "fc2d0e48e2ac4d63a0b4f978efd7897489e06897ebb9a6b52166f6b6569fc91c" => :sierra
    sha256 "cd24fcca9c9f8b1dca0edd11e5bf7b539e6ddbd8dc06c4d7f995e40bd5271acf" => :el_capitan
    sha256 "33a1e9a3d54465681eadfd6777b67147d5f584e7eb2a9418e42268aca756c9e8" => :yosemite
    sha256 "ddd430ae428470ad6de97032f78c7766ffd096f6a3af489dd1af8a1ee94dfc99" => :x86_64_linux
  end

  # 26 Aug 2017; Community mostly wants USE_DOUBLE; make it default now
  # http://www.microbesonline.org/fasttree/#BranchLen
  # http://darlinglab.org/blog/2015/03/23/not-so-fast-fasttree.html

  option "without-double", "Disable double precision floating point. Use single precision floating point and enable SSE."
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
    assert_match version.to_s, shell_output("#{bin}/FastTree -expert 2>&1")
    (testpath/"test.fa").write <<-EOF.undent
      >1
      LCLYTHIGRNIYYGSYLYSETWNTTTMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >2
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >3
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGTTLPWGQMSFWGATVITNLFSAIPYIGTNLV
    EOF
    assert_match /1:0.\d+,2:0.\d+,3:0.\d+/, shell_output("#{bin}/FastTree test.fa 2>&1")
  end
end
