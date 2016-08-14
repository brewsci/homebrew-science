class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://spades.bioinf.spbau.ru/release3.9.0/SPAdes-3.9.0.tar.gz"
  sha256 "77436ac5945aa8584d822b433464969a9f4937c0a55c866205655ce06a72ed29"
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"

  bottle do
    cellar :any
    sha256 "db0f5042ec56d0bcf08649ad10af20df27e2a8939a4944052734dfeef66fc353" => :el_capitan
    sha256 "12dcca7fe98c66081ae8d830c4021a759138fba3bdafba95fd892dd6e11084d2" => :yosemite
    sha256 "d4e258a0156efc3a38343409e9e2d7c9cd23f751233cd35bb60aa203b594e403" => :mavericks
    sha256 "45dd5265d7548493bc7305c68cf536b43286eb8fe918281d49b10b03097a76ba" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on :python if OS.linux?

  needs :openmp

  fails_with :gcc => "4.7" do
    cause "Compiling SPAdes requires GCC >= 4.7 for OpenMP 3.1 support"
  end

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "spades.py", "--test"
  end
end
