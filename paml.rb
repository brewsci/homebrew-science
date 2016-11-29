class Paml < Formula
  desc "phylogenetic analysis by maximum likelihood"
  homepage "http://abacus.gene.ucl.ac.uk/software/paml.html"
  url "http://abacus.gene.ucl.ac.uk/software/paml4.9c.tgz"
  version "4.9c"
  sha256 "92009a3138bdddf1c99f4756ded74c33618214450ad5ada497870e210ea141a1"
  # doi "10.1093/molbev/msm088"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "f29be1846d157d969d5acd700273434eb69de5629c8b7c0e6e02baf3c160ee24" => :sierra
    sha256 "1c300304f8a0b12a76dff8e8ccb4a61302e3194bb03f6417cd8c74c4a7d7384e" => :el_capitan
    sha256 "ae0795e757829c10687996d86a6aee83162103bd42b862bf79c6c392d0f93240" => :yosemite
    sha256 "21c8e9bd97d148cea7e6c6617316bfe2c4c33d7cb130488b1a2cfdf58d24ed68" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
      bin.install %w[baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00]
    end

    pkgshare.install "dat"
    pkgshare.install Dir["*.ctl"]
    doc.install Dir["doc/*"]
    doc.install "examples"
  end

  def caveats
    <<-EOS.undent
      Documentation and examples:
        #{HOMEBREW_PREFIX}/share/doc/paml
      Dat and ctl files:
        #{HOMEBREW_PREFIX}/share/paml
    EOS
  end

  test do
    cp Dir[doc/"examples/DatingSoftBound/*"], testpath
    system "#{bin}/infinitesites"
  end
end
