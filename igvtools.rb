class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://github.com/igvteam/igv/archive/v2.3.94.tar.gz"
  sha256 "a8e26ae166fe8b99747c67b74254a209f2fdc2f56101af8e688eb451cf3fc455"
  head "https://github.com/igvteam/igv.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "1f00561d8f724970f2ee93f9f0465c8605031487707f2edc38c8c05bb366d26e" => :sierra
    sha256 "2872333528d5886a3144dfac610c21589267aec062a5b2df7dba8dd97a6068ed" => :el_capitan
    sha256 "d53ecc56b82b56526aa33c955c9cfab69dfddc1174a39260474a3d56421e941a" => :yosemite
    sha256 "d7c9d1b0a5269b0614906e6a11c573f977a885b972caf6c71fd16ac127ac33e3" => :x86_64_linux
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
