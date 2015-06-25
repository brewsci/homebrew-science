class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "http://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  url "http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.57.zip"
  sha256 "88950118fee35d6ecd71708bb4ec272519ca632f8778f4cbce677487ce28ba39"
  head "https://github.com/broadinstitute/IGV.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "e1f244ca417e6bb05f395eb8c0c02ac7b3e15afd5e30aa8f702af4a8e5c51841" => :yosemite
    sha256 "6dd6238c4ccf6100e676dbca9d7577662784a5ed9f21c57f272b52fe8d6feb50" => :mavericks
    sha256 "373652f5ace3c2a936036edb92b464172f25c17be244b04fb951065c4e5813dc" => :mountain_lion
  end

  depends_on :java

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install Dir["igv.sh", "*.jar"]
    bin.install_symlink libexec/"igv.sh" => "igv"
    doc.install "readme.txt"
  end

  test do
    (testpath/"script").write "exit"
    assert_match "IGV", `#{bin}/igv -b script`
  end
end
