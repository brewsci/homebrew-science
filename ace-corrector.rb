class AceCorrector < Formula
  desc "correct substitution errors in Illumina reads"
  homepage "https://github.com/Sheikhizadeh/ACE"
  # doi "10.1093/bioinformatics/btv332"
  # tag "bioinformatics"

  url "https://github.com/Sheikhizadeh/ACE.git",
    :revision => "189f154997aeef954d690a8a08300233c21305f3"
  version "20150501"

  head "https://github.com/Sheikhizadeh/ACE.git"

  needs :openmp

  def install
    system "make"
    bin.install "ace"
  end

  test do
    assert_match "Genome_length", shell_output("ace 2>&1", 0)
  end
end
