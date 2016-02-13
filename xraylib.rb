class Xraylib < Formula
  homepage "https://github.com/tschoonj/xraylib"
  desc "A library for X-ray-matter interaction fundamental parameters"
  url "http://lvserver.ugent.be/xraylib/xraylib-3.1.0.tar.gz"
  mirror "https://xraylib.s3.amazonaws.com/xraylib-3.1.0.tar.gz"
  sha256 "61a7c7fd0a911562151422bc6ca77df8beba37ec4e337765cf60dfbe1e04a1e3"

  bottle do
    revision 2
    sha256 "363c11159efb91d7e4d0756047d5d7602835ac29eaa9a4ba5356efa1c5ff6a56" => :yosemite
    sha256 "6955f883661c1d1b95cedd856728dd39bdafb76c96a62e36ae98956314d80d0f" => :mavericks
    sha256 "70ff54f9574e1a4bbea115fdae1fe6ec407dfb52338ba9765cd4a45e1e40964b" => :mountain_lion
  end

  option "with-perl", "Build with perl support"
  option "with-ruby", "Build with ruby support"

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on :fortran => :optional
  depends_on "lua" => :optional
  depends_on :java  => :optional

  depends_on "swig" => :build

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-idl
      --disable-python-numpy
      --disable-php
    ]

    args << ((build.with? "fortran") ? "--enable-fortran2003" : "--disable-fortran2003")
    args << ((build.with? "perl") ? "--enable-perl" : "--disable-perl")
    args << ((build.with? "lua") ? "--enable-lua" : "--disable-lua")
    args << ((build.with? "ruby") ? "--enable-ruby" : "--disable-ruby")
    args << ((build.with? "java") ? "--enable-java" : "--disable-java")

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
