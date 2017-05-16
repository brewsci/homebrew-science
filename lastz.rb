class Lastz < Formula
  desc "Align DNA sequences, a pairwise aligner"
  homepage "https://www.bx.psu.edu/~rsharris/lastz/"
  url "https://www.bx.psu.edu/~rsharris/lastz/lastz-1.04.00.tar.gz"
  sha256 "dd2e417c088a794532125d4c3e83a2c4ce39e6d287ed69312fb8c665f885ed52"
  head "https://github.com/lastz/lastz"
  # tag "bioinformatics"

  def install
    system "make", "definedForAll=-Wall"
    bin.install "src/lastz", "src/lastz_D"
    prefix.install "README.lastz.html", "test_data", "tools"
  end

  test do
    assert_match "NOTE", shell_output("#{bin}/lastz --help", 1)
  end
end
