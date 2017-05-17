class Lastz < Formula
  desc "Align DNA sequences, a pairwise aligner"
  homepage "https://www.bx.psu.edu/~rsharris/lastz/"
  url "https://www.bx.psu.edu/~rsharris/lastz/lastz-1.04.00.tar.gz"
  sha256 "dd2e417c088a794532125d4c3e83a2c4ce39e6d287ed69312fb8c665f885ed52"
  head "https://github.com/lastz/lastz"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "38c011278d0409f81be589f7e4e98ef72c41dc0cfca818c6048dfd5e47daee43" => :sierra
    sha256 "987bffa2f0c375cf8f96ec8d3f19119643a41fa90a8cca5dc20d4b4482d2a387" => :el_capitan
    sha256 "54ceb61339174bedfc87aca62f4a02600e1213c8ed694ae578d2978393f38a53" => :yosemite
  end

  def install
    system "make", "definedForAll=-Wall"
    bin.install "src/lastz", "src/lastz_D"
    prefix.install "README.lastz.html", "test_data", "tools"
  end

  test do
    assert_match "NOTE", shell_output("#{bin}/lastz --help", 1)
  end
end
