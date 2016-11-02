class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "http://data.broadinstitute.org/igv/projects/downloads/igvtools_2.3.86.zip"
  sha256 "89f019776a016a2185de568402ee556ee2dea95de8e3e7c4b92009a665574451"
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
