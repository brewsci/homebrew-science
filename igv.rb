class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.2.zip"
  sha256 "d4ba59f9ffd0052d0327ac01fca28b44bb8506ecd504a64783f045c2e7f913a7"
  head "https://github.com/broadinstitute/IGV.git"

  bottle :unneeded

  depends_on :java

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{prefix}"
    prefix.install "igv.sh", Dir["*.jar"]
    bin.install_symlink prefix/"igv.sh" => "igv"
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}/java_cache"
    (testpath/"script").write "exit"
    # This command returns 0 on Circle and Travis but 1 on BrewTestBot.
    assert_match "Version", `#{bin}/igv -b script`
  end
end
