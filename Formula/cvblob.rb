class Cvblob < Formula
  homepage "https://code.google.com/p/cvblob/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cvblob/cvblob-0.10.4-src.tgz"
  sha256 "94eff3eed03370fac98e9d26a43405a3ac8eb3ca1621157c5738967b95c67bc1"
  revision 1

  bottle do
    sha256 cellar: :any, sierra:       "c4a7e3257e7f79040a6ebd787bc1f6b36bd8c4ba9ee46a0f3948c118d0606a7b"
    sha256 cellar: :any, el_capitan:   "63fee00e482dfc23d0093653375c5a31452cbcd7a7695190ec510023c9174490"
    sha256 cellar: :any, yosemite:     "785fb1cbfccf5d2301d9648de027615acf2d9d7d97ab61ff0ed84d951c9cdcea"
    sha256 cellar: :any, x86_64_linux: "bb5ddd848662b841382a03641cff65fb6d49d213bbfdf737f3da4557931edbfa"
  end

  depends_on "cmake" => :build
  depends_on "opencv@2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
