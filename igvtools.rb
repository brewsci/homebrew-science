class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://www.broadinstitute.org/igv/projects/downloads/igvtools_2.3.81.zip"
  sha256 "c1cec430f4ce465984bf7bc5c76a8c84ae8cade4e40f0a2a81b309ae54ef6d76"
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
