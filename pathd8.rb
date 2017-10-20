class Pathd8 < Formula
  desc "Estimates divergence times in large phylogenetic trees"
  homepage "https://www2.math.su.se/PATHd8/"
  url "https://www2.math.su.se/PATHd8/PATHd8.zip"
  version "1.0"
  sha256 "6f92c1104b5fcdacdcc387024b5a1324790a165d0418795dec2ec68ebb946749"
  bottle do
    cellar :any
    sha256 "7c528b0dc0e519835fdfff2747d1c7286754836775d520dc2192ce13bba61b39" => :yosemite
    sha256 "6adf43717f2e2044cb5e7f14a8449e4ff3edcaa6753198f0fdfc1422bcc1b0d9" => :mavericks
    sha256 "16a7b4f5c4c4997988ca2f8cf9f4930419d769ff2b69e82f4745ebef78ab31e7" => :mountain_lion
    sha256 "835d60e92ce65c8bf00a33bc9ed79bfb959b22081d7dc8a041e4e07f64c846ac" => :x86_64_linux
  end

  # doi "10.1080/10635150701613783"
  # tag "bioinformatics"

  def install
    # Build instructions per https://www2.math.su.se/PATHd8/compile.html
    system ENV.cc, "PATHd8.c", "-O3", "-lm", "-o", "PATHd8"
    bin.install "PATHd8"
  end

  test do
    (testpath/"infile").write <<-EOS.undent
      Sequence length = 1823;
      ((((Rat:0.007148,Human:0.001808):0.024345,Platypus:0.016588):0.012920,(Ostrich:0.018119,Alligator:0.006232):0.004708):0.028037,Frog:0);
      mrca: Rat, Ostrich, minage=260;
      mrca: Human, Platypus, fixage=125;
      mrca: Alligator, Ostrich, minage=150;
      name of mrca: Platypus, Rat, name=crown_mammals;
      name of mrca: Human, Rat, name=crown_placentals;
      name of mrca: Ostrich, Alligator, name=crown_Archosaurs;
    EOS

    assert_match(/Calculation finished./, shell_output("#{bin}/PATHd8 -n infile -pa", 1))
  end
end
