require "open3"

class Vislcg3 < Formula
  desc "Constraint grammar for visual interactive syntax learning"
  homepage "https://beta.visl.sdu.dk/cg3.html"
  url "https://visl.sdu.dk/download/vislcg3/cg3-1.1.0~r12312.tar.bz2"
  version "1.1.0"
  sha256 "b3702b80ee3adceda482ca759918168e18900c63fe6d1a0b70b3c698f8213399"
  revision 1
  version_scheme 1
  head "https://github.com/TinoDidriksen/cg3.git"

  bottle :disable, "needs to be rebuilt with latest boost"

  option "without-test", "Disable build-time checking (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  def install
    # Patch submitted to tino@didriksen.cc on 2015-11-27
    inreplace "CMakeLists.txt", "share/emacs/site-lisp", elisp if build.stable?

    ENV["LDFLAGS"]  = "-L#{Formula["icu4c"].opt_lib}"
    ENV["CPPFLAGS"] = "-I#{Formula["icu4c"].opt_include}"
    system "cmake", ".", *std_cmake_args
    system "make"

    if build.with? "test"
      Open3.popen3("./test/runall.pl", :err => [:child, :out]) do |_, output|
        output.read.each_line do |line|
          raise line if line.start_with?("T_") && !line.end_with?("Success Success.\n")
        end
      end
    end

    system "make", "install"
  end

  test do
    system bin/"vislcg3", "--help"
  end
end
