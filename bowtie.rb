class Bowtie < Formula
  desc "Ultrafast memory-efficient short read aligner"
  homepage "http://bowtie-bio.sourceforge.net/index.shtml"
  # doi "10.1186/gb-2009-10-3-r25"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie/archive/v1.1.2.tar.gz"
  sha256 "717145f12d599e9b3672981f5444fbbdb8e02bfde2a80eba577e28baa4125ba7"
  revision 1
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ca85697662a314603274a984ae8b407216f89de01c0b6b95103ab8ba923c904" => :el_capitan
    sha256 "3a0c43fe5cd607245ebee54771d404c0ca61b3145ba3c658e4644ed752bd585f" => :yosemite
    sha256 "d631a95fc614fcddf0c3b6ed940e773e19038156cce4d886f60349c20f980b31" => :mavericks
    sha256 "daa8a6c051d309add874342e2358c3427db7c21915eb9b7e204a829a08f9d527" => :x86_64_linux
  end

  # Upstream PR that fixes stdout when building with clang on OS X. gcc
  # doesn't need the patch, but it seems to do no harm. Resolves test
  # failure for both this formula and Trinity.
  patch do
    url "https://github.com/BenLangmead/bowtie/pull/25.patch"
    sha256 "8c92549b7fde12ca2493f3454fb6a1df0c42b5a9eb2dbcf24418ac04fc5125d4"
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    doc.install "MANUAL", "NEWS", "TUTORIAL"
    pkgshare.install "scripts", "genomes", "indexes", "reads"

    inreplace pkgshare/"scripts/test/simple_tests.pl" do |s|
      s.gsub! "$bowtie = \"\"", "$bowtie = \"#{bin}/bowtie\""
      s.gsub! "$bowtie_build = \"\"", "$bowtie_build = \"#{bin}/bowtie-build\""
    end
  end

  test do
    system "perl", pkgshare/"scripts/test/simple_tests.pl"
  end
end
