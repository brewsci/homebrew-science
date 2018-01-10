class Openmeeg < Formula
  desc "Package for low-frequency bio-electromagnetism forward models"
  homepage "https://openmeeg.github.io"
  url "https://github.com/openmeeg/openmeeg/archive/2.4-rc.tar.gz"
  sha256 "431c3598d76b7ef282ca9c7729a0e259d54012246463dea239c7dfc5913cf6a0"
  head "https://github.com/openmeeg/openmeeg.git"

  bottle do
    sha256 "94a34600db09392fa39c2d2547e3db8fd383359deb530b4bd47469257e2a0bd1" => :sierra
    sha256 "f4031a9ebb02f8f4097596887ed188d771703b3b832dea5b699d7ace64524d4f" => :el_capitan
    sha256 "3d0a3e81f90f838ce050ccaa0c9b26a41155ccc83fa02f5961fff24b2fcd4247" => :yosemite
    sha256 "426926dd9ab78cf59045f3263adae757cbfe8a093ece5445e216c5e687b8b27c" => :x86_64_linux
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
