class Alpscore < Formula
  desc "Applications and Libraries for Physics Simulations"
  homepage "http://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/v0.5.3.tar.gz"
  sha256 "87841b96e13d93f863b92daeeba06a562329b80f9e651694901dcf061327d538"
  head "https://github.com/ALPSCore/ALPSCore.git"

  bottle do
    cellar :any
    sha256 "06c6577d69e33fd0c724219a8b0d2a035e807839c2cc32158152d2ad411fbb01" => :el_capitan
    sha256 "412ad3f5b19f9770a4fb68d1e9236a0a110197594567b843108e5fbe739bedd1" => :yosemite
    sha256 "18f7f7b892857994a42b088187bffe452f292c633d4e08a6cd5636531c27c935" => :mavericks
  end

  option :cxx11
  option "with-check",  "Build and run shipped tests"
  option "with-doc",    "Build documentation"
  option "with-static", "Build static instead of shared libraries"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx, :recommended]

  boost_options = []
  boost_options << "c++11" if build.cxx11?
  depends_on "boost" => boost_options

  depends_on "hdf5" => ((build.cxx11?) ? ["c++11"] : [])

  def install
    ENV.cxx11 if build.cxx11?
    args = std_cmake_args
    args.delete "-DCMAKE_BUILD_TYPE=None"
    args << "-DCMAKE_BUILD_TYPE=Release"

    if build.with? "static"
      args << "-DBuildStatic=ON"
      args << "-DBuildShared=OFF"
    else
      args << "-DBuildStatic=OFF"
      args << "-DBuildShared=ON"
    end

    args << ("-DENABLE_MPI=" + ((build.with? "mpi") ? "ON" : "OFF"))
    args << ("-DDocumentation=" + ((build.with? "doc") ? "ON" : "OFF"))
    args << ("-DTesting=" + ((build.with? "check") ? "ON" : "OFF"))

    mkdir "tmp" do
      args << ".."
      system "cmake", *args
      system "make"
      system "make", "test" if build.with? "check"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <alps/mc/api.hpp>
      #include <alps/mc/mcbase.hpp>
      #include <alps/accumulators.hpp>
      #include <alps/params.hpp>
      using namespace std;

      int main()
      {
        alps::accumulators::accumulator_set set;
        set << alps::accumulators::FullBinningAccumulator<double>("a");
        set["a"] << 2.9 << 3.1;

        alps::params p;
        p["myparam"] = 1.0;
      }
    EOS
    args_compile = ["test.cpp",
                    "-lalps-accumulators", "-lalps-hdf5", "-lalps-utilities", "-lalps-params",
                    "-lboost_filesystem-mt", "-lboost_system-mt", "-lboost_program_options-mt"
                   ]
    args_compile << "-o" << "test"
    system ((build.with? "mpi") ? "mpicxx" : ENV.cxx), *args_compile
    system "./test"
  end
end
