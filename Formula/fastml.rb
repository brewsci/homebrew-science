class Fastml < Formula
  desc "Probabilistic reconstruction of ancestral sequences using ML"
  homepage "https://fastml.tau.ac.il/source.php"
  # doi "10.1093/bioinformatics/18.8.1116"
  # tag "bioinformatics"

  url "https://fastml.tau.ac.il/source/FastML.v3.1.tgz"
  sha256 "16c8631a4186f434f81f5b7e8c1147660e79b025b3c93a6db9889c30477bd5f4"
  revision 1

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, el_capitan:   "39ad42b65eef737cbc91fe10dd50db050302d2ea100126d89e0cc2dcd720f11c"
    sha256 cellar: :any_skip_relocation, yosemite:     "45a87496b60c6812361ed76713250730302232cd2c0a0640699401f980777a77"
    sha256 cellar: :any_skip_relocation, mavericks:    "14a84be3f80228146106798f9265f7edc494cf1ad7b69baa41c1598f1034c35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e52c1906263bae1c4af89f1b4b69ca97d1728343dbac5485e593eed221b6b139"
  end

  def install
    # Rename bundled version of getopt to avoid conflicts with gcc version
    inreplace "libs/phylogeny/phylogeny.vcxproj", "getopt", "fastml_getopt"
    inreplace "libs/phylogeny/phylogeny.vcproj", "getopt", "fastml_getopt"
    mv "libs/phylogeny/getopt.h", "libs/phylogeny/fastml_getopt.h"
    mv "libs/phylogeny/getopt.c", "libs/phylogeny/fastml_getopt.c"
    mv "libs/phylogeny/getopt1.c", "libs/phylogeny/fastml_getopt1.c"

    mkdir "bin"
    system "make", "install"
    bin.install Dir["bin/*"]
    doc.install "README"
  end

  test do
    assert_match "Jukes", shell_output("fastml 2>&1")
    assert_match "Phyletic", shell_output("gainLoss 2>&1")
    assert_match "logValue", shell_output("indelCoder 2>&1")
  end
end
