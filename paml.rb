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
    sha256 "c5b4ef918aa14cea7ec3229e3ea6fd1c2532d0e54942e6dcbb848a383af8484b" => :el_capitan
    sha256 "a4fadee3d6a50cc7f397dffc9df49bea091c3c5d2ced50166213d788a3551a1e" => :yosemite
    sha256 "8940747b21e50aa40549583a5e2490b5060268506a21d296f66f157ecf2d2b60" => :mavericks
    sha256 "8b1a2c4464a185946b9ef7e649a6b5a052c604c8767668df78e30e161a0d5de0" => :x86_64_linux
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
