class Igvtools < Formula
  homepage "http://www.broadinstitute.org/software/igv/download"
  # tag "bioinformatics"

  url "http://www.broadinstitute.org/igv/projects/downloads/igvtools_2.3.40.zip"
  sha1 "0e9eeba7de3fa400d69bf224be84a4a257395aaf"

  def install
    java = share/"java"
    java.install "igvtools.jar"
    bin.write_jar_script java/"igvtools.jar", "igvtools"
    doc.install "igvtools_readme.txt"
    share.install "genomes"
  end

  test do
    system "#{bin}/igvtools |grep igvtools"
  end
end
