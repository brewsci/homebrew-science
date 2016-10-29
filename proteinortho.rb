class Proteinortho < Formula
  desc "Detection of orthologs in large-scale analysis"
  homepage "http://www.bioinf.uni-leipzig.de/Software/proteinortho/"
  # doi "10.1186/1471-2105-12-124"
  # tag "bioinformatics"

  url "http://www.bioinf.uni-leipzig.de/Software/proteinortho/proteinortho_v5.15_src.tar.gz"
  version "5.15"
  sha256 "718af74289a4fc0075f9dce2b12fe3fa1c7d96718c7ec8d9ddca94beac658a17"

  bottle do
    cellar :any_skip_relocation
    sha256 "90278cd36c92e1f2470ddfbe67310b8af11146c5e1e7c2c0963fca6563cb57f2" => :el_capitan
    sha256 "310de812c9d5d37bb4b368e737b83bbdd7fafc025bd4acfce167d4cb14c05203" => :yosemite
    sha256 "faf9b72151379cd25d4cbe40d4164da161d832e3ab07ea58b937ad331b7ab893" => :mavericks
    sha256 "5c1f6ae44c11d636f5f6dbb5d53058f2f3a3d9eff87700e8f422e965373c902e" => :x86_64_linux
  end

  depends_on "blast"
  depends_on "Thread::Queue" => :perl
  depends_on "File::Basename" => :perl

  def install
    system "make"
    mkdir bin
    system "make", "INSTALLDIR=#{bin}", "install"
    doc.install "manual.html"
    pkgshare.install "tools", "test"
  end

  test do
    assert_match "orthology", shell_output("#{bin}/proteinortho5.pl 2>&1", 0)
  end
end
