class Nlopt < Formula
  desc "A free/open-source library for nonlinear optimization"
  homepage "http://ab-initio.mit.edu/nlopt"
  url "http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz"
  sha256 "8099633de9d71cbc06cd435da993eb424bbcdbded8f803cdaa9fb8c6e09c8e89"
  head "https://github.com/stevengj/nlopt.git"

  bottle do
    cellar :any
    revision 1
    sha256 "6fa1e71cd347dadac482360db4daa688803e471ec15a3dc84d2845c94a93cad7" => :yosemite
    sha256 "10db1934619093419bd5f2f318dd7b72ea0055b0faff1cf4336c297ebd94df59" => :mavericks
    sha256 "443e96acf9200cbbfb8e1a6a15c8fee3576515ddd5abe9d8c2d9bff2c38e3d64" => :mountain_lion
  end

  option "with-python", "Build Python bindings (requires NumPy)"

  depends_on :python => "numpy" if build.with? "python"
  depends_on "octave" => :optional

  def install
    ENV.deparallelize
    args = [
      "--prefix=#{prefix}",
      "--with-cxx",
      "--enable-shared"
    ]
    args << "--without-octave" if build.without? "octave"
    args << "--without-python" if build.without? "python"

    if build.with? "octave"
      ENV["OCT_INSTALL_DIR"] = share/"nlopt/oct"
      ENV["M_INSTALL_DIR"] = share/"nlopt/m"
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
        #{share}/nlopt/oct
      and
        #{share}/nlopt/m
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
