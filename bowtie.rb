class Bowtie < Formula
  desc "Ultrafast memory-efficient short read aligner"
  homepage "http://bowtie-bio.sourceforge.net/index.shtml"
  # doi "10.1186/gb-2009-10-3-r25"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie/archive/v1.1.2.tar.gz"
  sha256 "717145f12d599e9b3672981f5444fbbdb8e02bfde2a80eba577e28baa4125ba7"
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
    system "make", "install", "prefix=#{prefix}"

    doc.install "MANUAL", "NEWS", "TUTORIAL"
    (share/"bowtie").install "scripts", "genomes", "indexes", "reads"

    inreplace share/"bowtie/scripts/test/simple_tests.pl" do |s|
      s.gsub! "$bowtie = \"\"", "$bowtie = \"#{bin}/bowtie\""
      s.gsub! "$bowtie_build = \"\"", "$bowtie_build = \"#{bin}/bowtie-build\""
    end
  end

  test do
    system "perl", share/"bowtie/scripts/test/simple_tests.pl"
  end
end
