class Igvtools < Formula
  desc "Utilities for preprocessing data files for IGV"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://github.com/igvteam/igv/archive/v2.3.98.tar.gz"
  sha256 "de22b1e646bd2290757e617377b1c598f419e292d28f049ede958d0f08bffde5"
  head "https://github.com/igvteam/igv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "835505a2ecc16d2e8ab3a9a506838a5e14dfbd6514c0a7426a59da24a76c49c7" => :sierra
    sha256 "fff198a48e915319e721749da1d105acb5860ebe06fe8197a5cf87d502195408" => :el_capitan
    sha256 "1d49e1908b8c9bc055d750c5add930fbed601998e10219924dbdd5354ea6ec91" => :yosemite
    sha256 "5aa41614e41f4008aaad65009def059616b8d8814efb67091528ddb89183e624" => :x86_64_linux
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
