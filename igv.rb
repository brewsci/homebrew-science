class Igv < Formula
  homepage "http://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  head "https://github.com/broadinstitute/IGV.git"
  url "http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.41.zip"
  sha256 "dc99f90509568c1085371e477e3b2a7a917c42156086c794677cd3f26a29dff3"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install Dir["igv.sh", "*.jar"]
    bin.install_symlink libexec/"igv.sh" => "igv"
    doc.install "readme.txt"
  end

  test do
    (testpath/"script").write "exit"
    assert_match "IGV", shell_output("igv -b script")
  end
end
