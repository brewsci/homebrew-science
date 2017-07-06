class OpengrmNgram < Formula
  desc "Open-source library for constructing ngram language models, represented as weighted finite-state transducers."
  homepage "http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary"
  url "http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.3.2.tar.gz"
  sha256 "f44a2115e6f3ae7de3a9af6212592b1873fa4c1c1b3d2307f51df21c6dc87ea7"

  revision 2

  bottle do
    cellar :any
    sha256 "2c018ccfc40596618d645052576fcf572e1a628ac3d489ca6be2c317a19f54ae" => :sierra
    sha256 "fd0d2eedc9f56beee097f2cab312367f27019fc31afcf40530790afea363cf46" => :el_capitan
    sha256 "cc29fec3a0f1934ab153ab2703c984076c7f854e9b9371891ca63b615028ead9" => :yosemite
    sha256 "3e8fe1adce925bb4c424f8b4b8aec9a2d69b62b7d4b62eeeb1df5c72d3e0e43f" => :x86_64_linux
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
