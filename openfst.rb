class Openfst < Formula
  homepage "http://www.openfst.org/"
  url "http://openfst.org/twiki/pub/FST/FstDownload/openfst-1.5.3.tar.gz"
  sha256 "9b09e457aeab87f613508b92a0f9f820140c9e18d05584e3f1ae384396b5dcbd"

  bottle do
    cellar :any
    sha256 "849391e18b8bd83f1dac534d2de39695f8e2ac86ec52ffc4ca32bf93fa10b193" => :el_capitan
    sha256 "3e5fab5f10ca685304e3faefabc00ca9a21dfb5d46db03c78eef7226b53d426b" => :yosemite
    sha256 "bcb3de924944b61d877321c010688eb3997f0d18503d0dc18a7a8144b015357c" => :mavericks
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
                          "--enable-pdt"
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
