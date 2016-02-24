class Openfst < Formula
  homepage "http://www.openfst.org/"
  url "http://openfst.org/twiki/pub/FST/FstDownload/openfst-1.5.1.tar.gz"
  sha256 "bb0c0e6cf8bed843c36f412f66abfd87604b3220773e4c25fd723a7a5759a3f2"

  bottle do
    cellar :any
    sha256 "ef6864766129fc9660c54896864eaf0531b37298865b4953d59c26b030b120e8" => :el_capitan
    sha256 "2f3616b0db610fad5692f7f57a6633b0113a71eeae4d5f9cd87bfb0c8429d46f" => :yosemite
    sha256 "244521039fdfc08adc89908e5ed12f43e4b9786b3be0f18458910de9fc3fe5b5" => :mavericks
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
