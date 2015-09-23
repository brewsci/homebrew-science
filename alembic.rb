class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://code.google.com/p/alembic/",
    :using => :hg,
    :tag => "1_05_04"
  version "1.5.4"
  revision 1

  bottle do
    cellar :any
    sha256 "a652d4cae925b9f49a29ea1126d285d4345fdb74a6e090bc085facc5c123326f" => :yosemite
    sha256 "93d31f9574ba141331cdaf8cea04f7335685cd85aeec9bf18704d1bca3c2a329" => :mavericks
    sha256 "41988d94cda0abce8f408a8cd997dc10a5ab5fadcfb577c2dd3816e9e11bbed3" => :mountain_lion
  end

  head "https://code.google.com/p/alembic/", :using => :hg

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "hdf5"
  depends_on "ilmbase"

  def install
    ENV.libcxx if ENV.compiler == :clang
    cmake_args = std_cmake_args + %W[
      -DUSE_PYILMBASE=OFF
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DCMAKE_CXX_FLAGS='-std=c++11'
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"

    lib.install_symlink Dir[prefix/"alembic-#{version}/lib/static/*"]
    include.install_symlink Dir[prefix/"alembic-#{version}/include/*"]
    bin.install_symlink Dir[prefix/"alembic-#{version}/bin/*"]
  end
end
