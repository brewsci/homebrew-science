class Megahit < Formula
  homepage "https://github.com/voutcn/megahit"
  # doi "arXiv:1409.7208"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.2.0-a.tar.gz"
  version "0.2.0-a"
  sha256 "5b30a163027b248bf2d96c766c3bcf1f4fe50466e368a3844b3c4e0a2491d8c4"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "1062de33a9f763da8b0c5831a57fb242522fee537a738b7e041f4dad0096f81f" => :yosemite
    sha256 "50d914fb564f32f4b14a71f66f4613e022f51a62722265575819b71d3a05b2d8" => :mavericks
    sha256 "43c1b07fb07133830d554d775eb9e7feeae3c73b8ce34599ad7fa742a2f30f47" => :mountain_lion
  end

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
    llvm-g++ does not support -mpopcnt, -std=c++0x
    options
    EOS
  end

  # Fix error: 'omp.h' file not found
  needs :openmp

  def install
    system "make"
    bin.install ["megahit",
                 "megahit_assemble",
                 "megahit_iter_k124",
                 "megahit_iter_k61",
                 "megahit_iter_k92",
                 "sdbg_builder_cpu"]

    doc.install "ChangeLog.md", "README.md"
  end

  test do
    system "#{bin}/megahit --help 2>&1 |grep megahit"
  end
end
