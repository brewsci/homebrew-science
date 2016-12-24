class Pykep < Formula
  desc "Library providing basic tools for astrodynamics research"
  homepage "https://esa.github.io/pykep/"
  head "https://github.com/esa/pykep.git"

  stable do
    url "https://github.com/esa/pykep/archive/v1.3.9.tar.gz"
    sha256 "1bb0a71a1d19908e3703ca6e3cc87d75f2f8b91c65c3a778e1acd1962c1e87f1"

    # Remove for > 1.3.9
    # Upstream commit from 8 Feb 2017 "fix for #57 - linking to python libraries
    # only for windows now"
    # https://github.com/esa/pykep/commit/351b628bf404ed53b3ae3e06eb8bdc56dc1deb11
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d42dc14/pykep/nopythonlinking.diff"
      sha256 "6b2372c77b0e4062145d4bed6f372d3f04283c2ab58014f8994950832e56099e"
    end
  end

  bottle do
    cellar :any
    sha256 "424c98063780416f22766c88dde90f0ebb073e7ab90da6cfcc5f767c5977110a" => :el_capitan
    sha256 "7fb75ed46eaee27e90768fae8ac68a22f6cb0452327d7b91ee5ac205d639684f" => :yosemite
    sha256 "6f78d58b1fa7234d8d241ebab7e6ed470da79f4353f1a1cd7b91fe6a7f3fb6d2" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on :python => :recommended

  def install
    args = std_cmake_args + [
      "-DBUILD_TESTS=ON",
      "-DBUILD_PYKEP=ON",
      "-DBUILD_SPICE=ON",
      "-DPYTHON_MODULES_DIR=#{lib}/python2.7/site-packages",
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import PyKEP"
    end
  end
end
