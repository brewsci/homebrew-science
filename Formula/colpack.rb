class Colpack < Formula
  desc "Graph Coloring Algorithm Package"
  homepage "http://cscapes.cs.purdue.edu/coloringpage"
  url "https://github.com/CSCsw/ColPack/archive/v1.0.10.tar.gz"
  sha256 "b22ead7da80fa1735291b2d83198adf41bf36101e4fcb2c4f07c1cfacf211c75"
  head "https://github.com/CSCsw/ColPack.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7b604fc98de89fff87975d3f2d4bb12cdff2e34c42e7868d90903e045b365ed5" => :sierra
    sha256 "7ffdc149dbd86998420b86946124631640d9dbcf689e4880c7cbfc5aa1449142" => :el_capitan
    sha256 "6a3a36e9714f47b9b0a0c1743687cdfb100f38f197d79cfe858f05084220ff9d" => :yosemite
  end

  option "with-openmp", "Build with OpenMP support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  needs :openmp if build.with? "openmp"

  def install
    ENV.libcxx
    system "autoreconf", "-vif"
    args = []
    args << "--enable-openmp" if build.with? "openmp"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", *args
    system "make", "install"
    pkgshare.install "Graphs"
  end

  test do
    ENV.libcxx
    cp pkgshare/"Graphs/column-compress.mtx", testpath
    (testpath/"test.cpp").write <<-EOS.undent
      #include "ColPack/ColPackHeaders.h"

      using namespace ColPack;
      using namespace std;

      #ifndef TOP_DIR
      #define TOP_DIR "."
      #endif

      string baseDir=TOP_DIR;

      int main(int argc, char ** argv) {
        string s_InputFile; //path of the input file
        s_InputFile = baseDir;
        s_InputFile += DIR_SEPARATOR; s_InputFile += "column-compress.mtx";

        BipartiteGraphPartialColoringInterface *g = new BipartiteGraphPartialColoringInterface(SRC_FILE, s_InputFile.c_str(), "AUTO_DETECTED");
        g->PartialDistanceTwoColoring("SMALLEST_LAST", "ROW_PARTIAL_DISTANCE_TWO");

        g->PrintPartialColoringMetrics();
        vector<int> vi_VertexPartialColors;
        g->GetVertexPartialColors(vi_VertexPartialColors);
        g->PrintPartialColors();

        if(g->CheckPartialDistanceTwoColoring() == _FALSE)
          cout << "FAILURE" << endl;
        else
          cout << "SUCCESS" << endl;

        delete g;
        return 0;
      }
    EOS
    args = ["test.cpp", "-I#{opt_include}", "-L#{opt_lib}", "-lColPack", "-o", "test"]
    system *(ENV.cxx.split + args)
    system "./test"
    assert_equal `./test | grep 'SUCCESS'`.strip, "SUCCESS"
  end
end
