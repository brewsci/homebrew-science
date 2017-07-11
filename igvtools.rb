class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://github.com/igvteam/igv/archive/v2.3.97.tar.gz"
  sha256 "2735040b4e6b70f4711e62c952cc615a2dbb0eec6f3ef4efb9616350cc78e951"
  head "https://github.com/igvteam/igv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a395a25dd80489484271d89ca33e33813ee4530bbc30ba555c10ef1d4750fae3" => :sierra
    sha256 "e060e87ce4ebc61a9a4da50097b21dada210d317dc047c9ccd77899610647047" => :el_capitan
    sha256 "78788edbc76b5ac11aa4b42202a4e68e287df575b1664e9e71349b4fe558a228" => :yosemite
    sha256 "04b0f47824ce14364fd15614a8221b13a6b4145aefea2de95158f94c95e7ed71" => :x86_64_linux
  end

  # tag "bioinformatics"

  depends_on "ant" => :build
  depends_on :java

  def install
    system "ant", "-lib", "ant/bcel-5.2.jar", "-buildfile", "scripts/build-tools.xml", "-Dversion=#{version}"
    libexec.install "igvtools-dist/igvtools.jar"
    bin.write_jar_script libexec/"igvtools.jar", "igvtools"
    pkgshare.install "genomes"
  end

  test do
    system bin/"igvtools"
  end
end
