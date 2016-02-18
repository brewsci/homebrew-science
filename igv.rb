class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "http://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  url "http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.68.zip"
  sha256 "763781a5c655d22dd2c07096079ba6eadb73ebde80a9f84ae9cdcea2b4921ee0"
  head "https://github.com/broadinstitute/IGV.git"

  bottle :unneeded

  depends_on :java

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{prefix}"
    prefix.install Dir["igv.sh", "*.jar"]
    bin.install_symlink prefix/"igv.sh" => "igv"
    doc.install "readme.txt"
  end

  test do
    (testpath/"script").write "exit"
    assert_match "IGV", `#{bin}/igv -b script`
  end
end
