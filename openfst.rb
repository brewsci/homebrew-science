class Openfst < Formula
  desc "Open-source library for working with weighted finite-state transducers."
  homepage "http://www.openfst.org/"
  url "http://openfst.org/twiki/pub/FST/FstDownload/openfst-1.5.4.tar.gz"
  sha256 "acc115aaaa33de53de62dae44120ab368fabaea06f52606b77714081ecd32657"

  bottle do
    cellar :any
    sha256 "cfe30e7883dc714d8d43a8e0617434c78ba3338e3f534e7f8858a6b60ce19066" => :sierra
    sha256 "aab7e1ae09f71d183e432ea84abf841218d77dc0b791b2600c193059c0cacb10" => :el_capitan
    sha256 "0b4ebfec53234c67e715fffc77ebdf558e477fd4493aca63ff8b96ddae7dc8d1" => :yosemite
    sha256 "9be38a5d4573bc9404a64cf0186e020f8e221c59ae5900cfeeb4af8501dc03d7" => :x86_64_linux
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
