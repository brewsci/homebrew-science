require "open3"

class Vislcg3 < Formula
  desc "Constraint grammar for visual interactive syntax learning"
  homepage "https://beta.visl.sdu.dk/cg3.html"
  url "https://visl.sdu.dk/download/vislcg3/cg3-1.1.0~r12312.tar.bz2"
  version "1.1.0"
  sha256 "b3702b80ee3adceda482ca759918168e18900c63fe6d1a0b70b3c698f8213399"
  version_scheme 1
  head "https://github.com/TinoDidriksen/cg3.git"

  bottle do
    cellar :any
    sha256 "6ad041538c79cbcc10ab6557efb4cd8df4724d141ef85de03697245f59819628" => :el_capitan
    sha256 "d71978d0f161a53c2dadda8f1cde9d61e8477a82d32e9f4e7623aff88c5b009d" => :yosemite
    sha256 "dd5da600c2221cea9a66f86cda03683f61564ac5679aae4f4dcdfc80fcafe844" => :mavericks
  end

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
