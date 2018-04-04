class Meraculous < Formula
  homepage "https://jgi.doe.gov/data-and-tools/meraculous/"
  # doi "10.1371/journal.pone.0023501"
  # tag "bioinformatics

  url "https://downloads.sourceforge.net/projects/meraculous20/files/Meraculous-v2.2.5.tar.gz"
  sha256 "d318097111c6fa9a96b030f4269b5d9a35fb20a40ee174db825071e649263364"
  revision 1

  bottle :disable, "needs to be rebuilt with latest boost"

  depends_on "boost"
  depends_on "cmake" => :build
  # Depends_on "Log::Log4perl" => :perl

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

    # Fix error: undefined reference to symbol 'pthread_setspecific'
    inreplace "src/c/CMakeLists.txt",
      "target_link_libraries( ${targetName} ${Boost_LIBRARIES} )",
      "target_link_libraries( ${targetName} ${Boost_LIBRARIES} pthread )" if OS.linux?

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
