class Openfst < Formula
  desc "Open-source library for working with weighted finite-state transducers."
  homepage "http://www.openfst.org/"
  url "http://openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.1.tar.gz"
  sha256 "5245af8ebccb96208eec2dfe3b3a81143d3565a4d41220bff299287fb3333f7d"

  bottle do
    cellar :any
    sha256 "8c310b06160325734d0e929b124b2baf9055b4354289d51c2e50495c49c42c8f" => :sierra
    sha256 "a17692ad0b0c2f72ea2681cc75adee8ef19af3bb4bbb2152e30b60d14179770f" => :el_capitan
    sha256 "436e3f3a47d5031c3a20b4fef159680edca0ad00b56b361ecd18584fb6d4f7a7" => :yosemite
    sha256 "413d7e2f71328ea5178d8c2f2149a77b51b9d8964cb4b4963f73c92d2718383a" => :x86_64_linux
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-compact-fsts",
                          "--enable-compress",
                          "--enable-const-fsts",
                          "--enable-far",
                          "--enable-linear-fsts",
                          "--enable-lookahead-fsts",
                          "--enable-mpdt",
                          "--enable-ngram-fsts",
                          "--enable-pdt",
                          "--enable-special"
    system "make", "install"
  end

  test do
    # Based on http://openfst.org/twiki/bin/view/FST/FstExamples.
    # Makes symbol table.
    File.open("ascii.syms", "w") do |sink|
      sink.puts "<epsilon>\t0"
      sink.puts "<space>\t32"
      33.upto(126) { |i| sink.puts "#{i.chr}\t#{i}" }
    end
    # Makes arclist for downcasing FST.
    File.open("downcase.arc", "w") do |sink|
      sink.puts "0\t0\t<epsilon>\t<epsilon>"
      sink.puts "0\t0\t<space>\t<space>"
      33.upto(126) { |i| sink.puts "0\t0\t#{i.chr}\t#{i.chr.downcase}" }
      sink.puts "0"
    end
    ## Compile the machine
    system bin/"fstcompile", "--isymbols=ascii.syms",
                             "--osymbols=ascii.syms",
                             "downcase.arc",
                             "downcase.fst"
  end
end
