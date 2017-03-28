class Phylip < Formula
  desc "Package of programs for inferring phylogenies"
  homepage "http://evolution.genetics.washington.edu/phylip.html"
  # tag "bioinformatics"
  # doi "10.1007/BF01734359"

  url "http://evolution.gs.washington.edu/phylip/download/phylip-3.696.tar.gz"
  sha256 "cd0a452ca51922142ad06d585e2ef98565536a227cbd2bd47a2243af72c84a06"

  bottle do
    cellar :any
    sha256 "daeee300cdabd51776034085b97c2e19ffc3daef3efb378fb1e34ad0423b9650" => :sierra
    sha256 "04c818ae9fd034cc049f90d16fc8a04a3056efe6db572de46984c75378706731" => :el_capitan
    sha256 "de6dce855888ca1ea007f6492a104d80bd261579f9d2bb0320f98bedfa50cfc8" => :yosemite
    sha256 "c13101048ff00f36319cbe601669275f2e79810fa67826f7850b71f05b714b3c" => :mavericks
    sha256 "72d274eb537a6949a4832809b0912050ca25853f439c127f4ac0c7fe059e1768" => :mountain_lion
    sha256 "059d29ea0a4d231c17be873e8864ae1e7d6568b5b1a858e4f96ce37fd9614e5a" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make", "-f", "Makefile.unx", "all"
      system "make", "-f", "Makefile.unx", "put", "EXEDIR=#{libexec}"
    end

    rm Dir["#{libexec}/font*"]
    bin.install_symlink Dir["#{libexec}/*"] - Dir["#{libexec}/*.{so,jar,unx}"]
    pkgshare.install ["phylip.html", "doc"]
  end

  def caveats
    <<-EOS.undent
      The documentation has been installed to #{HOMEBREW_PREFIX}/share/phylip/
    EOS
  end

  test do
    # From http://evolution.genetics.washington.edu/phylip/doc/pars.html
    (testpath/"infile").write <<-EOF.undent
      7         6
      Alpha1    110110
      Alpha2    110110
      Beta1     110000
      Beta2     110000
      Gamma1    100110
      Delta     001001
      Epsilon   001110
    EOF
    expected = "(((Epsilon:0.00,Delta:3.00):2.00,Gamma1:0.00):1.00,(Beta2:0.00,Beta1:0.00):2.00,Alpha2:0.00,Alpha1:0.00);"
    system "echo 'Y' | #{bin}/pars"
    assert_match expected, File.read("outtree")
  end
end
