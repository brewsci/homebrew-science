class OpengrmNgram < Formula
  desc "Open-source library for constructing ngram language models, represented as weighted finite-state transducers."
  homepage "http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary"
  url "http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.3.2.tar.gz"
  sha256 "f44a2115e6f3ae7de3a9af6212592b1873fa4c1c1b3d2307f51df21c6dc87ea7"

  bottle do
    cellar :any
    sha256 "16f0a73b5622203eb5d7048c5f8c914dc4a36852db732d71785ff361135876ec" => :sierra
    sha256 "076aaef2d36383f006deb64418811ba9f411ba8f8f773f2b9fc2ebc15c0ffa7e" => :el_capitan
    sha256 "b29f5e270013c25e0a5f467f4580c28c7ce6ede300e480e0cb29a87befa35bac" => :yosemite
    sha256 "b3995f40158195233df264676c03d1bc7407d47faa537380620508e254e4c1b6" => :x86_64_linux
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
