class Cytoscape < Formula
  desc "Network Data Integration, Analysis, and Visualization in a Box"
  homepage "http://www.cytoscape.org/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.2212"
  url "http://chianti.ucsd.edu/cytoscape-3.3.0/cytoscape-3.3.0.tar.gz"
  sha256 "e5270c50d34b344c25f470a0064ab823bf0648c0609e2fb36b8d8fd7e44d95dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fdcaec1aaee9caf8c0b4104f2c2379b94abc2f3efe888678de68c8f78cad16e" => :el_capitan
    sha256 "ff2d644cb0de7032fb164c4bd657137f92a0c6d6dfdf7755b61c551a7751aed5" => :yosemite
    sha256 "aadafb17f1aef90e532d288294558d9c1ba2ea3194ea49776f45128550849213" => :mavericks
  end

  depends_on :java => "1.8"

  def install
    inreplace "cytoscape.sh", "$script_path", prefix
    prefix.install %W[cytoscape.sh gen_vmoptions.sh framework sampleData]
    bin.install_symlink prefix/"cytoscape.sh" => "cytoscape"
  end

  def caveats
    "Make sure you have Java 8 on this machine and set your JAVA_HOME to 8"
  end

  test do
    system "#{bin}/cytoscape", "--version"
  end
end
