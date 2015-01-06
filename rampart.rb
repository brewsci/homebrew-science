require "formula"

class Rampart < Formula
  homepage "https://github.com/TGAC/RAMPART"
  #tag "bioinformatics"

  head do
    url "https://github.com/TGAC/RAMPART.git", :branch => "develop"
    depends_on "maven" => :build
  end

  url "https://github.com/TGAC/RAMPART/releases/download/Release-0.11.0/rampart-0.11.0.tar.gz"
  sha1 "bfdd0271b37bfb1a308babb1f328bfcbc7cb3841"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "fbb04392b0a279c71e06f3077506062f8c888c57" => :yosemite
    sha1 "84c0684ba916b0ea9858d53da512e7fcf3b6d7ff" => :mavericks
    sha1 "dee76143f82715dfdc2108df6cbda9f51e121bf0" => :mountain_lion
  end

  depends_on :java => "1.7"

  # Dataset improvement
  depends_on "musket" => :optional
  depends_on "sickle" => :optional
  # quake (see below)

  # Kmer optimisation
  depends_on "kmergenie" => :recommended

  # Assemblers
  depends_on "abyss" => :recommended
  depends_on "allpaths-lg" => :optional
  depends_on "platanus" => :optional
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
