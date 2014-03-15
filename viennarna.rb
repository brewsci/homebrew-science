require "formula"

class Viennarna < Formula
  homepage "http://www.tbi.univie.ac.at/~ronny/RNA/"
  url "http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.6.tar.gz"
  sha1 "04fd80cf659547959b9b90f59e04f9734e5e43ce"

  option "with-perl", "Build and install Perl interface"

  def install
    ENV['ARCHFLAGS'] = "-arch x86_64"
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--disable-openmp"]
    args << "--without-perl" if build.without? "perl"

    system "./configure", *args
    system "make install"
  end

  test do
    output = `echo CGACGUAGAUGCUAGCUGACUCGAUGC |#{bin}/RNAfold --MEA`
    assert output.include?("-1.90 MEA=22.32")
  end
end
