class Bowtie < Formula
  homepage "http://bowtie-bio.sourceforge.net/index.shtml"
  # doi "10.1186/gb-2009-10-3-r25"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie/archive/v1.1.1.tar.gz"
  sha1 "297b0c56d3847a8cc11a4c03917c03bd6080d365"
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 1
    sha1 "4400eb29ef8dde38e5c8c31dafdeafa4cfb35f8a" => :yosemite
    sha1 "b59b81a427edb0ff21989604e853192330256e6e" => :mavericks
    sha1 "e837e00af306a2aa1c71e5c40394c79ebfddb6d6" => :mountain_lion
  end

  def install
    ENV.libstdcxx
    system "make", "allall"

    # preserve directory structure for tests/scripts
    libexec.install Dir["bowtie*"]
    libexec.install %w[scripts genomes indexes reads]
    bin.install_symlink %W[
      #{libexec}/bowtie
      #{libexec}/bowtie-build
      #{libexec}/bowtie-inspect
    ]
    doc.install %w[AUTHORS LICENSE MANUAL MANUAL.markdown NEWS TUTORIAL]

    inreplace libexec/"scripts/test/simple_tests.pl" do |s|
      s.gsub! "$bowtie = \"\"", "$bowtie = \"#{bin}/bowtie\""
      s.gsub! "$bowtie_build = \"\"", "$bowtie_build = \"#{bin}/bowtie-build\""
    end
  end

  test do
    system "perl", "#{libexec}/scripts/test/simple_tests.pl"
  end
end
