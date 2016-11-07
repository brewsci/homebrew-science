class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "http://data.broadinstitute.org/igv/projects/downloads/igvtools_2.3.88.zip"
  sha256 "ff582b775ad8da5e2e3587691f9faad26cd31c24f35a4292950346b54f785c01"
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
