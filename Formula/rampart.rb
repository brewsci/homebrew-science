class Rampart < Formula
  desc "Configurable de novo assembly pipeline"
  homepage "https://github.com/TGAC/RAMPART"
  # tag "bioinformatics"

  url "https://github.com/TGAC/RAMPART/releases/download/Release-0.12.2/rampart-0.12.2.tar.gz"
  sha256 "0dc1e71c40bc141aebfdf6c93960d119ecb19e64758b157320be29329acb0b9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "75891f2b1b8f591b13876b7f7efed3485d9acf1cf4d40dac60bcdf4fd4ab382c" => :sierra
    sha256 "d4f35d3f07cf0f38d5cb812611b3366803eed0b24e83fbde7cb3201256c03913" => :el_capitan
    sha256 "d4f35d3f07cf0f38d5cb812611b3366803eed0b24e83fbde7cb3201256c03913" => :yosemite
  end

  head do
    url "https://github.com/TGAC/RAMPART.git", :branch => "develop"
    depends_on "maven" => :build
  end

  depends_on :java => "1.7+"

  # Dataset improvement
  depends_on "sickle" => :optional
  # quake (see below)

  # Kmer optimisation
  depends_on "kmergenie" => :recommended

  # Assemblers
  depends_on "abyss" => :recommended
  depends_on "allpaths-lg" => :optional
  depends_on "soapdenovo" => :optional
  depends_on "velvet" => :recommended
  depends_on "spades" => :optional

  # Assembly improvement
  # No formula: depends_on "sspace" => :recommended
  # SOAP scaffolder and gap closer
  # Platanus scaffolder and gap closer
  depends_on "reapr" => :optional

  # Assembly analysis
  depends_on "cegma" => :optional
  depends_on "kat" => :recommended

  depends_on "quake" => :optional
  depends_on "quast" => :optional

  def install
    if build.head?
      system "mvn", "clean", "install"
    else
      man1.install "man/rampart.1"
      prefix.install Dir["*"]
    end
  end

  test do
    system "#{bin}/rampart", "--version"
  end
end
