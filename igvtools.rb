class Igvtools < Formula
  homepage "http://www.broadinstitute.org/software/igv/download"
  # tag "bioinformatics"

  url "http://www.broadinstitute.org/igv/projects/downloads/igvtools_2.3.48.zip"
  sha256 "0ae8fc2f6500495ae84aa0232887d9466c73c188f5af91d64a089e5808d3a84d"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "8f569e86b130e851e9f6389af18cdf6597fd1486" => :yosemite
    sha1 "6304d3bc4d32528f2ddb1e9c92adb6001f139559" => :mavericks
    sha1 "b976141a7fd94e25f97c463f3d53885c7bd2ee05" => :mountain_lion
  end

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
