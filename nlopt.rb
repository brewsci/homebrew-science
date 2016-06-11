class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "http://ab-initio.mit.edu/nlopt"
  url "http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz"
  sha256 "8099633de9d71cbc06cd435da993eb424bbcdbded8f803cdaa9fb8c6e09c8e89"
  revision 1
  head "https://github.com/stevengj/nlopt.git"

  bottle do
    cellar :any
    sha256 "9df03f31fb174e5b5f8f5da6bd86d3e4d3ec251f6cdbb49d8aafaac358e3ae60" => :el_capitan
    sha256 "3ca33af7b8d0901ffd956dd1d2f0e45e2b4d4bb5c9527557209ba333639b9cf6" => :yosemite
    sha256 "e4ef742d0c606323d8bdeb776ddb9c98ba023fb9919de45edb203f64601b9d9b" => :mavericks
  end

  option "with-python", "Build Python bindings (requires NumPy)"

  depends_on :python => "numpy" if build.with? "python"
  depends_on "octave" => :optional

  def install
    ENV.deparallelize
    args = [
      "--prefix=#{prefix}",
      "--with-cxx",
      "--enable-shared",
    ]
    args << "--without-octave" if build.without? "octave"
    args << "--without-python" if build.without? "python"

    if build.with? "octave"
      ENV["OCT_INSTALL_DIR"] = pkgshare/"oct"
      ENV["M_INSTALL_DIR"] = pkgshare/"m"
      ENV["MKOCTFILE"] = "#{Formula["octave"].opt_bin}/mkoctfile"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Create lib links for C programs
    lib.install_symlink lib/"libnlopt_cxx.0.dylib" => lib/"libnlopt.0.dylib"
    lib.install_symlink lib/"libnlopt_cxx.dylib" => lib/"libnlopt.dylib"
    lib.install_symlink lib/"libnlopt_cxx.a" => lib/"libnlopt.a"
  end

  def caveats
    s = ""
    if build.with? "octave"
      s += <<-EOS.undent
      Please add
        #{pkgshare}/oct
      and
        #{pkgshare}/m
      to the Octave path.
      EOS
    end
    if build.with? "python"
      python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
      s += <<-EOS.undent
      Please add
        #{lib}/python#{python_version}/site-packages
      to the Python path.
      EOS
    end
    s
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <stdio.h>
      #include <nlopt.hpp>
      int main()
      {
        printf(\"%d.%d.%d\",nlopt::version_major(),nlopt::version_minor(),nlopt::version_bugfix());
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lnlopt_cxx", "-o", "test"
    assert_equal `./test`.chomp, version.to_s
  end
end
