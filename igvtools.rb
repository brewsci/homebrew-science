class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://github.com/igvteam/igv/archive/v2.3.93.tar.gz"
  sha256 "dc2805e9ed329f1e6ef437012d6f550e10301f6e971a7bf4e37bf6fbd5620b8c"
  head "https://github.com/igvteam/igv.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "843bb2831aeca6bd33618a24b3f617b6c8cfb5c61b5d33913dcd87de0f8255cf" => :sierra
    sha256 "1e08839174d4bd5ec9837c3469d4afd5ff8f68d5a3db9729bfd83d2619cabd41" => :el_capitan
    sha256 "25c7ce95d23874194ffb787cc8569cdc7e12588f83094fde1f54364fbcbdf7c3" => :yosemite
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
