class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "http://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  url "http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.80.zip"
  sha256 "f95368bb5c359b28786e8cf2d9c44240f44ad5bad7cd41ba8ae22c3608213535"
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
    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}/java_cache"
    (testpath/"script").write "exit"
    # This command returns 0 on Circle and Travis but 1 on BrewTestBot.
    assert_match "Version", `#{bin}/igv -b script`
  end
end
