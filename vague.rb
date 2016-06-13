class Vague < Formula
  desc "Velvet assembler graphical front end"
  homepage "http://www.vicbioinformatics.com/software.vague.shtml"
  url "http://www.vicbioinformatics.com/vague-1.0.5.tar.gz"
  sha256 "7144bef4a5c8ccb3d0e6b27201a506e1cfa25812fb9bbe54842dc910100c5907"
  head "https://github.com/Victorian-Bioinformatics-Consortium/vague.git"
  # doi "10.1093/bioinformatics/bts664"
  # tag "bioinformatics"

  bottle :unneeded

  depends_on "velvet"

  def install
    opts = "-Xmx3750m"
    jar = "vague.jar"
    java = share/"java"
    java.install jar
    bin.write_jar_script java/jar, "vague", opts

    inreplace "velvetk.pl", "/usr/bin/perl", "/usr/bin/env perl"
    bin.install "velvetk.pl"

    doc.install "README.txt", "ChangeLog", "COPYING.txt"
  end

  test do
    # can't test main app because it is GUI only so we test a helper script
    assert_match "genome", shell_output("#{bin}/velvetk.pl 2>&1", 1)
  end
end
