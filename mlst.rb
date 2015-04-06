class Mlst < Formula
  homepage "https://github.com/tseemann/mlst"
  url "https://github.com/tseemann/mlst/archive/1.2.tar.gz"
  sha256 "037e159ed7678713b4d6a141b498435adb13dbd549c4d6d36a92a0738cae84f8"
  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "02b329dcce315d97c8ade3b54b6168d9b769da13f4a46e33776d8d846e2be286" => :yosemite
    sha256 "9a1b2667faf6fa2f27d4874639fc24df0b167e53636bfd70acc378b4258ef18d" => :mavericks
    sha256 "93eb3c08a873d26122960c38c115ee16fec3cbe96032eefdb25a7c5841b33d90" => :mountain_lion
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
