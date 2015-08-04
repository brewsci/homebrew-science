class Nlopt < Formula
  desc "A free/open-source library for nonlinear optimization"
  homepage "http://ab-initio.mit.edu/nlopt"
  url "http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz"
  sha256 "8099633de9d71cbc06cd435da993eb424bbcdbded8f803cdaa9fb8c6e09c8e89"
  head "https://github.com/stevengj/nlopt.git"

  bottle do
    cellar :any
    sha256 "071053cd7acd4fbf738a39b9fba6559bb8b039db85de2e61fe2073b2579c25d3" => :yosemite
    sha256 "2242e6cde091f4526e468944ca1f0c2e2bec28c6b9e085e44211a84e5c4f5bda" => :mavericks
    sha256 "dd9b46ccbc0f63c373c299e2e8e71f33335452e594a0bbab792eb60c06389f60" => :mountain_lion
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
