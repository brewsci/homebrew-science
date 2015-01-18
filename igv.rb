class Igv < Formula
  homepage "http://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  head "https://github.com/broadinstitute/IGV.git"
  url "http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.40.zip"
  sha1 "5060e7d9de990b83bbf7ceb8103baffb9409c010"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install Dir["igv.sh", "*.jar"]
    bin.install_symlink libexec/"igv.sh" => "igv"
    doc.install "readme.txt"
  end

  test do
    (testpath/"script").write "exit"
    system "igv", "-b", "script", "|grep", "-q", "IGV"
  end
end
