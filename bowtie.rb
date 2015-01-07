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
    sha1 "5e9096677965518ccb46fcf48c66ad62a0ffa332" => :yosemite
    sha1 "5fc6017e187384f1176fb5e552c18dd11e69cd14" => :mavericks
    sha1 "2e24d251f882a2b4212578169e8f69f6ee913a4a" => :mountain_lion
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
