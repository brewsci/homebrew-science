class Bowtie < Formula
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  # doi "10.1186/gb-2009-10-3-r25"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie/archive/v1.2.0.tar.gz"
  sha256 "dc4e7951b8eca56ce7714c47fd4e84f72badd5312ee9546c912af1963570f894"
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    cellar :any
    sha256 "73df585d60aaae9619f9e701b482d3415bf5f68d3ba10c88b273f39282d159c7" => :sierra
    sha256 "75f6a82b0dfab633523558a22f976781cfd89c6ea9fa1c7a11f1f749dcf52d00" => :el_capitan
    sha256 "63211bbe99c6dff70eafb3da17e0a169ed90a74db879fa71e43a83741e9a84cf" => :yosemite
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
