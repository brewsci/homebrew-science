class ClustalW < Formula
  homepage "http://www.clustal.org/clustal2/"
  # tag "bioinformatics"
  # doi "10.1093/nar/22.22.4673"
  url "http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz"
  sha256 "e052059b87abfd8c9e695c280bfba86a65899138c82abccd5b00478a80f49486"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "476d0596f089217ba1b23c12f69e34ac5127405cf757033cdcede523ce79608c" => :el_capitan
    sha256 "14c64492275401c1a62d54edb1e75e6e8367fd854706e8776e175aa055f9bf08" => :yosemite
    sha256 "15abc50c36d8f6edf502e7656cdec0dff2765c811baeb1dc3a8a149e6e3e9837" => :mavericks
    sha256 "a394f0dbadf2cb08f0cae76c475c3aaaf11edac6e4c3c0b41e1fb6d7ff999251" => :x86_64_linux
  end

  def install
    # header is missing #include <string>
    # reported to clustalw@ucd.ie Dec 11 2015
    inreplace "src/general/VectorOutOfRange.h",
      "#include <exception>",
      "#include <exception>\n#include<string>"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/clustalw2 --version 2>&1 |grep CLUSTAL"
  end
end
