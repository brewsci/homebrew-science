class Bowtie < Formula
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  # doi "10.1186/gb-2009-10-3-r25"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie/archive/v1.2.0.tar.gz"
  sha256 "dc4e7951b8eca56ce7714c47fd4e84f72badd5312ee9546c912af1963570f894"
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ca85697662a314603274a984ae8b407216f89de01c0b6b95103ab8ba923c904" => :el_capitan
    sha256 "3a0c43fe5cd607245ebee54771d404c0ca61b3145ba3c658e4644ed752bd585f" => :yosemite
    sha256 "d631a95fc614fcddf0c3b6ed940e773e19038156cce4d886f60349c20f980b31" => :mavericks
    sha256 "daa8a6c051d309add874342e2358c3427db7c21915eb9b7e204a829a08f9d527" => :x86_64_linux
  end

  depends_on "tbb"

  if OS.linux?
    # Needed for the test
    resource "Perl::Clone" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.38.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/G/GA/GARU/Clone-0.38.tar.gz"
      sha256 "9fb0534bb7ef6ca1f6cc1dc3f29750d6d424394d14c40efdc77832fad3cebde8"
    end
    resource "Test::Deep" do
      url "https://cpan.metacpna.org/authors/id/R/RJ/RJBS/Test-Deep-1.126.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/Test-Deep-1.126.tar.gz"
      sha256 "159b42451e4018d9da97994f4ac46d5166abf9b6f343db30071c8fd1cfe0c7c2"
    end
  end

  def install
    if OS.linux?
      # Needed for the test
      resource("Perl::Clone").stage do
        system "perl", "Makefile.PL", "LIB=#{libexec}/PerlLib", "PREFIX=#{libexec}/vendor"
        system "make", "install"
      end
      resource("Test::Deep").stage do
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
    ENV.prepend_path "PERL5LIB", "#{libexec}/PerlLib" unless OS.mac?
    system "perl", pkgshare/"scripts/test/simple_tests.pl"
  end
end
