class Express < Formula
  desc "Streaming quantification for sequencing"
  homepage "http://bio.math.berkeley.edu/eXpress/"
  url "https://pachterlab.github.io/eXpress/downloads/express-1.5.1/express-1.5.1-src.tgz"
  sha256 "0c5840a42da830fd8701dda8eef13f4792248bab4e56d665a0e2ca075aff2c0f"
  revision 8
  head "https://github.com/adarob/eXpress.git"

  # doi "10.1038/nmeth.2251"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "a0527b11749e8cc574e38a3bfd8931ad175aa6f047f8986adde288f63f73eb0c" => :sierra
    sha256 "eb7a09d9d1b36e6041b24c5b02a88ad01b2a990d3bb5fe5d49748390643ce43a" => :el_capitan
    sha256 "9a11baa64edfc3f0236f53da3dc3829586140bcd1d9f6138d5ce536a1144bb51" => :yosemite
    sha256 "4ccb65b32c6bacd30018eef83725afd4e4dd4595521947dbb82eeb5580a3c5b4" => :x86_64_linux
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
