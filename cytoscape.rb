class Cytoscape < Formula
  desc "Network Data Integration, Analysis, and Visualization in a Box"
  homepage "http://www.cytoscape.org/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.2212"
  url "http://chianti.ucsd.edu/cytoscape-3.4.0/cytoscape-3.4.0.tar.gz"
  sha256 "e20a04b031818005090bd65b78bb08813b7a8e018c73496d41f2f00014d6ae18"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4f0f0ebf76fe4f58ef1b518d94424164bc9ed232584d3746eb9716687631890" => :el_capitan
    sha256 "5ea6565946d7ac7f947dbcda8a31852914d43d28caf180c103a76de75f1503d2" => :yosemite
    sha256 "f81ef71f76b8525d661b3e151ed0eca1dd813de12cb88854caabd060adca3dae" => :mavericks
    sha256 "3f401c5d124c644ae3c2993ec867d782cadc108e3b71769f0b5cdac3a3cfa20d" => :x86_64_linux
  end

  depends_on :java => "1.8"

  def install
    inreplace "cytoscape.sh", "$script_path", prefix
    prefix.install %W[cytoscape.sh apps gen_vmoptions.sh framework sampleData]
    bin.install_symlink prefix/"cytoscape.sh" => "cytoscape"
  end

  def caveats
    "Make sure you have Java 8 on this machine and set your JAVA_HOME to 8"
  end

  test do
    system "#{bin}/cytoscape", "--version"
  end
end
