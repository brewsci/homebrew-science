class Openmeeg < Formula
  desc "Package for low-frequency bio-electromagnetism forward models"
  homepage "https://openmeeg.github.io"
  url "https://github.com/openmeeg/openmeeg/archive/2.4.prerelease.tar.gz"
  version "2.4.prerelease"
  sha256 "fabf9addfcb99d3b3161acde98104a321ec926a1968e444edfce5334adb1ae87"
  revision 1

  head "https://github.com/openmeeg/openmeeg.git"

  bottle do
    cellar :any
    sha256 "f1dabe4afb7c10db77e35f1f6545ca92c00f02fda62727e076cd3340154a5fe0" => :sierra
    sha256 "d15f2a93dfd57aa840377e4406e733c9b845af509b1ec0b5f877b375aebf6f80" => :el_capitan
    sha256 "8cd1e3c19bcb20cb728d20e69450b9309e4f26dd8655f1ac161f0a8a55b0cfa8" => :yosemite
    sha256 "08133e00055d0ae8672a96222de77919561237132a53ca668ef6492ecc7e69c2" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "zlib" unless OS.mac?
  depends_on "openblas" unless OS.mac?

  needs :openmp

  def install
    args = std_cmake_args + %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_PYTHON=OFF
      -DBUILD_DOCUMENTATION=OFF
      -DUSE_PROGRESSBAR=ON
      -DUSE_OMP=ON
    ]

    mkdir "build" do
      args << "../OpenMEEG"
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/om_assemble"
  end
end
