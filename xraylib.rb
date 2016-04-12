class Xraylib < Formula
  desc "Library for interactions of X-rays with matter"
  homepage "https://github.com/tschoonj/xraylib"
  url "http://lvserver.ugent.be/xraylib/xraylib-3.2.0.tar.gz"
  mirror "https://xraylib.s3.amazonaws.com/xraylib-3.2.0.tar.gz"
  sha256 "a734a0ea7b8224918f4e2105a4cf6c63664f257c1940a4c633beedf470d1576b"

  bottle do
    revision 3
    sha256 "2679835f1babe9b20a8878ec828745b11ef8a91256ebe8c6215eac7495e35e25" => :el_capitan
    sha256 "975d5b6c18d468ec8d07c1a49d52d88a6bf9c0e8add777c67dd7b1e6dee5f282" => :yosemite
    sha256 "877e7a203aa6f70cba9a1f458970802e1a14b1eec020308d36c68e4181ee327b" => :mavericks
  end

  option "with-perl", "Build with perl support"
  option "with-ruby", "Build with ruby support"

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on :fortran => :optional
  depends_on "lua" => :optional
  depends_on "fpc" => :optional

  depends_on "swig" => :build

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-idl
      --disable-python-numpy
      --disable-php
      --disable-java
    ]

    args << ((build.with? "fortran") ? "--enable-fortran2003" : "--disable-fortran2003")
    args << ((build.with? "perl") ? "--enable-perl" : "--disable-perl")
    args << ((build.with? "lua") ? "--enable-lua" : "--disable-lua")
    args << ((build.with? "ruby") ? "--enable-ruby" : "--disable-ruby")
    args << ((build.with? "pascal") ? "--enable-pascal" : "--disable-pascal")

    if build.without?("python") && build.with?("python3")
      args << "--enable-python"
      args << "PYTHON=python3"
      system "./configure", *args
      system "make"
      system "make", "install"
    elsif build.with?("python") && build.without?("python3")
      args << "--enable-python"
      system "./configure", *args
      system "make"
      system "make", "install"
    elsif build.with?("python3")
      # build for both python2 and python3 bindings
      # since the configure script allows for only one python binding,
      # some tricks are required here...
      args_nopython = args.dup
      args_python2 = args.dup
      args_python3 = args.dup
      args_nopython << "--disable-python"
      args_python2 << "--enable-python"
      args_python3 << "--enable-python" << "PYTHON=python3"

      cd("..") do
        cp_r "xraylib-#{version}", "xraylib-#{version}-python2"
        cp_r "xraylib-#{version}", "xraylib-#{version}-python3"
      end
      system "./configure", *args_nopython
      cd("../xraylib-#{version}-python2") do
        system "./configure", *args_python2
      end
      cd("../xraylib-#{version}-python3") do
        system "./configure", *args_python3
      end
      # build without python first
      system "make"
      # move the configured python directories to the main build dir
      mv "../xraylib-#{version}-python2/python", "python2"
      mv "../xraylib-#{version}-python3/python", "python3"
      # build python2 bindings
      cd("python2") do
        system "make"
      end
      # build python3 bindings
      cd("python3") do
        system "make"
      end
      # install everything except python bindings
      system "make", "install"
      # install python2 bindings
      cd("python2") do
        system "make", "install"
      end
      # finish in style by installing the python3 bindings
      cd("python3") do
        system "make", "install"
      end
    else
      # install without python
      args << "--disable-python"
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <xraylib.h>

      int main()
      {
        double energy = LineEnergy(26, KL3_LINE);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
                   "-L#{lib}", "-lxrl", "-I#{include}/xraylib", "-o", "test"
    system "./test"
  end
end
