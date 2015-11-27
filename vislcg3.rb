require "open3"

class Vislcg3 < Formula
  desc "Constraint grammar for visual interactive syntax learning"
  homepage "http://beta.visl.sdu.dk/cg3.html"
  url "http://beta.visl.sdu.dk/download/vislcg3/cg3-0.9.9~r10800.tar.bz2"
  sha256 "c85446c671fdb55dc01bf6092dd32ccb05ad4e057563d5c4293ee2409df610ba"
  head "http://beta.visl.sdu.dk/svn/visl/tools/vislcg3/trunk", :using => :svn
  revision 1

  bottle do
    cellar :any
    sha256 "ce6ef548649d6251d3b5d00b52c07cdb45115b45a97deb3d50bd7391cc9acf1d" => :yosemite
    sha256 "4cd4219de2c35319635a427464c2d0128425c054e3d8cf3b8c8e577571b105e8" => :mavericks
    sha256 "e40f0caec6e68ad7f37a2423f3be0a0a83c7971470dbc70568f8b7f95b8f4f4d" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  option "without-check", "Disable build-time checking (not recommended)"

  def install
    # Patch submitted to tino@didriksen.cc on 2015-11-27
    inreplace "CMakeLists.txt", "share/emacs/site-lisp", elisp if build.stable?

    ENV["LDFLAGS"]  = "-L#{Formula["icu4c"].opt_lib}"
    ENV["CPPFLAGS"] = "-I#{Formula["icu4c"].opt_include}"
    system "cmake", ".", *std_cmake_args
    system "make"

    if build.with? "check"
      Open3.popen3("./test/runall.pl", :err => [:child, :out]) do |_, output|
        output.read.each_line do |line|
          fail line if line.start_with?("T_") && !line.end_with?("Success Success.\n")
        end
      end
    end

    system "make", "install"
  end

  test do
    system "vislcg3", "--help"
  end
end
