class OpengrmNgram < Formula
  desc "Open-source library for constructing ngram language models, represented as weighted finite-state transducers."
  homepage "http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary"
  url "http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.3.1.tar.gz"
  sha256 "fd862680405000bbc789d0826237cca3295d0b778e5c0e2fa5e7762d33d3fbf2"

  bottle do
    cellar :any
    sha256 "5c3192e90447fb767ed3148faba7a6c03a490f2b18822498e521d882e2bf567f" => :sierra
    sha256 "bcd431e07e5b30194fbd05a0ff33c815fdc494ecfbc5f7ba26db137a98c21991" => :el_capitan
    sha256 "170cc253710c074fd0f9275a4cb8d01746e33b9855fad957e19e3643f32af47e" => :yosemite
    sha256 "82c07698a1044cff7599deb13a1acc12518569bf4a5e334d725765cf37767845" => :x86_64_linux
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
