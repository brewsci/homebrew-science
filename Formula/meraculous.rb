class Meraculous < Formula
  homepage "https://jgi.doe.gov/data-and-tools/meraculous/"
  # doi "10.1371/journal.pone.0023501"
  # tag "bioinformatics

  url "https://downloads.sourceforge.net/project/meraculous20/release-2.0.4.tgz"
  sha256 "3a5fc76524db9ab5a4af88898f5d91957f53819b42e16d3913622eb5a0f35b9b"
  revision 1

  depends_on "cmake" => :build
  depends_on "boost"
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
    if OS.mac?
      inreplace "src/c/linux.c",
        "#include <asm/param.h>",
        "#define HZ 100"
    end

    # Fix ld: library not found for -lrt
    if OS.mac?
      inreplace "src/c/CMakeLists.txt",
        'set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lrt" )',
        ""
    end

    # Fix error: undefined reference to symbol 'pthread_setspecific'
    if OS.linux?
      inreplace "src/c/CMakeLists.txt",
        "target_link_libraries( ${targetName} ${Boost_LIBRARIES} )",
        "target_link_libraries( ${targetName} ${Boost_LIBRARIES} pthread )"
    end

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
