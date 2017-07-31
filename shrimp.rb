class Shrimp < Formula
  homepage "http://compbio.cs.toronto.edu/shrimp/"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1000386"

  url "http://compbio.cs.toronto.edu/shrimp/releases/SHRiMP_2_2_3.src.tar.gz"
  sha256 "61660d86a8c98ad25b3657c4c057dd5cca4de98ac55bd075de9ed296a718993a"
  version "2.2.3"

  bottle do
    cellar :any
    sha256 "2ab2012cdc0dec1e27d8c02a7b2c04b2f24f7d3cb078bc2599e527aa23ffcc4d" => :yosemite
    sha256 "3fae6267589367040d39b817ff6278585116d0c12e63dc7efdd6210b1d75e136" => :mavericks
    sha256 "60fe3a8309be67eac59e464822f024449623a5ded9e1533332d7837fe58e80ba" => :mountain_lion
    sha256 "c7872a361b1e0799e86b807a8d1e07c9f1e4e2a6bcb3f97cb7437d8c76342f0c" => :x86_64_linux
  end

  needs :openmp

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
