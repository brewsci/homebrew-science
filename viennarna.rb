require "formula"

class Viennarna < Formula
  homepage "http://www.tbi.univie.ac.at/~ronny/RNA/"
  #tag "bioinformatics"
  #doi "10.1186/1748-7188-6-26"

  url "http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.8.tar.gz"
  sha1 "9f26c89043a00fddbac94751cd4450d0a7235fe2"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "0b8cc67011e8070f27d6e4bede85c259ac9f2add" => :yosemite
    sha1 "e3f1c752a9dd85be264944c9e3a048d3e87a519b" => :mavericks
    sha1 "b449ec9a67b872f89b868f1b51ba817dad0c3c6d" => :mountain_lion
  end

  option "with-perl", "Build and install Perl interface"

  depends_on :python => :optional
  depends_on :x11

  def install
    ENV["ARCHFLAGS"] = "-arch x86_64"
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
