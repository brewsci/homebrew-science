class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "http://data.broadinstitute.org/igv/projects/downloads/igvtools_2.3.91.zip"
  sha256 "328abce867bf9ee2620cc995d94d51dd90cc9e60b2caea1d1032679874b78637"
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
