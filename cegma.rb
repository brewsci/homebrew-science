class Cegma < Formula
  homepage "http://korflab.ucdavis.edu/datasets/cegma/"
  # doi "10.1093/bioinformatics/btm071"
  # tag "bioinformatics"

  url "http://korflab.ucdavis.edu/datasets/cegma/cegma_v2.4.010312.tar.gz"
  sha256 "86bef227a6782dfcbbf8a3cfe354b358e2245096b41491604c47569b83862469"

  bottle do
    cellar :any
    sha256 "0c1431e39f96a6a1f4cd087ba7b26a23abbbf0555012fb76315203d9b49ed848" => :yosemite
    sha256 "b7d51836f95651b7a4a03a64783380fa0270fb0f6bdf031f42c0d5079ef42077" => :mavericks
    sha256 "6d0645051b1c7fa543c324bb948ee4cbff3d5300c42d35db16945dc49cfcafde" => :mountain_lion
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
