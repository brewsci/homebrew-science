class Pagan < Formula
  homepage "http://wasabiapp.org/software/pagan/"
  # doi "10.1093/bioinformatics/bts198"
  # tag "bioinformatics"

  url "http://wasabiapp.org/download/pagan/pagan.src.20140814.tgz"
  version "0.56"
  sha1 "56e90fffcc715f1230d56babdaaaab0a2e9c9073"

  bottle do
    cellar :any
    sha256 "6bfda1f2930af90ec8dd592164b131f5dd1b9459841f41f6b653068119dbd9d9" => :yosemite
    sha256 "1115201aea338ffe4c5b1c09fde8f9864824400a4723713e33cd8297e141e88c" => :mavericks
    sha256 "4a3c7bdeb917885814d55e3e1d221e40eb78f1e91e94c3f99eff805181012d6b" => :mountain_lion
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
