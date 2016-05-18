class Cegma < Formula
  desc "Core eukaryotic genes mapping approach"
  homepage "http://korflab.ucdavis.edu/datasets/cegma/"
  # doi "10.1093/bioinformatics/btm071"
  # tag "bioinformatics"

  url "http://korflab.ucdavis.edu/datasets/cegma/cegma_v2.4.010312.tar.gz"
  sha256 "86bef227a6782dfcbbf8a3cfe354b358e2245096b41491604c47569b83862469"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c240c355f7a289c0753ce19753f14e55f4661904b4c765f5ecc5423f42829810" => :el_capitan
    sha256 "f37f428ab4602f5cdcc503773e5b428dea5c6a4cfebe83998e4567841c937554" => :yosemite
    sha256 "9d1e40881e4f02ee71b7f43e1473efab22a4fc6cb7d150543daa192b30d0cc1b" => :mavericks
  end

  depends_on "blast"
  depends_on "geneid"
  depends_on "genewise"
  depends_on "hmmer"

  def install
    system "make"
    mkdir_p libexec/"bin"
    system "make", "install", "INSTALLDIR=#{libexec/"bin"}"
    (lib/"perl5/site_perl").install Dir["lib/*.pm"]
    libexec.install "data"
    doc.install "README"
    bin.install_symlink "../libexec/bin/cegma"
  end

  def caveats; <<-EOS.undent
    To use CEGMA, set the following environment variables:
      export CEGMA=#{HOMEBREW_PREFIX}/opt/cegma/libexec
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  test do
    system "#{bin}/cegma --help 2>&1 |grep -q cegma"
  end
end
