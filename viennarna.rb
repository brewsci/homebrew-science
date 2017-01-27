class Viennarna < Formula
  desc "Prediction and comparison of RNA secondary structures"
  homepage "http://www.tbi.univie.ac.at/~ronny/RNA/"
  # tag "bioinformatics"
  # doi "10.1186/1748-7188-6-26"

  url "http://www.tbi.univie.ac.at/RNA/packages/source/ViennaRNA-2.3.3.tar.gz"
  sha256 "cf92c05e54dff32c2135433b6ebaa5330c05de02a1ae8b7c3b7a865d42eea514"

  bottle do
    cellar :any_skip_relocation
    sha256 "2828a32c707dc311947d32755a609a4f2bc7c6de0254d43b94c7538944e1ce69" => :sierra
    sha256 "b95b4f52ce14c9c4437b8305d3c8b08e2def4c822c33381953c8e79b81cdf67c" => :el_capitan
    sha256 "71e2108defc57d61435957b55ef0c4a3a533c39b86fdc7f17c81ba013567090f" => :yosemite
    sha256 "2b44a6a50b8223645bb64920ae47ee3c60b26b9b46a1ac08e69cfc7c1d2b291b" => :x86_64_linux
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
