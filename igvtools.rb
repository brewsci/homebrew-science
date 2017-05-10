class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://github.com/igvteam/igv/archive/v2.3.92.tar.gz"
  sha256 "b1e3202df340d7bff25f044c97063b7a33a81f5ca7be0bd4306f80c93349a7ce"
  head "https://github.com/igvteam/igv.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "77dd70196ad319ff2599ee29525d71c447cdaa3debc20be6ed3c6057b3bff439" => :sierra
    sha256 "95bc2e4d1fbb9adaa65944e6a272420b5ce06ea2fa66b9b0ef5d2a30caefb7ad" => :el_capitan
    sha256 "83c1783b599c6b3c55f0b54bfe1fabe68b9f3dfa8f06965d69681a9bef9338ea" => :yosemite
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
