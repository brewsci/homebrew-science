class Openfst < Formula
  desc "Open-source library for working with weighted finite-state transducers."
  homepage "http://www.openfst.org/"
  url "http://openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.1.tar.gz"
  sha256 "5245af8ebccb96208eec2dfe3b3a81143d3565a4d41220bff299287fb3333f7d"

  bottle do
    cellar :any
    sha256 "4b0e12fbc1e4fc1b54757cc87a3757e517186e95f8db6917b96966fd805dba6f" => :sierra
    sha256 "0969ec5732bf52d43e05e0813c834a539fc25db981502088e12ee5ff9a272467" => :el_capitan
    sha256 "9b77ae1524ca836cb4c0ea65e76ad27e54d6db70045ba3518698120922b354ce" => :yosemite
    sha256 "89232dd56bc8e8610523c935e946e42b79f4cabfb619f965aef3cfb77779db16" => :x86_64_linux
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
