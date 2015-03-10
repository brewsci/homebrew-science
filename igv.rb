class Igv < Formula
  homepage "http://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  head "https://github.com/broadinstitute/IGV.git"
  url "http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.43.zip"
  sha256 "4420140f5301413fba73b00e954f81a2733f2d42e12b99aa9a3f73c3b01e49e1"

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
