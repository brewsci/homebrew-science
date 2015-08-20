class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  bottle do
    cellar :any
    sha256 "9d69a98a442701f818df56325beeb1ddc8457da5932da172706becf18f6d3fed" => :yosemite
    sha256 "89ff010f4542bb2f63144c642a125fdedee8367a14410bfd3b30c6b27caeb1c9" => :mavericks
    sha256 "834d20f5a8b812cdb8c1e2b9c36a8baf35b5f6e5d7f3af910350713a3357ae5e" => :mountain_lion
  end

  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"

  url "http://spades.bioinf.spbau.ru/release3.6.0/SPAdes-3.6.0.tar.gz"
  sha256 "6c04e55d068ad3e5b44c862cb031d41fcd433ab97e5dedadebcc5f785cde13a9"

  depends_on "cmake" => :build

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    # Fix the audit error "Non-executables were installed to bin"
    inreplace bin/"spades_init.py" do |s|
      s.sub! /^/, "#!/usr/bin/env python\n"
    end
  end

  test do
    system "spades.py", "--test"
  end
end
