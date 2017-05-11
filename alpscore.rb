class Alpscore < Formula
  desc "Applications and Libraries for Physics Simulations"
  homepage "http://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/v1.0.0.tar.gz"
  sha256 "2054f47929f3bdb6a0c07fb70e53194f884cdf6c830b737ed5d24312d060b12a"
  revision 1
  head "https://github.com/ALPSCore/ALPSCore.git"

  bottle do
    cellar :any
    sha256 "372982d70c8888e5b9ca08a0604a161afee562b14e39cf3885bdba79eebb8106" => :sierra
    sha256 "888dd120ce82409038b4fb2583cdbdf2d9795766d9f2cf171406fb69c74c0263" => :el_capitan
    sha256 "be350fadc9fe9dc9372bde185d5243757068ed4a0d62abb51d4dceb4a1bb0866" => :yosemite
  end

  option :cxx11
  option "with-test",   "Build and run shipped tests"
  option "with-doc",    "Build documentation"
  option "with-static", "Build static instead of shared libraries"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx, :recommended]

  boost_options = []
  boost_options << "c++11" if build.cxx11?
  depends_on "boost" => boost_options

  depends_on "hdf5" => (build.cxx11? ? ["c++11"] : [])

  def install
    ENV.cxx11 if build.cxx11?
    args = std_cmake_args
    args.delete "-DCMAKE_BUILD_TYPE=None"
    args << "-DCMAKE_BUILD_TYPE=Release"

    if build.with? "static"
      args << "-DALPS_BUILD_STATIC=ON"
      args << "-DALPS_BUILD_SHARED=OFF"
    else
      args << "-DALPS_BUILD_STATIC=OFF"
      args << "-DALPS_BUILD_SHARED=ON"
    end

    args << ("-DENABLE_MPI=" + ((build.with? "mpi") ? "ON" : "OFF"))
    args << ("-DDocumentation=" + ((build.with? "doc") ? "ON" : "OFF"))
    args << ("-DTesting=" + ((build.with? "test") ? "ON" : "OFF"))

    mkdir "tmp" do
      args << ".."
      system "cmake", *args
      system "make"
      system "make", "test" if build.with? "test"
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
    args_compile = [
      "test.cpp",
      "-lalps-accumulators", "-lalps-hdf5", "-lalps-utilities", "-lalps-params",
      "-lboost_filesystem-mt", "-lboost_system-mt", "-lboost_program_options-mt"
    ]
    args_compile << "-o" << "test"
    system ((build.with? "mpi") ? "mpicxx" : ENV.cxx), *args_compile
    system "./test"
  end
end
