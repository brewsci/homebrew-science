class Openmeeg < Formula
  desc "Package for low-frequency bio-electromagnetism forward models"
  homepage "https://openmeeg.github.io"
  url "https://github.com/openmeeg/openmeeg/archive/2.4.prerelease.tar.gz"
  version "2.4.prerelease"
  sha256 "fabf9addfcb99d3b3161acde98104a321ec926a1968e444edfce5334adb1ae87"

  head "https://github.com/openmeeg/openmeeg.git"

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "zlib" unless OS.mac?
  depends_on "openblas" unless OS.mac?

  def install
    args = std_cmake_args + %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_PYTHON=OFF
      -DBUILD_DOCUMENTATION=OFF
      -DUSE_PROGRESSBAR=ON
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
