class Phyutility < Formula
  desc "Analyze and modify trees and data matrices"
  homepage "https://blackrim.org/programs/phyutility/"
  url "https://github.com/blackrim/phyutility/releases/download/v2.7.1/phyutility_2.7.1.tar.gz"
  sha256 "3438336abda593cf3043d49910815dc8b8e506e9e44831726407f37a1a7506bc"
  # doi "10.1093/bioinformatics/btm619"
  # tag "bioinformatics'

  bottle :unneeded

  def install
    libexec.install "phyutility.jar"
    bin.write_jar_script libexec/"phyutility.jar", "phyutility"
    pkgshare.install "examples", "manual.pdf"
  end

  def caveats; <<-EOS.undent
    The manual and examples are in:
      #{opt_pkgshare}
    EOS
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    system *%W[#{bin}/phyutility -concat -in test.aln test2.aln -out test_new.aln]
    compare_file "test_new.aln", "test_all.aln"
  end
end
