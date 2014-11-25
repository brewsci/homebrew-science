require "formula"

class Phylip < Formula
  homepage "http://evolution.genetics.washington.edu/phylip.html"
  #tag "bioinformatics"
  #doi "10.1007/BF01734359"

  url "http://evolution.gs.washington.edu/phylip/download/phylip-3.696.tar.gz"
  sha1 "e3ac52ca37c3397f81bb9325ee21ca8e5a8a2fa4"

  def install
    cd "src" do
      system "make -f Makefile.unx all"
      system "make -f Makefile.unx put EXEDIR=#{libexec}"
    end

    rm Dir["#{libexec}/font*"]
    bin.install_symlink Dir["#{libexec}/*"] - Dir["#{libexec}/*.{so,jar,unx}"]
    (share/"phylip").install ["phylip.html", "doc"]
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
