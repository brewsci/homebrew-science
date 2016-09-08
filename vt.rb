class Vt < Formula
  desc "Toolset for short variant discovery from NGS data"
  homepage "http://genome.sph.umich.edu/wiki/Vt"
  # doi "10.1093/bioinformatics/btv112"
  # tag "bioinformatics"

  url "https://github.com/atks/vt/archive/0.5772.tar.gz"
  sha256 "b147520478a2f7c536524511e48133d0360e88282c7159821813738ccbda97e7"
  head "https://github.com/atks/vt.git"

  def install
    system "make"
    system "test/test.sh"
    bin.install "vt"
    pkgshare.install "test"
    doc.install "LICENSE", "README.md"
  end

  test do
    assert_match "multi_partition", shell_output("#{bin}/vt 2>&1", 0)
  end
end
