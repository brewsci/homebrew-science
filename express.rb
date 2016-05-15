class Express < Formula
  desc "Streaming quantification for sequencing"
  homepage "http://bio.math.berkeley.edu/eXpress/"
  url "http://bio.math.berkeley.edu/eXpress/downloads/express-1.5.1/express-1.5.1-src.tgz"
  sha256 "0c5840a42da830fd8701dda8eef13f4792248bab4e56d665a0e2ca075aff2c0f"
  revision 2
  head "https://github.com/adarob/eXpress.git"

  bottle do
    cellar :any
    sha256 "ecba8b9a720149f90e8113871f82f2d99ac1688d5a28c9e97b4c2b79df0dd5f6" => :el_capitan
    sha256 "eebcf8cdd0b5253aab314be0373728d1946b8436cf4760c1188d6abf95233ca5" => :yosemite
    sha256 "35d07bd4df9794a852220592c16a795aa667ab5a9c5f822d52a0e338d1125a87" => :mavericks
  end

  # doi "10.1038/nmeth.2251"
  # tag "bioinformatics"

  depends_on "bamtools"
  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "protobuf" => :recommended
  depends_on "gperftools" => :recommended

  def install
    inreplace "CMakeLists.txt", "set(Boost_USE_STATIC_LIBS ON)", ""
    mkdir "bamtools"
    ln_s Formula["bamtools"].include/"bamtools", "bamtools/include"
    ln_s Formula["bamtools"].lib, "bamtools/"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/express 2>&1", 1)
  end
end
