require "open3"

class Vislcg3 < Formula
  desc "Constraint grammar for visual interactive syntax learning"
  homepage "http://beta.visl.sdu.dk/cg3.html"
  url "http://beta.visl.sdu.dk/download/vislcg3/cg3-0.9.9~r10800.tar.bz2"
  sha256 "c85446c671fdb55dc01bf6092dd32ccb05ad4e057563d5c4293ee2409df610ba"
  head "http://beta.visl.sdu.dk/svn/visl/tools/vislcg3/trunk", :using => :svn
  revision 2

  bottle do
    cellar :any
    sha256 "6ad041538c79cbcc10ab6557efb4cd8df4724d141ef85de03697245f59819628" => :el_capitan
    sha256 "d71978d0f161a53c2dadda8f1cde9d61e8477a82d32e9f4e7623aff88c5b009d" => :yosemite
    sha256 "dd5da600c2221cea9a66f86cda03683f61564ac5679aae4f4dcdfc80fcafe844" => :mavericks
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
          raise line if line.start_with?("T_") && !line.end_with?("Success Success.\n")
        end
      end
    end

    system "make", "install"
  end

  test do
    system "vislcg3", "--help"
  end
end
