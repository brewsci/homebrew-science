class Viennarna < Formula
  homepage "http://www.tbi.univie.ac.at/~ronny/RNA/"
  # tag "bioinformatics"
  # doi "10.1186/1748-7188-6-26"

  url "http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.9.tar.gz"
  sha256 "367f6a89ddbf7d326ab9ff7d87e3441774e434e1ef599d3511a4bf92a3b392eb"

  bottle do
    cellar :any
    sha256 "d904e8069d9f78c88509effdcd557b7aabdd3ea98cd545bfe877cedf241b6d6e" => :yosemite
    sha256 "25087b1886e24201b585f09fd7e5acb0291369d5f42ff2bd09bd5e3f39d6fff9" => :mavericks
    sha256 "ca8239c8abe3e8e47ab143e4e49e0ceb435f8316eb8bd0999ee8249dc4cc9aef" => :mountain_lion
    sha256 "36c76d0d280fca64bae4a5424d499830ab46c5362482bb91048a11f0d4c28702" => :x86_64_linux
  end

  option "with-perl", "Build and install Perl interface"

  depends_on :x11
  depends_on "gd"

  def install
    ENV["ARCHFLAGS"] = "-arch i386 -arch x86_64" if build.with? "perl"

    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-python",
    ]
    args << "--disable-openmp" if ENV.compiler == :clang
    args << "--without-perl" if build.without? "perl"

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    output = `echo CGACGUAGAUGCUAGCUGACUCGAUGC |#{bin}/RNAfold --MEA`
    assert output.include?("-1.30 MEA=21.31")
  end
end
