require "formula"

class Viennarna < Formula
  homepage "http://www.tbi.univie.ac.at/~ronny/RNA/"
  url "http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.8.tar.gz"
  sha1 "9f26c89043a00fddbac94751cd4450d0a7235fe2"

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
