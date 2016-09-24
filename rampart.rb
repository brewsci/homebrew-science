class Rampart < Formula
  homepage "https://github.com/TGAC/RAMPART"
  # tag "bioinformatics"

  head do
    url "https://github.com/TGAC/RAMPART.git", :branch => "develop"
    depends_on "maven" => :build
  end

  url "https://github.com/TGAC/RAMPART/releases/download/Release-0.11.0/rampart-0.11.0.tar.gz"
  sha256 "f4e87ef410793906dc42df43f60ba9246ea68dee12c6bcaf30ca5a05f5a3a3fe"

  bottle do
    cellar :any
    sha256 "654066a36c0df63e9955f7a105cac906cbbe78d55bc3f3e4de46b6bec29171c3" => :yosemite
    sha256 "b694c65ccac7ff4aed57d2e4823150d08acf9db6fbc51e24ca559b671462a21d" => :mavericks
    sha256 "810d7b76559426a412b7ab83f270475f26eef4cf652b6b17716291e6d5b2d7ca" => :mountain_lion
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
  # quast (see below)

  # Quast and quake are now optional on mountain lion but recommended on
  # all other platforms.  For Quast, this is because mountian lion does not
  # seem to have matplotlib installed by default, which is a key dependency.
  # For Quake, it has a dependency on jellyfish2, which doesn't seem to be
  # configured correctly to use the right compiler (C++) at this point in
  # time (4th Dec 2014).  We may remove this check in the future.
  if OS.mac? && MacOS.version <= :mountain_lion
    depends_on "quake" => :optional
    depends_on "quast" => :optional
  else
    depends_on "quake" => :recommended
    depends_on "quast" => :recommended
  end

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
