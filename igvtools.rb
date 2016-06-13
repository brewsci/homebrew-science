class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "http://www.broadinstitute.org/software/igv/download"
  url "http://www.broadinstitute.org/igv/projects/downloads/igvtools_2.3.48.zip"
  sha256 "0ae8fc2f6500495ae84aa0232887d9466c73c188f5af91d64a089e5808d3a84d"
  # tag "bioinformatics"

  bottle :unneeded

  def install
    java = share/"java"
    java.install "igvtools.jar"
    bin.write_jar_script java/"igvtools.jar", "igvtools"
    doc.install "igvtools_readme.txt"
    pkgshare.install "genomes"
  end

  test do
    system "#{bin}/igvtools |grep igvtools"
  end
end
