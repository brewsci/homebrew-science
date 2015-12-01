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
    sha256 "cd3a5d4bfc63abe80d3fc2cc01956f59fea8d8e5b7a43f7ccbd348aae8cee5b9" => :el_capitan
    sha256 "195d4a7400c912e6722689a877d620a2aa6f3118f0ae5a9948df87da582a9d4e" => :yosemite
    sha256 "993e515869d8326082a9ac9df18b7931620eb3dca0758aee8aaf2e3c9b9016de" => :mavericks
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
