class Bowtie < Formula
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  # doi "10.1186/gb-2009-10-3-r25"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie/archive/v1.2.2_p1.tar.gz"
  version "1.2.2_p1"
  sha256 "e1b02b2e77a0d44a3dd411209fa1f44f0c4ee304ef5cc83f098275085740d5a1"
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    cellar :any
    sha256 "155008738bc3c59be80d918507b1277e7b06b7b966bee3245dfdf8555aa1808e" => :high_sierra
    sha256 "04367e76c2fdc64d280218ced4bdb29017f7dab47837919fe1564ae024ab5a7d" => :sierra
    sha256 "9c279b1e99f4a387a142ed832ddf4401cf973ef1dadd65fcd89fa4c5c34ff011" => :el_capitan
    sha256 "90b9283cbf50de2467cb8ca9eba542c1317f15ef67720a232eda1659d9478e94" => :x86_64_linux
  end

  depends_on "tbb"

  # Needed for the test
  resource "Sys::Info" do
    url "https://cpan.metacpan.org/authors/id/B/BU/BURAK/Sys-Info-0.78.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/B/BU/BURAK/Sys-Info-0.78.tar.gz"
    sha256 "93b2d7d2a670ed0dfb2d524a3cb7f446aeaced5cd3aaa91fc18ac7ba016707e0"
  end
  resource "Sys::Info::Base" do
    url "https://cpan.metacpan.org/authors/id/B/BU/BURAK/Sys-Info-Base-0.7804.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/B/BU/BURAK/Sys-Info-Base-0.7804.tar.gz"
    sha256 "96ca63d624aaf658aa6869df61cac11df93353041958a3821ed0ca34b6d4611c"
  end
  if OS.linux?
    resource "Perl::Clone" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.38.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/G/GA/GARU/Clone-0.38.tar.gz"
      sha256 "9fb0534bb7ef6ca1f6cc1dc3f29750d6d424394d14c40efdc77832fad3cebde8"
    end
    resource "Sys::Info::Driver::Linux" do
      url "https://cpan.metacpan.org/authors/id/B/BU/BURAK/Sys-Info-Driver-Linux-0.7903.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/B/BU/BURAK/Sys-Info-Driver-Linux-0.7903.tar.gz"
      sha256 "76507907902ab6ef68651629731da3e2100d10ec2c09d5fcdef0346ad747739c"
    end
    resource "Test::Deep" do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Test-Deep-1.126.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/Test-Deep-1.126.tar.gz"
      sha256 "159b42451e4018d9da97994f4ac46d5166abf9b6f343db30071c8fd1cfe0c7c2"
    end
    resource "Unix::Processors" do
      url "https://cpan.metacpan.org/authors/id/W/WS/WSNYDER/Unix-Processors-2.045.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/W/WS/WSNYDER/Unix-Processors-2.045.tar.gz"
      sha256 "babd860eda5180939265b3f5241f41e677d5da558fac9420a9ed198ddd12a01e"
    end
  end
  if OS.mac?
    resource "Mac::PropertyList" do
      url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Mac-PropertyList-1.41.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/B/BD/BDFOY/Mac-PropertyList-1.41.tar.gz"
      sha256 "db7f1b3a42a615e7b51df6b3a7b1b51b1ba980e22944c3722cb035362ad95757"
    end
    resource "Sys::Info::Driver::OSX" do
      url "https://cpan.metacpan.org/authors/id/B/BU/BURAK/Sys-Info-Driver-OSX-0.7958.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/B/BU/BURAK/Sys-Info-Driver-OSX-0.7958.tar.gz"
      sha256 "875c34cd2f596a83c01ba7572ab98cbe6dd0ccff4a3b9e4192e1c35a2c0f3989"
    end
    resource "XML::Entities" do
      url "https://cpan.metacpan.org/authors/id/S/SI/SIXTEASE/XML-Entities-1.0002.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/S/SI/SIXTEASE/XML-Entities-1.0002.tar.gz"
      sha256 "c32aa4f309573d7648ab2e416f62b6b20652f2ad9cfd3eec82fd51101fe7310d"
    end
  end

  def install
    # Needed for the test
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "LIB=#{libexec}/PerlLib", "PREFIX=#{libexec}/vendor"
        system "make", "install"
      end
    end

    system "make", "install", "prefix=#{prefix}"

    doc.install "MANUAL", "NEWS", "TUTORIAL"
    pkgshare.install "scripts", "genomes", "indexes", "reads"

    inreplace pkgshare/"scripts/test/simple_tests.pl" do |s|
      s.gsub! "$bowtie = \"\"", "$bowtie = \"#{bin}/bowtie\""
      s.gsub! "$bowtie_build = \"\"", "$bowtie_build = \"#{bin}/bowtie-build\""
      s.gsub! "--debug", ""
    end
  end

  test do
    ENV.prepend_path "PERL5LIB", "#{libexec}/PerlLib"
    system "perl", pkgshare/"scripts/test/simple_tests.pl"
  end
end
