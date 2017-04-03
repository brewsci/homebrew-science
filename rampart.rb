class Rampart < Formula
  desc "Configurable de novo assembly pipeline"
  homepage "https://github.com/TGAC/RAMPART"
  # tag "bioinformatics"

  url "https://github.com/TGAC/RAMPART/releases/download/Release-0.12.2/rampart-0.12.2.tar.gz"
  sha256 "0dc1e71c40bc141aebfdf6c93960d119ecb19e64758b157320be29329acb0b9f"

  bottle do
    cellar :any
    sha256 "654066a36c0df63e9955f7a105cac906cbbe78d55bc3f3e4de46b6bec29171c3" => :yosemite
    sha256 "b694c65ccac7ff4aed57d2e4823150d08acf9db6fbc51e24ca559b671462a21d" => :mavericks
    sha256 "810d7b76559426a412b7ab83f270475f26eef4cf652b6b17716291e6d5b2d7ca" => :mountain_lion
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
