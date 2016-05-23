class Genewise < Formula
  desc "Aligns proteins or protein HMMs to DNA"
  homepage "http://www.ebi.ac.uk/~birney/wise2/"
  # doi "10.1101/gr.1865504"
  # tag "bioinformatics"
  url "http://www.ebi.ac.uk/~birney/wise2/wise2.4.1.tar.gz"
  sha256 "240e2b12d6cd899040e2efbcb85b0d3c10245c255f3d07c1db45d0af5a4d5fa1"
  revision 1

  bottle do
    cellar :any
    sha256 "31c4c2cb325cfe706eb76fbfcf3c53b57fcfd9b8518696fb800792ff9f921f31" => :el_capitan
    sha256 "9c5aac77e7234681824d9e7f809282ceb48329ac281539173221b916e01c4700" => :yosemite
    sha256 "cc4083e3eeb3ce76dabd68c695f119f2dfa18035211c8bf1a1707c8acebe32d2" => :mavericks
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

    cd("src") { system "make", "all" }
    bin.install Dir["src/bin/*"]
    doc.install %w[INSTALL LICENSE README], *Dir["docs/*"]
    pkgshare.install Dir["wisecfg/*"]
    bin.env_script_all_files libexec, "WISECONFIGDIR" => pkgshare
  end

  test do
    assert_match "Version", shell_output("#{bin}/genewise -version", 63)
  end
end
