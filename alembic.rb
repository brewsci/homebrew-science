class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.7.1.tar.gz"
  sha256 "d9aa4f318df9e8f4bbc31a540209ef47a808b99a5627852e42d2550bd979ccc3"
  head "https://github.com/alembic/alembic.git"

  bottle do
    sha256 "dafcda266affe8aa49cd13670c557281bf993864b080087abfa588022b10206d" => :sierra
    sha256 "af7d77546d9e9d71525e835a3d74885e1b2ac5e8badd6882c88dee9249c8bb80" => :el_capitan
    sha256 "3d9176b02fc574d206a159999b0e4a65c7e5dc6cf7a47395e3d9e664460af3aa" => :yosemite
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
