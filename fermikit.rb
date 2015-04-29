class Fermikit < Formula
  homepage "https://github.com/lh3/fermikit"
  # doi "arXiv:1504.06574"
  # tag "bioinformatics"

  url "https://github.com/lh3/fermikit/releases/download/v0.12/fermikit-0.12.tar.bz2"
  sha256 "7d0f3d5ff6e790defc32b1f529dcd33b0c6f6a6d7223b8866542e7cebecfc125"

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
