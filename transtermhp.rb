require 'formula'

class Transtermhp < Formula
  homepage 'http://transterm.cbcb.umd.edu/'
  url 'http://transterm.cbcb.umd.edu/transterm_hp_v2.09.zip'
  sha1 '492f4246f4c6629a315f921dae53526e0aaaa93a'

  def install
    system "make"
    bin.install %W(transterm calibrate.sh)
    (share/'transtermhp').install 'USAGE.txt'
  end

  def caveats
    "Usage information: #{HOMEBREW_PREFIX}/share/transtermhp/USAGE.txt"
  end

  test do
    # `transterm -h` sends to stderr, so we send it to stdin of grep
    system "#{bin}/transterm -h 2>&1 | grep 'usage: transterm'"
  end
end
