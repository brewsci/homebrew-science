class Joinx < Formula
  homepage "http://gmt.genome.wustl.edu/joinx"
  url "https://github.com/genome/joinx.git",
    :tag => "v1.7.4", :revision => "350f063c9213f64d9db669ce6f94d162cb0075ab"
  revision 1

  bottle :disable, "needs to be rebuilt with latest boost"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    raise "JoinX fails to build on Mac OS. See https://github.com/genome/joinx/issues/3" if OS.mac?
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "joinx --version 2>&1 |grep -q joinx"
  end
end
