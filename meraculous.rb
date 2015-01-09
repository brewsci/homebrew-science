class Meraculous < Formula
  homepage "http://jgi.doe.gov/data-and-tools/meraculous/"
  #doi "10.1371/journal.pone.0023501"
  #tag "bioinformatics

  url "https://downloads.sourceforge.net/project/meraculous20/release-2.0.4.tgz"
  sha1 "a13e30cd7d694ed53565d007ba38c67ad230c7e2"

  depends_on "Log::Log4perl" => :perl
  depends_on "boost"
  depends_on "cmake" => :build

  fails_with :clang do
    build 600
    cause "error: 'tr1/functional' file not found"
  end

  def install
    # Fix Could not find the following static Boost libraries: boost_thread
    inreplace "src/c/CMakeLists.txt",
      "set(Boost_USE_MULTITHREADED OFF)",
      "set(Boost_USE_MULTITHREADED ON)"

    # Fix error: asm/param.h: No such file or directory
    # Fix error: 'HZ' undeclared (first use in this function)
    inreplace "src/c/linux.c",
      "#include <asm/param.h>",
      "#define HZ 100" if OS.mac?

    # Fix ld: library not found for -lrt
    inreplace "src/c/CMakeLists.txt",
      'set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lrt" )',
      "" if OS.mac?

    # Fix env: perl\r: No such file or directory
    inreplace "src/perl/test_dependencies.pl", "\r", ""

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/run_meraculous.sh", "--version"
    system "#{prefix}/test_install.sh"
  end
end
