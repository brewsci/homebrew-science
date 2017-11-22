class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.3.zip"
  sha256 "ca6446fc5de5f8bc14035620aeb7e3b362b0d216d6a75444d83a8237b9805c77"
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
