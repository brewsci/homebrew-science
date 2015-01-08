require "fileutils"

class Xraylib < Formula
  homepage "https://github.com/tschoonj/xraylib"
  url "http://lvserver.ugent.be/xraylib/xraylib-3.1.0.tar.gz"
  mirror "https://xraylib.s3.amazonaws.com/xraylib-3.1.0.tar.gz"
  sha1 "38a8ea77984234d24eeff50d94a662baa6cf6907"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "3d5cc1069008cca66f12b38b086368a570209633" => :yosemite
    sha1 "41bec42fb26f343e4edf648bcdcfc6fd9ce89e32" => :mavericks
    sha1 "ea821b25add248b3738cd4da30586a9bc403b5b9" => :mountain_lion
  end

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on :fortran => :optional
  depends_on "lua" => :optional
  depends_on :java  => :optional
  option "with-perl", "Build with perl support"
  option "with-ruby", "Build with ruby support"
  option "without-check", "Disable build-time checking (not recommended)"

  if build.with?("python") ||
     build.with?("python3") ||
     build.with?("perl") ||
     build.with?("ruby") ||
     build.with?("java") ||
     build.with?("lua")
    depends_on "swig" => :build
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-idl
      --disable-python-numpy
      --disable-php
    ]

    args << ((build.with? :fortran) ? "--enable-fortran" : "--disable-fortran")
    args << ((build.with? "perl") ? "--enable-perl" : "--disable-perl")
    args << ((build.with? "lua") ? "--enable-lua" : "--disable-lua")
    args << ((build.with? "ruby") ? "--enable-ruby" : "--disable-ruby")
    args << ((build.with? "java") ? "--enable-java" : "--disable-java")

    if !(build.with?("python") && build.with?("python3"))
      # regular build: either no or one type of python bindings required
      args << ((build.with?("python") || build.with?("python3")) ? "--enable-python" : "--disable-python")
      args << "PYTHON=python3" if build.with? :python3

      system "./configure", *args
      system "make"
      system "make", "check" if build.with? "check"
      system "make", "install"
    else
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
      system "make", "check" if build.with? "check"
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
