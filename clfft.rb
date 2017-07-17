class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.12.2.tar.gz"
  sha256 "e7348c146ad48c6a3e6997b7702202ad3ee3b5df99edf7ef00bbacc21e897b12"

  bottle do
    cellar :any
    sha256 "f4ddda4b532eb41b6b58e56a58837eba0561a26b65b1dea5725b33c5f59215f7" => :sierra
    sha256 "d8cba69a31109556c36d1c6d6862ebb7b827f0f3a31eaa8805a736f6c3a0c7ad" => :el_capitan
    sha256 "47f9f2d610da05ff130cd6a90891e7620d8dfea58d670f887db10263f82da5ab" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "../src", "-DBUILD_EXAMPLES:BOOL=OFF", "-DBUILD_TEST:BOOL=OFF", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "src/examples"
  end

  test do
    cp pkgshare/"examples/fft1d.c", "fft1d.cxx"
    system ENV.cxx, "fft1d.cxx", "-I#{include}", "-L#{lib}", "-lclFFT",
                    "-framework", "OpenCL", "-o", "fft1d"

    # The actual results are incorrect on the Homebrew CI virtual machines
    # but on bare metal the fft result should match (120.000000, 360.000000).
    assert_match "fft result", shell_output("./fft1d")
  end
end
