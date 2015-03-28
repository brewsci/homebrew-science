class Diamond < Formula
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.7.7.tar.gz"
  sha256 "e5be7ea7e35d32bbe7c66d767e0a4e7c5a7482ee44e35cdadf84f207295e6e6d"

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
