class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v3.3.0.tar.gz"
  sha256 "8422c67994f8dc6a2f201523a14f6c7d7e16313bdd404c460c16079dbeafc662"
  revision 1

  bottle do
    sha256 "3ddff2804faa0daa2c85eae4339c56c1793d1c905c50a29f2e4ae2a58a793d7f" => :el_capitan
    sha256 "ece482f160568064a21223b6a5d4881306c69f6069503813d25146dc60bdb7cd" => :yosemite
    sha256 "6925f42ae86b056704be41aa4d8991a329f9def1837c772c6182dfd7a8b84573" => :mavericks
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
