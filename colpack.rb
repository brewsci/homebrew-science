class Colpack < Formula
  desc "Graph Coloring Algorithm Package"
  homepage "http://cscapes.cs.purdue.edu/coloringpage"
  url "https://github.com/CSCsw/ColPack/archive/v1.0.10.tar.gz"
  sha256 "b22ead7da80fa1735291b2d83198adf41bf36101e4fcb2c4f07c1cfacf211c75"
  head "https://github.com/CSCsw/ColPack.git"

  bottle do
    cellar :any
    sha256 "8f58497acfce27796968d081d92aa416222d200e112e4e4b653ba928c472ad3a" => :yosemite
    sha256 "c7bde703529bca89fd52670e1b39e340753e609cfa27eb768b8580bcb0775c7b" => :mavericks
    sha256 "8aaa29a13ed9a4276387f55ff2edd60bb782600529bb7efedbd9ce4f9d43ca3e" => :mountain_lion
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
    args << "with-openmp" if build.with? "openmp"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", *args
    system "make", "install"
    pkgshare.install "Graphs"
  end

  test do
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
    system ENV.cxx, "test.cpp", "-I#{opt_include}", "-L#{opt_lib}", "-lColPack", "-o", "test"
    system "./test"
    assert_equal `./test | grep 'SUCCESS'`.strip, "SUCCESS"
  end
end
