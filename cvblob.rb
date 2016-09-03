class Cvblob < Formula
  homepage "https://code.google.com/p/cvblob/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cvblob/cvblob-0.10.4-src.tgz"
  sha256 "94eff3eed03370fac98e9d26a43405a3ac8eb3ca1621157c5738967b95c67bc1"

  bottle do
    cellar :any
    sha256 "1afc574079f3955bc2f44cfb6a8cb5219944b41f5725ada28d62ce29c2f42f9d" => :el_capitan
    sha256 "bbbfb09024259cd0f0ea91b461a2e8ad4b34f0c44582ce8980bbdb0365754281" => :yosemite
    sha256 "bba8a86fba6652c6bb42c69724b12c19b4ded91a871813597cbe7f82a34341bf" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "opencv"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
