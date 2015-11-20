class ClustalW < Formula
  homepage "http://www.clustal.org/clustal2/"
  #tag "bioinformatics"
  #doi "10.1093/nar/22.22.4673"
  url "http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz"
  sha1 "f29784f68585544baa77cbeca6392e533d4cf433"

  bottle do
    cellar :any
    sha256 "ef44d6ac0ab51dd705f7f2d2db063e8fb4f50db62d7b069df5af31be0ea05f0a" => :yosemite
    sha256 "c8f563b09a7d8485d71a4f37305fb33cdb349b4d6a0ac581d874f4be5316f56a" => :mavericks
    sha256 "f4d47e253c85b70a23c4c04610370e8ed038a4e7a8758a2de576ce048a4c076a" => :mountain_lion
  end

  fails_with :clang do
    build 600
    cause "error: implicit instantiation of undefined template"
  end

  fails_with :gcc => "4.2"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/clustalw2 --version 2>&1 |grep CLUSTAL"
  end
end
