class Pykep < Formula
  homepage "https://esa.github.io/pykep/"
  url "https://github.com/esa/pykep/archive/1.2.1.tar.gz"
  sha256 "e297ea58079fe9d766215f20749d32ec57b4edc91ec1e83cd19ca5c212301608"
  head "https://github.com/esa/pykep.git"
  revision 1

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
