class Pykep < Formula
  homepage "http://esa.github.io/pykep/"
  url "https://github.com/esa/pykep/archive/1.2.1.tar.gz"
  sha256 "e297ea58079fe9d766215f20749d32ec57b4edc91ec1e83cd19ca5c212301608"
  head "https://github.com/esa/pykep.git"

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
