class Viennarna < Formula
  desc "Prediction and comparison of RNA secondary structures"
  homepage "https://www.tbi.univie.ac.at/~ronny/RNA/"
  # tag "bioinformatics"
  # doi "10.1186/1748-7188-6-26"

  url "https://www.tbi.univie.ac.at/RNA/packages/source/ViennaRNA-2.4.3.tar.gz"
  sha256 "4cda6e22029b34bb9f5375181562f69e4a780a89ead50fe952891835e9933ac0"

  bottle do
    cellar :any_skip_relocation
    sha256 "602401ba751afaa76dd94b27e66efb678735861463fddf9d99a531c3a45d779b" => :high_sierra
    sha256 "dc9f1dff1b0ed8964681f72f70493e987567627fae1252a24d831882c5562213" => :sierra
    sha256 "1b39e431dd9a4e300cef10258d3c8bb97c77d909a2e2d096e5a9762c3113a5f4" => :el_capitan
    sha256 "f673b0e84bbea0be9fb8ccfc6eb32fa47638c2954a2a7cb5065fbdfc23cbdcc8" => :x86_64_linux
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
