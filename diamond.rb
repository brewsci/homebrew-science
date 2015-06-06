class Diamond < Formula
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.7.9.tar.gz"
  sha256 "25dc43e41768f7a41c98b8b1dcf5aa2c51c0eaf62e71bff22ad01c97b663d341"

  # Fix fatal error: 'omp.h' file not found
  needs :openmp

  depends_on "boost"

  def install
    Dir.chdir("src") do
      inreplace "Makefile", "-Iboost/include", "-I#{Formula["boost"].include}"
      inreplace "Makefile", "LIBS=-l", "LIBS=-L#{Formula["boost"].lib} -l"
      inreplace "Makefile", "-lboost_thread", "-lboost_thread-mt"
      system "make"
    end
    bin.install "bin/diamond"
    doc.install "README.rst"
  end


  test do
    assert_match "gapextend", shell_output("diamond -h 2>&1", 0)
  end
end
