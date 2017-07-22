class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v3.3.1.tar.gz"
  sha256 "81093693b2e21a99c5640b82b267a495625b663d7b8125d5f1e9e7aaa1f8d469"

  bottle do
    sha256 "fbe0a2d65790e3acc942bbb851b6f4eb6ad2f9e52fbc86d373a0cb4c0f299e95" => :sierra
    sha256 "b2635b61047108a422540b66cccebc927a0ebc738e5d2091c3d3e0a9e9127890" => :el_capitan
    sha256 "27d4705b7b09b7c5991be0b8779a239301227196777d053f7e9e974680597705" => :yosemite
    sha256 "9fcd6ee301f553ff0b4c174eda6de21593f991f9f8ecd22152b377a5b5a85a42" => :x86_64_linux
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
    # compiler may be h5cc (Superenv is not supported in that case)
    rpath = "-Wl,-rpath=#{Formula["szip"].opt_lib}" unless OS.mac?
    system compiler, "-I#{opt_include}", testpath/"test.c", "-L#{opt_lib}", "-lcgns", *rpath
    assert_match(/#{version}/, shell_output("./a.out"))
  end
end
