class Sailfish < Formula
  desc "Rapid mapping-based RNA-Seq isoform quantification"
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish"
  # doi "10.1038/nbt.2862"
  # tag "bioinformatics"
  url "https://github.com/kingsfordgroup/sailfish/archive/v0.10.1.tar.gz"
  sha256 "a0d6d944382f2e07ffbfd0371132588e2f22bb846ecfc3d3435ff3d81b30d6c6"
  revision 1

  bottle do
    sha256 "16e1cce6665ec8c6587f31e7fdf94bd5d0da0f21392efafd6b6d6464f344284d" => :el_capitan
    sha256 "62c8f97b957c13e3f9d97b58cd8363c651c4b6a43a9c94710b6ca95900a5ae55" => :yosemite
    sha256 "16906591aea875161ae8dfeaeeb84f71653c422470e2e68f8ccf9d235344d9a2" => :mavericks
    sha256 "e6b53b6c2f593384c1f0fea66e10dd386d9145ddf3e6ed34e616e03213f8d74a" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "tbb"
  needs :cxx11

  def install
    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sailfish", "--version"
  end
end
