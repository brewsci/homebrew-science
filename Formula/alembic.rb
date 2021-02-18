class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.7.5.tar.gz"
  sha256 "ab0c727bfc4aedfe81c2365e604fb457056dc66909575ccfe19ed406e67c002e"
  head "https://github.com/alembic/alembic.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 high_sierra:  "4d53890aadc039a24fb978f50b5c59817bd3d6922feec33c24d4ccfb0a738901"
    sha256 sierra:       "bf451135a0a1c635d3cd2aeb3698e418842b2d7e157124ec563589359e4759ac"
    sha256 el_capitan:   "787fe1aab77578c547760a6a91ae5c4a8c795c48b281e2912f9406f5006f3acb"
    sha256 x86_64_linux: "de699aea0628287445b6e2845e9fc40e154a22c194359f3f5f636eefacde7671"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
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
      -DUSE_EXAMPLES=ON
    ]
    system "cmake", ".", *cmake_args
    system "make"
    system "make", "test"
    system "make", "install"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
