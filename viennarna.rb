require "formula"

class Viennarna < Formula
  homepage "http://www.tbi.univie.ac.at/~ronny/RNA/"
  url "http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.7.tar.gz"
  sha1 "e2e015d47562e1b1b98ecfaf204c0fe4372e5421"

  option "with-perl", "Build and install Perl interface"

  depends_on :python => :optional
  depends_on :x11

  def install
    ENV['ARCHFLAGS'] = "-arch x86_64"
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--disable-openmp"]
    args << "--without-perl" if build.without? "perl"
    args << "--with-python" if build.with? "python"

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make install"
  end

  test do
    output = `echo CGACGUAGAUGCUAGCUGACUCGAUGC |#{bin}/RNAfold --MEA`
    assert output.include?("-1.90 MEA=22.32")
  end
end
