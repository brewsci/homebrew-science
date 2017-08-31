class Openmeeg < Formula
  desc "Package for low-frequency bio-electromagnetism forward models"
  homepage "https://openmeeg.github.io"
  url "https://github.com/openmeeg/openmeeg/archive/2.4-rc.tar.gz"
  sha256 "431c3598d76b7ef282ca9c7729a0e259d54012246463dea239c7dfc5913cf6a0"
  head "https://github.com/openmeeg/openmeeg.git"

  bottle do
    cellar :any
    sha256 "54ee28ca0bf4a95c1218af5f0eca8b33e6f91e92aebfb71e304362716104453e" => :sierra
    sha256 "f5b43d31a3824f1bc1228ae2d20e4e10f2c7c8a1def2d884dd2c571d9f6e6dd9" => :el_capitan
    sha256 "24329f1ded566b7b80f1455dd42f21d5b96590bd7a297016e53dd607d46df1fe" => :yosemite
    sha256 "c193f07c03481244b9541700dc5663c1a93fcdf7fb35e452b5aea54dbef3a701" => :x86_64_linux
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
