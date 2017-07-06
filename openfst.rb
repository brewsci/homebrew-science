class Openfst < Formula
  desc "Open-source library for working with weighted finite-state transducers."
  homepage "http://www.openfst.org/"
  url "http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.3.tar.gz"
  sha256 "5c28b6ccd017fc6ff94ebd0c73ed8ab37d48f563dab1c603856fb05bc9333d99"

  bottle do
    cellar :any
    sha256 "62f64bd93abe2834f07e1ee79a363d1cfa106f4e9faaad8e1f3537f772e88b1e" => :sierra
    sha256 "695595240d43745060ecafa520178c8890dea8b34f47fb5f174f85bcddad9f63" => :el_capitan
    sha256 "97b714421950df1d9693c294e5d8f69ca167474737e43fe6b1305f5269a98b54" => :yosemite
    sha256 "b20ee657fe8fdd2c8bfde124e1aff050b0724eb061b2bb820a2d928299f24e6e" => :x86_64_linux
  end

  needs :cxx11

  depends_on "zlib" unless OS.mac?

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
