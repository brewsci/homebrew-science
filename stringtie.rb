class Stringtie < Formula
  homepage "http://ccb.jhu.edu/software/stringtie"
  head "https://github.com/gpertea/stringtie"
  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  url "http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.0.3.tar.gz"
  sha256 "1567d9d87d9375a3db03fa0b682eaef4e89899df64fd001c14d475cc9e737e08"

  def install
    system "make", "release"
    bin.install "stringtie"
    doc.install "README", "LICENSE"
  end

  test do
    assert_match "transcripts", shell_output("stringtie 2>&1", 1)
  end
end
