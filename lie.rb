class Lie < Formula
  desc "Computer algebra package for Lie group computations"
  homepage "http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/"
  url "http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/conLiE.tar.gz"
  version "2.2.2"
  sha256 "c4d6f67fa17d2bc77c875a5b2ad2b42ffc5cadf30e7d1c64c097648ccb918b1e"

  def install
    ENV.deparallelize
    # -D_ANSI_SOURCE suggested by the author at
    # http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/MacOSX.html
    system "make", "CFLAGS=-O -D_ANSI_SOURCE"
    libexec.install "Lie.exe"
    info.install Dir["INFO.*"]

    # The original Makefile builds a similar lie entry point but it is not
    # relocatable
    entry_point = bin/"lie"
    entry_point.write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/Lie.exe initfile #{info}
    EOS
  end

  test do
    system "#{bin}/lie"
  end
end
