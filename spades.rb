class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://spades.bioinf.spbau.ru/release3.9.0/SPAdes-3.9.0.tar.gz"
  sha256 "77436ac5945aa8584d822b433464969a9f4937c0a55c866205655ce06a72ed29"
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fe79222d79529b1db700030902500514c5e4c399b756e6d2e9466511bffc03f1" => :sierra
    sha256 "244ebfd9ed2461e003dc2ebb9030b11ef0c2e0e705b7da0fc533feb4c3b23d71" => :el_capitan
    sha256 "d807d6322131bde60c4da57bb90136f549f48532dbc1b05d7268d9cbf4dc617e" => :yosemite
    sha256 "c44b851d733c90d1109abeb8daa6cd68d66327eddf84c629494e373283fe0377" => :mavericks
    sha256 "f7562b7fb92d4771a3cd5d3499e6cf2338581315fafef58e1ae3ed94d1b5b2f8" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on :python if OS.linux?

  needs :openmp

  fails_with :gcc => "4.7" do
    cause "Compiling SPAdes requires GCC >= 4.7 for OpenMP 3.1 support"
  end

  # Fix malloc: *** malloc_zone_unregister() failed for 0x7fffb1c3c000
  # Upstream issue "jemalloc upgrade needed to fix macOS Sierra"
  # Reported 20 Nov 2016 https://github.com/ablab/spades/issues/9
  # Underlying jemalloc issue: https://github.com/jemalloc/jemalloc/pull/427
  if MacOS.version >= :sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f31c35f/spades/jemalloc-sierra-fix.diff"
      sha256 "7f362d7e60b60147a41b449f34e6210370031e974a588c51347f869559cf0775"
    end
  end

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/spades.py", "--test"
  end
end
