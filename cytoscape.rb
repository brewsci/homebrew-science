class Cytoscape < Formula
  homepage "http://www.cytoscape.org/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.2212"
  url "http://chianti.ucsd.edu/cytoscape-3.2.1/cytoscape-3.2.1.tar.gz"
  sha1 "d49b2da44d6f6330b77450d2899bb5c29b874a58"

  depends_on :java => "1.8"

  def install
    inreplace "cytoscape.sh", "$script_path", prefix
    prefix.install %W[cytoscape.sh gen_vmoptions.sh framework sampleData]
    bin.install_symlink prefix/"cytoscape.sh" => "cytoscape"
  end

  test do
    system "#{bin}/cytoscape", "--version"
  end

  def caveats
    "Make sure you have Java 8 on this machine and set your JAVA_HOME to 8"
  end
end
