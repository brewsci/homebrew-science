class OpengrmNgram < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary"
  url "http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.3.0.tar.gz"
  sha256 "bb5b4cb609f0beab6fabbb65234c818199a17a49e534bde270c6f72d880fe2b3"

  bottle do
    cellar :any
    sha256 "b928df84a8aff4878aa17df8b5d774ccb5e6aa98f2c59c3e1edd5307c95067c9" => :el_capitan
    sha256 "171dc8daa8603d2e052355e038b797a3f77f90f5af896f30b64262b9e63d9b5f" => :yosemite
    sha256 "5339487fc2738453ce23ff42fbcd76f0c25ef64c99f7e111a6bd1a23b7a327d4" => :mavericks
  end

  depends_on "openfst"

  resource "earnest" do
    url "http://www.openfst.org/twiki/pub/GRM/NGramQuickTour/earnest.txt"
    sha256 "bbdde0b9b7c2150772babbcf8b16837eb7cb40a488b7390413b342009c03887f"
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("earnest").stage do
      fname = "earnest.txt"
      # tests using normalized The Importance of Being Earnest, based on
      # examples from the OpenGRM "NGram quick tour" page...
      system bin/"ngramsymbols", fname, "e.syms"

      # NB: farcompilestrings is distributed as part of OpenFST
      system "farcompilestrings", "-symbols=e.syms",
                                      "-keep_symbols=1",
                                      fname, "e.far"
      system bin/"ngramcount", "-order=5", "e.far", "e.cnts"
      system bin/"ngrammake", "e.cnts", "e.mod"
      system bin/"ngramshrink", "-method=relative_entropy", "e.mod", "e.pru"
      system bin/"ngramprint", "--ARPA", "e.mod"
      system bin/"ngraminfo", "e.mod"
    end
  end
end
