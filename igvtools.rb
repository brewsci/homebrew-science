require "formula"

class Igvtools < Formula
  homepage "http://www.broadinstitute.org/software/igv"
  url "http://www.broadinstitute.org/igv/projects/downloads/igvtools_2.3.31.zip"
  sha1 "32af21b07a762d2c56bcb0af49c3ff90811d1e03"

  def install
    libexec.install Dir["igvtools.jar"]
    bin.write_jar_script libexec/"igvtools.jar", "igvtools"
    doc.install "igvtools_readme.txt"
  end

  test do
    system "igvtools |grep igvtools"
  end
end
