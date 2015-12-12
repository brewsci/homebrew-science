class ClustalW < Formula
  homepage "http://www.clustal.org/clustal2/"
  # tag "bioinformatics"
  # doi "10.1093/nar/22.22.4673"
  url "http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz"
  sha256 "e052059b87abfd8c9e695c280bfba86a65899138c82abccd5b00478a80f49486"

  bottle do
    cellar :any
    sha256 "ef44d6ac0ab51dd705f7f2d2db063e8fb4f50db62d7b069df5af31be0ea05f0a" => :yosemite
    sha256 "c8f563b09a7d8485d71a4f37305fb33cdb349b4d6a0ac581d874f4be5316f56a" => :mavericks
    sha256 "f4d47e253c85b70a23c4c04610370e8ed038a4e7a8758a2de576ce048a4c076a" => :mountain_lion
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
