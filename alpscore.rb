class Alpscore < Formula
  desc "Applications and Libraries for Physics Simulations"
  homepage "http://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/v2.1.0.tar.gz"
  sha256 "d254f4c6a43a76ff85cea7ba46c2fef90cf0770f4270d8a591c5aad25facfa47"
  head "https://github.com/ALPSCore/ALPSCore.git"

  bottle do
    cellar :any
    sha256 "8cf520494570bdc24b61f289fd3d4a00220c2061bd99012bc966ac517aa11aa0" => :high_sierra
    sha256 "717d2b0c0d6af1733fd0f3a9f1f4a410798d8b55cbc62cb9a5878fcc1d290db7" => :sierra
    sha256 "93bf8395229b560063892082f6c7697545cc5a5684b3baba61b265bde12e3063" => :el_capitan
    sha256 "e203c53c701532feeb5aa98128a097328d29cf80e13f4eef73460f922b646d4d" => :x86_64_linux
  end

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
