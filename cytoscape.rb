class Cytoscape < Formula
  desc "Network Data Integration, Analysis, and Visualization in a Box"
  homepage "http://www.cytoscape.org/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.2212"
  url "http://chianti.ucsd.edu/cytoscape-3.3.0/cytoscape-3.3.0.tar.gz"
  sha256 "e5270c50d34b344c25f470a0064ab823bf0648c0609e2fb36b8d8fd7e44d95dd"

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
