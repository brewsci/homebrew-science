class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v3.3.0.tar.gz"
  sha256 "8422c67994f8dc6a2f201523a14f6c7d7e16313bdd404c460c16079dbeafc662"
  revision 3

  bottle do
    sha256 "d5e2478d2e8886152d81a1bc798fa6fe2b7712f6848f6e704a4dc00714b39531" => :sierra
    sha256 "b828da7aa851fcd02abd2ed4a6796e6afb6f48bf09ffe044101cbe8d8f74166e" => :el_capitan
    sha256 "1e43fb4669d044f1ffa72c0c66489901cf61c3a059e083f6f9021763b827d188" => :yosemite
    sha256 "174bc33b78185d007af6fed3f0768bd8aa0f699f209f3edcc0d0111c75821ff2" => :x86_64_linux
  end

  depends_on :fortran => :optional
  depends_on "cmake" => :build
  depends_on "hdf5" => :recommended
  depends_on "szip"

  def install
    args = std_cmake_args + [
      "-DCGNS_ENABLE_TESTS=YES",
    ]

    args << "-DCGNS_ENABLE_64BIT=YES" if Hardware::CPU.is_64_bit? && MacOS.version >= :snow_leopard
    args << "-DCGNS_ENABLE_FORTRAN=YES" if build.with? "fortran"

    if build.with? "hdf5"
      args << "-DCGNS_ENABLE_HDF5=YES"
      args << "-DHDF5_NEED_ZLIB=YES"
      args << "-DHDF5_NEED_SLIB=YES"
      args << "-DCMAKE_SHARED_LINKER_FLAGS=-lhdf5"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "ctest", "--output-on-failure"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "cgnslib.h"
      int main(int argc, char *argv[])
      {
        int filetype = CG_FILE_NONE;
        // we expect this to fail, as the test executable isn't a CGNS file
        if (cg_is_cgns(argv[0], &filetype) != CG_ERROR)
          return 1; // should fail!
        printf(\"%d.%d.%d\\n\",CGNS_VERSION/1000,(CGNS_VERSION/100)%10,(CGNS_VERSION/10)%10);
        return 0;
      }
    EOS
    compiler = Tab.for_name("cgns").with?("hdf5") ? "h5cc" : ENV.cc
    # The rpath to szip needs to be passed explicitely here because the
    # compiler may be h5cc (std env is not supported in that case)
    rpath = OS.mac? ? "" : "-Wl,-rpath=#{Formula["szip"].opt_lib}"
    system compiler, "-I#{opt_include}", testpath/"test.c", "-L#{opt_lib}", "-lcgns", *rpath
    assert_match(/#{version}/, shell_output("./a.out"))
  end
end
