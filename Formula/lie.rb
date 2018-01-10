class Lie < Formula
  desc "Computer algebra package for Lie group computations"
  homepage "http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/"
  url "http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/conLiE.tar.gz"
  version "2.2.2"
  sha256 "c4d6f67fa17d2bc77c875a5b2ad2b42ffc5cadf30e7d1c64c097648ccb918b1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5707ae43a72b7d1a2c8a13b50e29e3e93c308f881a25b661251a777bcac26b52" => :el_capitan
    sha256 "ad2b6343ad46dde32cc1ddc2776bcf2e6908845485dc467abfd573b54a1331d5" => :yosemite
    sha256 "73b13c7f5bcd1ad17b95ac6f4c6e31a80a71f89caa333e976519546497878a14" => :mavericks
  end

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
