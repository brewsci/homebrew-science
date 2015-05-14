class Genewise < Formula
  homepage "http://www.ebi.ac.uk/~birney/wise2/"
  # doi "10.1101/gr.1865504"
  # tag "bioinformatics"
  url "http://www.ebi.ac.uk/~birney/wise2/wise2.4.1.tar.gz"
  sha256 "240e2b12d6cd899040e2efbcb85b0d3c10245c255f3d07c1db45d0af5a4d5fa1"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "72bb8ed394cc810e66f2b2084ffbe90675a0e543cf1cf87cb1e2e3f40fb07aed" => :yosemite
    sha256 "e60789a737289730fc125edc53d04fa3e5829b9f199a3f59db9903601e2dce98" => :mavericks
    sha256 "03a26e3341062439ce638ace8ce908bd0683dffdd3c5c374a8dab32651f82bde" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    # Use pkg-config glib-2.0 rather than glib-config
    inreplace %w[src/makefile src/corba/makefile
        src/dnaindex/assembly/makefile src/dnaindex/makefile
        src/dynlibsrc/makefile src/models/makefile
        src/network/makefile src/other_programs/makefile
        src/snp/makefile],
      "glib-config", "pkg-config glib-2.0"

    # getline conflicts with stdio
    inreplace "src/HMMer2/sqio.c", "getline", "getline_ReadSeqVars"

    # Fails to build with GCC 4.4 on Linux
    # undefined reference to `isnumber'
    # patch suggested in http://korflab.ucdavis.edu/datasets/cegma/ubuntu_instructions_1.txt
    inreplace "src/models/phasemodel.c", "isnumber", "isdigit"

    system *%w[make -C src all]
    bin.install Dir["src/bin/*"]
    doc.install %w[INSTALL LICENSE README], *Dir["docs/*"]
    share_genewise = share/"genewise"
    share_genewise.install Dir["wisecfg/*"]
    bin.env_script_all_files libexec, "WISECONFIGDIR" => share_genewise
  end

  test do
    assert_match "Version", shell_output("#{bin}/genewise -version", 63)
  end
end
