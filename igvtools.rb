class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "http://data.broadinstitute.org/igv/projects/downloads/igvtools_2.3.85.zip"
  sha256 "e74ff649cd2ea2ec1cc3cdbf2ccaf2cfe463808ce108d13e1b3fabf14f42f394"
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
