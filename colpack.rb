class Colpack < Formula
  desc "Graph Coloring Algorithm Package"
  homepage "http://cscapes.cs.purdue.edu/coloringpage"
  url "https://github.com/CSCsw/ColPack/archive/v1.0.10.tar.gz"
  sha256 "b22ead7da80fa1735291b2d83198adf41bf36101e4fcb2c4f07c1cfacf211c75"
  head "https://github.com/CSCsw/ColPack.git"

  bottle do
    cellar :any
    sha256 "be9b05b68f33440ff8e8c4bf496afd6b9f6ed3b50cb2582a8eca29d3e2b4105c" => :el_capitan
    sha256 "579049570e51e0ade0376c95c52402d009f36c16f8d212442403b060ceb96181" => :yosemite
    sha256 "9608aa9a9f9c696f047b030983c597014fe413f7dccefbcd2a3c96fe1ef93183" => :mavericks
    sha256 "eaafd0123afb2736ccdea1c7591c9d711d009e14e3f8235043492a1539c635e7" => :x86_64_linux
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
