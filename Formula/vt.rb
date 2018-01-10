class Vt < Formula
  desc "Toolset for short variant discovery from NGS data"
  homepage "https://genome.sph.umich.edu/wiki/Vt"
  # doi "10.1093/bioinformatics/btv112"
  # tag "bioinformatics"

  url "https://github.com/atks/vt/archive/0.5772.tar.gz"
  sha256 "b147520478a2f7c536524511e48133d0360e88282c7159821813738ccbda97e7"
  head "https://github.com/atks/vt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fdf8b6373ce9a6968b230d11815e30e4355fa81b938d718fec4dec7dbaf21bf" => :el_capitan
    sha256 "c3bcf866e90b6a93f666ceb725ca6891cb23448856c4163e066548f13bf4b50a" => :yosemite
    sha256 "3d2e1bad812a3097a4c515ba7940a7cd09518e0f251e9a806d965e8de759db37" => :mavericks
    sha256 "59764b0c5aed39ec0189da065005d3ba4e89791ed02a8cedcde2fdca85679a6b" => :x86_64_linux
  end

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
