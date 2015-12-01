class Transtermhp < Formula
  homepage "http://transterm.cbcb.umd.edu/"
  url "http://transterm.cbcb.umd.edu/transterm_hp_v2.09.zip"
  sha256 "b636db1c0fe9731cc760d8f3639209d07f7f35309d83013cc9f9e40798ce8be0"

  def install
    system "make"
    bin.install %W[transterm calibrate.sh]
    (share/"transtermhp").install "USAGE.txt"
  end

  def caveats
    "Usage information: #{HOMEBREW_PREFIX}/share/transtermhp/USAGE.txt"
  end

  test do
    # `transterm -h` sends to stderr, so we send it to stdin of grep
    system "#{bin}/transterm -h 2>&1 | grep 'usage: transterm'"
  end
end
