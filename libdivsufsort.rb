class Libdivsufsort < Formula
  homepage "https://github.com/y-256/libdivsufsort"
  head "https://github.com/y-256/libdivsufsort.git"

  url "https://github.com/y-256/libdivsufsort/archive/2.0.1.tar.gz"
  sha256 "9164cb6044dcb6e430555721e3318d5a8f38871c2da9fd9256665746a69351e0"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "ba5b24f8fc34d1c1555f3fea5b3a16030a10eb569f4be4344b0b5bad245e3fc7" => :yosemite
    sha256 "36ab9a78fd5a1cfc676b5a71d9435bbccf06356012fc57dadb4fdaac4df5e17f" => :mavericks
    sha256 "bb2cef12c6be75076a57b08a604c4798e2c00d04edbbf083c725ba0a152654fd" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "libdivsufsort-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # no test due to being library only
  end
end
