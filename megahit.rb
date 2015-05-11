class Megahit < Formula
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.2.1.tar.gz"
  sha256 "28299b06e20950eed8a3f5b580b26a0bdffc260112f27dde860bd12f99d06f7b"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "c3dbc085c578e6110f2af2ce1aecfd5737b936ac18a902aca2e7b48cdcbc285d" => :yosemite
    sha256 "3173ed97b7b230965812a35ff91d4d92a87c9de4d8b900a4778a7a1b50d45943" => :mavericks
    sha256 "89f238296db52b731e8f769ff8dc62bb23165e075576bef5ec2e60fe1db5e829" => :mountain_lion
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
