class Viennarna < Formula
  desc "Prediction and comparison of RNA secondary structures"
  homepage "http://www.tbi.univie.ac.at/~ronny/RNA/"
  # tag "bioinformatics"
  # doi "10.1186/1748-7188-6-26"

  url "http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.9.tar.gz"
  sha256 "367f6a89ddbf7d326ab9ff7d87e3441774e434e1ef599d3511a4bf92a3b392eb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "379ce1c1c5cc034df6284c1643a151eba16f11305cd441341d2da61ce65a52ce" => :sierra
    sha256 "79877f0084806c38e46488a0330086e3011587ba1fded8b0f4844c6cf1d6bd85" => :el_capitan
    sha256 "0a2340ab9b86cfecbe7baeee8cccbd5188ab9f9e62cfd25e8e6f7e64269e95f1" => :yosemite
  end

  option "with-openmp", "Enable OpenMP multithreading"
  option "with-perl", "Build and install Perl interface"

  depends_on :x11
  depends_on "gd"

  needs :openmp if build.with? "openmp"

  def install
    ENV["ARCHFLAGS"] = "-arch i386 -arch x86_64" if build.with? "perl"

    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-python",
    ]
    args << "--disable-openmp" if build.without? "openmp"
    args << "--without-perl" if build.without? "perl"

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    output = `echo CGACGUAGAUGCUAGCUGACUCGAUGC |#{bin}/RNAfold --MEA`
    assert_match "-1.30 MEA=21.31", output
  end
end
