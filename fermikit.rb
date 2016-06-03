class Fermikit < Formula
  desc "Assembly-based variant calling for Illumina reads"
  homepage "https://github.com/lh3/fermikit"
  # doi "10.1093/bioinformatics/btv440"
  # tag "bioinformatics"

  url "https://github.com/lh3/fermikit/releases/download/v0.13/fermikit-0.13.tar.bz2"
  sha256 "067c7b8b5ddcac417f5c95d9138abe3077df9d147d6dc50ae7d4a563ac5ad82f"

  head "https://github.com/lh3/fermikit.git"

  bottle do
    cellar :any
    sha256 "b467bb944e76c9bac1631e99504af33ab246deff71d35f6ebe43b5cf6526f3a2" => :yosemite
    sha256 "13cb6bc58404555edb8141637461336f18c2079ad931e8fe8806f656a7142745" => :mavericks
    sha256 "7e3964a923ed60cd1c44cc8dab675b4bd4d988b5fd8bfd041d2a65ddc10eb33c" => :mountain_lion
    sha256 "1e5597398b9a9d76768ad06ebeba772c4de6522bea7ed143ab56d87080f7770f" => :x86_64_linux
  end

  depends_on "bfc"
  depends_on "bwa"
  depends_on "fermi2"
  depends_on "htsbox"
  depends_on "ropebwt2"
  depends_on "seqtk"
  depends_on "trimadap"

  def install
    system "make"
    prefix.install Dir["fermi.kit/*"]
    bin.install_symlink "../run-calling"
    doc.install "NEWS.md", "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/run-calling 2>&1", 255)
  end
end
