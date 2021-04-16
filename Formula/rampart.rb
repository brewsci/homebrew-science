class Rampart < Formula
  desc "Configurable de novo assembly pipeline"
  homepage "https://github.com/TGAC/RAMPART"
  # tag "bioinformatics"

  url "https://github.com/TGAC/RAMPART/releases/download/Release-0.12.2/rampart-0.12.2.tar.gz"
  sha256 "0dc1e71c40bc141aebfdf6c93960d119ecb19e64758b157320be29329acb0b9f"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, sierra:     "75891f2b1b8f591b13876b7f7efed3485d9acf1cf4d40dac60bcdf4fd4ab382c"
    sha256 cellar: :any_skip_relocation, el_capitan: "d4f35d3f07cf0f38d5cb812611b3366803eed0b24e83fbde7cb3201256c03913"
    sha256 cellar: :any_skip_relocation, yosemite:   "d4f35d3f07cf0f38d5cb812611b3366803eed0b24e83fbde7cb3201256c03913"
  end

  head do
    url "https://github.com/TGAC/RAMPART.git", branch: "develop"
    depends_on "maven" => :build
  end

  depends_on "openjdk"

  # Dataset improvement
  depends_on "abyss" => :recommended
  depends_on "kat" => :recommended
  depends_on "kmergenie" => :recommended
  depends_on "velvet" => :recommended
  depends_on "allpaths-lg" => :optional
  depends_on "cegma" => :optional
  depends_on "quake" => :optional
  depends_on "quast" => :optional
  depends_on "reapr" => :optional
  depends_on "sickle" => :optional
  # quake (see below)

  # Kmer optimisation

  # Assemblers
  depends_on "soapdenovo" => :optional
  depends_on "spades" => :optional

  # Assembly improvement
  # No formula: depends_on "sspace" => :recommended
  # SOAP scaffolder and gap closer
  # Platanus scaffolder and gap closer

  # Assembly analysis

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
