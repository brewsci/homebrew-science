class Phylip < Formula
  homepage "http://evolution.genetics.washington.edu/phylip.html"
  #tag "bioinformatics"
  #doi "10.1007/BF01734359"

  url "http://evolution.gs.washington.edu/phylip/download/phylip-3.696.tar.gz"
  sha1 "e3ac52ca37c3397f81bb9325ee21ca8e5a8a2fa4"

  bottle do
    cellar :any
    sha256 "de6dce855888ca1ea007f6492a104d80bd261579f9d2bb0320f98bedfa50cfc8" => :yosemite
    sha256 "c13101048ff00f36319cbe601669275f2e79810fa67826f7850b71f05b714b3c" => :mavericks
    sha256 "72d274eb537a6949a4832809b0912050ca25853f439c127f4ac0c7fe059e1768" => :mountain_lion
  end

  def install
    cd "src" do
      system "make -f Makefile.unx all"
      system "make -f Makefile.unx put EXEDIR=#{libexec}"
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
    assert File.read("outtree").include?(expected)
  end
end
