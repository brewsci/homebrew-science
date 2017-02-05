class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v3.3.0.tar.gz"
  sha256 "8422c67994f8dc6a2f201523a14f6c7d7e16313bdd404c460c16079dbeafc662"
  revision 2

  bottle do
    sha256 "56b4c2e1fe21338cc491adcecab518f24a214746f11325557b0928754e78785e" => :sierra
    sha256 "32f2005f6c3475461812d9c994037b2f20b8fc08af96ce46141d94a29b8508a6" => :el_capitan
    sha256 "4906b8c27515a71e93877cd7cfd247af7f2248d67975ef3feef817da362977d7" => :yosemite
    sha256 "e2eec7987670b39d374c6711f955eee70e00a91996172307913246e5ff23c8b6" => :x86_64_linux
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
    system compiler, "-I#{opt_include}", "-L#{opt_lib}", "-lcgns", testpath/"test.c"
    assert_match(/#{version}/, shell_output("./a.out"))
  end
end
