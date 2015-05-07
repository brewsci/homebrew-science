class Alpscore < Formula
  homepage "http://alpscore.org"
  sha256 "b043f5043f6fdca5efd8e1fc2ba0d893da0fd04bff8adaa213c797b44d68e72e"

  url "https://github.com/ALPSCore/ALPSCore/archive/v0.4.5.tar.gz"

  head "https://github.com/ALPSCore/ALPSCore.git"

  option "with-static", "Build static instead of shared libraries"
  option :cxx11
  option "with-doc",    "Build documentation"
  option "with-check",  "Build and run shipped tests"

  depends_on "cmake"   => :build
  depends_on :mpi => [:cc, :cxx, :recommended]
  # boost - check mpi and c++11
  boost_options = []
  boost_options += ["with-mpi", "without-single"] if build.with? "mpi"
  boost_options << "c++11" if build.cxx11?
  depends_on "boost" => boost_options
  # hdf5 - check c++11
  depends_on "hdf5" => ((build.cxx11?) ? ["c++11"] : [])

  def install
    args = std_cmake_args
    # force release mode (taken from eigen formula)
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
    args_compile = ["test.cpp", "-lalps-accumulators", "-lalps-hdf5", "-lalps-utilities", "-lalps-params"]
    args_compile << "-lboost_filesystem-mt" << "-lboost_system-mt" << "-lboost_program_options-mt"
    if build.with? "mpi"
      args_compile << "-lboost_mpi-mt"
    end
    args_compile << "-o" << "test"
    if build.with? "mpi"
      system "mpicxx", *args_compile
    else
      system ENV.cxx, *args_compile
    end
    system "./test"
  end
end
