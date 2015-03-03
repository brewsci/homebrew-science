class Pagan < Formula
  homepage "http://wasabiapp.org/software/pagan/"
  # doi "10.1093/bioinformatics/bts198"
  # tag "bioinformatics"

  url "http://wasabiapp.org/download/pagan/pagan.src.20140814.tgz"
  version "0.56"
  sha1 "56e90fffcc715f1230d56babdaaaab0a2e9c9073"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "c3930ba3305619525c4214c17aca22dc9ec0bd22" => :yosemite
    sha1 "9db9d0ac080e7e45c758518c596dd26b2b1e7046" => :mavericks
    sha1 "cdae8f3c2540d80064133158fcbc2c49c32a7674" => :mountain_lion
  end

  head "https://code.google.com/p/pagan-msa/", :using => :git

  depends_on "boost"
  depends_on "exonerate" => :recommended
  depends_on "mafft" => :recommended
  depends_on "raxml" => :recommended

  def install
    cd "src" do
      # Remove the explicit search of /usr/include
      inreplace "Makefile", "-I/usr/include ", ""

      # Fix error ld: library not found for -lboost_thread
      inreplace "Makefile", "-lboost_thread", "-lboost_thread-mt"

      # Fix undefined symbol boost::program_options::validators::check_first_occurrence
      inreplace "Makefile", "-Wl,-rpath,", ""

      system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}", "LINK=#{ENV.cxx}"
      bin.install "pagan"
    end
    doc.install "readme.txt", "VERSION_HISTORY"
    prefix.install "examples"
  end

  test do
    system "#{bin}/pagan", "--version"
  end
end
