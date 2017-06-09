class Express < Formula
  desc "Streaming quantification for sequencing"
  homepage "http://bio.math.berkeley.edu/eXpress/"
  url "https://pachterlab.github.io/eXpress/downloads/express-1.5.1/express-1.5.1-src.tgz"
  sha256 "0c5840a42da830fd8701dda8eef13f4792248bab4e56d665a0e2ca075aff2c0f"
  revision 6
  head "https://github.com/adarob/eXpress.git"

  # doi "10.1038/nmeth.2251"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "e44cf3534d38541e34b24d4ee71a24e8003eeb8d843e1428f4e09af64967245a" => :sierra
    sha256 "8fd9d0d653f6da2bbfddad1718697b9b588d663a7b562174b52ef03edeafdbd6" => :el_capitan
    sha256 "73389dbec6e88bb833b282dc7f908356e7e58487b6418623815e03dc20cfd520" => :yosemite
    sha256 "72fb7b67554ebb75492b73930cf493021a5fd319a6cc5825855699c69390df1d" => :x86_64_linux
  end

  depends_on "bamtools"
  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "protobuf" => :recommended
  depends_on "gperftools" => :recommended

  def install
    inreplace "CMakeLists.txt", "set(Boost_USE_STATIC_LIBS ON)", ""

    # Fix undefined reference to `deflate'
    inreplace "src/CMakeLists.txt", 'libbamtools.a"', 'libbamtools.a" "-lz"'

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
