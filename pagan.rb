class Pagan < Formula
  homepage "http://wasabiapp.org/software/pagan/"
  # doi "10.1093/bioinformatics/bts198"
  # tag "bioinformatics"

  url "http://wasabiapp.org/download/pagan/pagan.src.20140814.tgz"
  sha1 "56e90fffcc715f1230d56babdaaaab0a2e9c9073"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "20e278e1499dbb1e40e785e576fb3056450bda7b" => :yosemite
    sha1 "3ed1f813d9598dda5ce1e0363ac6efa9f3d9ff23" => :mavericks
    sha1 "1b644b66bc15a5207b6739b61629d78ac9571e83" => :mountain_lion
  end

  head "https://code.google.com/p/pagan-msa/", :using => :git

  depends_on "boost"
  depends_on "exonerate" => :recommended
  depends_on "mafft" => :recommended
  depends_on "raxml" => :recommended

  def install
    cd "src" do
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
