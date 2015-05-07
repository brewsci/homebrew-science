class Igv < Formula
  homepage "http://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  head "https://github.com/broadinstitute/IGV.git"
  url "http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.52.zip"
  sha256 "b0bef5e92372c80e2d42f58e2e75d5fd736cc4fcb27caf13a85b8f09180bbb41"

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
