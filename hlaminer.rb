require "formula"

class Hlaminer < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer"
  #doi "10.1186/gm396"
  #tag "bioinformatics"
  url "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer/releases/1.1/HLAminer.tar.gz"
  version "1.1.0"
  sha1 "d1c97731885bc7a12f67027e0e0b01c8bfb03bd2"

  depends_on "tasr"
  depends_on "blast"

  def install
    # Conflicts with tasr
    rm "bin/TASR"

    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/HLAminer.pl |grep hlaminer"
  end
end
