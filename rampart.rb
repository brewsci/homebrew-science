require "formula"

class Rampart < Formula
  homepage "https://github.com/TGAC/RAMPART"

  head do
    url "https://github.com/TGAC/RAMPART.git"
    depends_on "maven" => :build
  end

  url "https://github.com/TGAC/RAMPART/releases/download/Release-0.9.0/rampart-0.9.0.tar.gz"
  sha1 "b9a4e4ff59f92087f826230750ab94e3f7ffbbc9"

  depends_on :java => "1.7"

  # Dataset improvement
  depends_on "musket" => :recommended
  depends_on "quake" => :recommended
  depends_on "sickle" => :recommended

  # Assemblers
  depends_on "abyss" => :recommended
  depends_on "allpaths-lg" => :recommended
  depends_on "platanus" => :recommended
  depends_on "soapdenovo" => :recommended
  depends_on "velvet" => :recommended

  # Assembly improvement
  depends_on "sspace" => :recommended
  # SOAP scaffolder and gap closer
  # Platanus scaffolder and gap closer

  # Assembly analysis
  depends_on "cegma" => :recommended
  depends_on "kat" => :recommended
  depends_on "quast" => :recommended

  def install
    if build.head?
      system "mvn", "clean", "install"
    else
      man1.install "man/rampart.1"
      prefix.install Dir["*"]
    end
  end

  test do
    system "#{bin}/rampart --version"
  end
end
