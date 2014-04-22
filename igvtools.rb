require "formula"

class Igvtools < Formula
  homepage "http://www.broadinstitute.org/software/igv"
  url "http://www.broadinstitute.org/igv/projects/downloads/igvtools_2.3.32.zip"
  sha1 "7de35e1ac3908174f99a76e1edd2134b5f1f13cf"

  def install
    libexec.install "igvtools.jar"
    bin.write_jar_script libexec/"igvtools.jar", "igvtools"
    doc.install "igvtools_readme.txt"
    share.install "genomes"
  end

  test do
    system "igvtools |grep igvtools"
  end
end
