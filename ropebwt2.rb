class Ropebwt2 < Formula
  desc "Incremental construction of FM-index for DNA sequences"
  homepage "https://github.com/lh3/ropebwt2"
  url "https://github.com/lh3/ropebwt2/archive/49b280debe54db51d9ca81972a9db76c2f6290f7.tar.gz"
  version "r181"
  sha256 "bcd762ea63d907a52efd573b944ca2d3d1338d1f814ad855124d450916e0d75a"
  head "https://github.com/lh3/ropebwt2.git"
  # doi "10.1093/bioinformatics/btu541"
  # tag "bioinformatics"

  def install
    system "make"
    bin.install "ropebwt2"
    doc.install "README.md", "tex/ropebwt2.tex"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ropebwt2 2>&1", 1)
  end
end
