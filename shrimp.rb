class Shrimp < Formula
  homepage "http://compbio.cs.toronto.edu/shrimp/"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1000386"

  url "http://compbio.cs.toronto.edu/shrimp/releases/SHRiMP_2_2_3.src.tar.gz"
  sha256 "61660d86a8c98ad25b3657c4c057dd5cca4de98ac55bd075de9ed296a718993a"
  version "2.2.3"

  needs :openmp
  fails_with :llvm

  def install
    ENV.delete("CXXFLAGS")
    system "make"
    bin.install Dir["bin/*"]
    doc.install %w[HISTORY LICENSE README SPLITTING_AND_MERGING
                   SCORES_AND_PROBABILITES TODO BUILDING]
  end

  test do
    assert_match "LETTER SPACE", shell_output("gmapper-ls 2>&1", 1)
    assert_match "COLOUR SPACE", shell_output("gmapper-cs 2>&1", 1)
  end
end
