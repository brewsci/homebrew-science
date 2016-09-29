class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "http://data.broadinstitute.org/igv/projects/downloads/igvtools_2.3.82.zip"
  sha256 "6dbd62d0f6cd3cea2295d70eb84237a0ac69c2e4b5ac4b343a89b2a5a3f64962"
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
    system bin/"igvtools"
  end
end
