class Mlst < Formula
  homepage "https://github.com/tseemann/mlst"
  url "https://github.com/tseemann/mlst/archive/1.2.tar.gz"
  sha256 "037e159ed7678713b4d6a141b498435adb13dbd549c4d6d36a92a0738cae84f8"
  bottle do
    cellar :any
    sha256 "4beb855b2de3850fc88323e673c4c3edc0479e66368763cf0fdde461dbea2f38" => :yosemite
    sha256 "08de6200b91384a2913834774d49bc927a6f7247eb6ab3ef1671494e0b113d42" => :mavericks
    sha256 "fb7ea7b027fbe6f06254b5b939dda33915ebfbaf86e2b12b561e29f53837bf80" => :mountain_lion
  end

  # tag "bioinformatics"

  depends_on "blat"
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "senterica", shell_output("mlst --list 2>&1", 0)
  end
end
