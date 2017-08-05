class Cegma < Formula
  desc "Core eukaryotic genes mapping approach"
  homepage "http://korflab.ucdavis.edu/datasets/cegma/"
  # doi "10.1093/bioinformatics/btm071"
  # tag "bioinformatics"

  url "http://korflab.ucdavis.edu/datasets/cegma/CEGMA_v2.5.tar.gz"
  sha256 "dd7381c0402622645404ea009c66e54f7c915d8b80a16e02b8e17ccdc1859e76"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0953276f654ad3f2696fd7ddb3c33fa6a61d6765b4b6ac4aae694618fb9a32b" => :el_capitan
    sha256 "48c10c321a8868e69dd06bef16e48c41d5db331fd2ea460866d3a04770a56259" => :yosemite
    sha256 "2a827211542d44535a0b1525474e3cee46b950bc12c5f82932e4b84b0384e58f" => :mavericks
    sha256 "8b558845f19d3b2c6c79cf8cf69226bbb5934701d92b05d7952090d46a31ba1b" => :x86_64_linux
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
    bin.install_symlink "../libexec/bin/cegma"
    prefix.install "release_notes.md"
  end

  def caveats; <<-EOS.undent
    To use CEGMA, set the following environment variables:
      export CEGMA=#{HOMEBREW_PREFIX}/opt/cegma/libexec
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  test do
    ENV.prepend_path "PERL5LIB", lib/"perl5/site_perl"
    assert_match version.to_s, shell_output("#{bin}/cegma --help", 1)
  end
end
