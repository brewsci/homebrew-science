class Pathd8 < Formula
  desc "Estimates divergence times in large phylogenetic trees"
  homepage "http://www2.math.su.se/PATHd8/"
  url "http://www2.math.su.se/PATHd8/PATHd8.zip"
  version "1.0"
  sha256 "6f92c1104b5fcdacdcc387024b5a1324790a165d0418795dec2ec68ebb946749"
  # doi "10.1080/10635150701613783"
  # tag "bioinformatics"

  def install
    # Build instructions per http://www2.math.su.se/PATHd8/compile.html
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
