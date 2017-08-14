class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.7.3.tar.gz"
  sha256 "29f9174d5b092c49aa4cf6bc526b542f0b077ba6a5137cc745d653d732ab8e8f"
  head "https://github.com/alembic/alembic.git"

  bottle do
    sha256 "8b7b41b7e9ddd894a4647eab6b219b3b809571895b85577049a0b8818d2ecd31" => :sierra
    sha256 "569276b88d2129b48d890049121335f395e880d559e078437341b98683f723e8" => :el_capitan
    sha256 "fc5e6389bc9e58c3a4d46156bc2a403cf9cbc8ace869db220c58c17c29d92158" => :yosemite
    sha256 "7790d1588de33a670b823768a3c001945bce2bba80fd08fe08e3ee925cff97cb" => :x86_64_linux
  end

  needs :cxx11

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
