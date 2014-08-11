require "formula"
require "open3"

class Vislcg3 < Formula
  homepage "http://beta.visl.sdu.dk/cg3.html"
  url "http://beta.visl.sdu.dk/download/vislcg3/vislcg3-0.9.8.10063.tar.bz2"
  sha1 "98943be3d85824be9c256b501f8c58cd937c51ee"
  head "http://beta.visl.sdu.dk/svn/visl/tools/vislcg3/trunk", :using => :svn

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  option "without-check", "Disable build-time checking (not recommended)"

  def install
    ENV["LDFLAGS"]  = "-L#{Formula["icu4c"].opt_lib}"
    ENV["CPPFLAGS"] = "-I#{Formula["icu4c"].opt_include}"
    system "cmake", ".", *std_cmake_args
    system "make"

    if build.with? "check"
      Open3.popen3('./test/runall.pl', {:err => [:child, :out]}) do |input,output|
        output.read.each_line do |line|
          fail line if line.start_with?("T_") and not line.end_with?("Success Success.\n")
        end
      end
    end

    system "make", "install"
  end

  test do
    system "vislcg3", "--help"
  end
end
