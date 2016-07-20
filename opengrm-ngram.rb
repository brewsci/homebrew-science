class OpengrmNgram < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary"
  url "http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.3.0.tar.gz"
  sha256 "bb5b4cb609f0beab6fabbb65234c818199a17a49e534bde270c6f72d880fe2b3"

  bottle do
    cellar :any
    sha256 "58c0aacb0f298b5e4777864487172ef78886e2affffc6c13c5876c529d309529" => :el_capitan
    sha256 "8a906fb5089a8db967529bc4edf8a38ebb462c3e41c1ce4c849459efca5ed111" => :yosemite
    sha256 "7b6c06fa7c008e8f0799ef3f0071f9e621cdda196ef9b2ff37282309a7460756" => :mavericks
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
