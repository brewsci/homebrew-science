class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.7.1.tar.gz"
  sha256 "d9aa4f318df9e8f4bbc31a540209ef47a808b99a5627852e42d2550bd979ccc3"
  head "https://github.com/alembic/alembic.git"

  bottle do
    sha256 "c85bcfda2b6a36678808ce74c22846c88e2e25dd5c0839719133c6a0550d7c15" => :sierra
    sha256 "f3cdf29c171cc8578fe122e0a7a055b39576f5b1cb7f3a552e7f679308ac2587" => :el_capitan
    sha256 "61f2efadcc5b710c140666e335c413cee1f89a7e6c4eaf90bba6eeae8c01dbaf" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "hdf5" => :build
  depends_on "ilmbase"

  def install
    ENV.cxx11
    ENV.prepend "LDFLAGS", "-lmpi" if Tab.for_name("hdf5").with? "mpi"

    cmake_args = std_cmake_args + %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
      -DUSE_STATIC_HDF5=ON
      -DUSE_EXAMPLES=ON
    ]
    system "cmake", ".", *cmake_args
    system "make"

    # Re-enable for > 1.7.0
    # system "make", "test"

    system "make", "install"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
