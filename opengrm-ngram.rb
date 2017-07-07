class OpengrmNgram < Formula
  desc "Open-source library for constructing ngram language models, represented as weighted finite-state transducers."
  homepage "http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary"
  url "http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.3.2.tar.gz"
  sha256 "f44a2115e6f3ae7de3a9af6212592b1873fa4c1c1b3d2307f51df21c6dc87ea7"

  revision 2

  bottle do
    cellar :any
    sha256 "ae2f008164e2904aa79f726929aab3f04b2ac74f8ecca8a3419b6bcdc8d4a8eb" => :sierra
    sha256 "a048a2efac3093f4ed135c781c2d62dae94e640bfd924fa79e31e01658850a8d" => :el_capitan
    sha256 "833ed961e7440eb27f1285ceb23851819cf9826b77f1eb0e7d5cf36b87d56f01" => :yosemite
    sha256 "3bed1ed20591e6a2f625eb28a07f4dfb27ce2122352132877ef2ef238aa3ce86" => :x86_64_linux
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
