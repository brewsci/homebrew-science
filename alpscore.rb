class Alpscore < Formula
  desc "Applications and Libraries for Physics Simulations"
  homepage "http://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/v2.1.0.tar.gz"
  sha256 "d254f4c6a43a76ff85cea7ba46c2fef90cf0770f4270d8a591c5aad25facfa47"
  head "https://github.com/ALPSCore/ALPSCore.git"

  option "with-test",   "Build and run shipped tests"
  option "with-doc",    "Build documentation"
  option "with-static", "Build static instead of shared libraries"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx, :recommended]
  depends_on "boost"
  depends_on "eigen"
  depends_on "hdf5"

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3"
    args.delete "-DCMAKE_BUILD_TYPE=None"
    args << "-DCMAKE_BUILD_TYPE=Release"

    if build.with? "static"
      args << "-DALPS_BUILD_STATIC=ON"
      args << "-DALPS_BUILD_SHARED=OFF"
    else
      args << "-DALPS_BUILD_STATIC=OFF"
      args << "-DALPS_BUILD_SHARED=ON"
    end

    args << "-DENABLE_MPI=" + (build.with?("mpi") ? "ON" : "OFF")
    args << "-DDocumentation=" + (build.with?("doc") ? "ON" : "OFF")
    args << "-DTesting=" + (build.with?("test") ? "ON" : "OFF")

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
      "-L#{lib}", "-L#{Formula["boost"].opt_lib}",
      "-lalps-accumulators", "-lalps-hdf5", "-lalps-utilities", "-lalps-params",
      "-lboost_filesystem-mt", "-lboost_system-mt", "-lboost_program_options-mt",
      "-I#{include}", "-I#{Formula["boost"].opt_include}"
    ]
    args_compile << "-o" << "test"
    system (build.with?("mpi") ? "mpicxx" : ENV.cxx), *args_compile
    system "./test"
  end
end
