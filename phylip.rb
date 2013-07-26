require 'formula'

class Phylip < Formula
  homepage 'http://evolution.genetics.washington.edu/phylip.html'
  url 'http://evolution.gs.washington.edu/phylip/download/phylip-3.695.tar.gz'
  sha1 '1505d1b3bb1378244e1733a6ecb173b3259c3d0f'

  depends_on :x11

  def install
    cd 'src' do
      system "make -f Makefile.unx all"
      system "make -f Makefile.unx put EXEDIR=#{bin}"
      # Perhaps one day the Mac apps will work (with cocoa) "make -f Makefile.osx apps"
    end

    # Remove installed fonts
    bin.cd do
      rm Dir['font*']
    end

    (share/'phylip').install ['phylip.html', 'doc']
  end

  def caveats
    <<-EOS.undent
      The documentation has been installed to #{HOMEBREW_PREFIX}/share/phylip/phylip.html.
    EOS
  end

  def test
    # From http://evolution.genetics.washington.edu/phylip/doc/pars.html
    mktemp do
      Pathname.new('infile').write <<-EOF.undent
        7         6
        Alpha1    110110
        Alpha2    110110
        Beta1     110000
        Beta2     110000
        Gamma1    100110
        Delta     001001
        Epsilon   001110
      EOF
      Pathname.new('expected').write <<-EOF.undent
        (((Epsilon:0.00,Delta:3.00):2.00,Gamma1:0.00):1.00,(Beta2:0.00,Beta1:0.00):2.00,Alpha2:0.00,Alpha1:0.00);
      EOF
      system "echo 'Y' | #{bin}/pars"
      compare_file 'outtree', 'expected'
    end
  end
end
