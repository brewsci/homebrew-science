class Velvet < Formula
  desc "Sequence assembler for very short reads"
  homepage "https://www.ebi.ac.uk/~zerbino/velvet/"
  url "https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz"
  sha256 "884dd488c2d12f1f89cdc530a266af5d3106965f21ab9149e8cb5c633c977640"

  # doi "10.1101/gr.074492.107"
  # tag "bioinformatics"
  head "https://github.com/dzerbino/velvet.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b475b9b3cd469d2f0665fa84fc73108632c86e53a06d04b9b979c2a4ced65344" => :sierra
    sha256 "6fe3c9d2afef2247e13d63fe148baefb4be9515a680267c78474467f92528820" => :el_capitan
    sha256 "505a5749837f89cfe68f058593bc23a6c1c935ff5e212c03109b3c9c136d4de0" => :yosemite
    sha256 "83ff1ef5b16dd8f142418c9b54189ff86979d7ba427ca55cc44c3fe6ad2197c0" => :x86_64_linux
  end

  option "with-maxkmerlength=", "Specify maximum k-mer length, any positive odd integer (default: 31)"
  option "with-categories=", "Specify number of categories, any positive integer (default: 2)"
  option "with-openmp", "Enable OpenMP multithreading"

  needs :openmp if build.with? "openmp"

  def install
    args = ["CFLAGS=-Wall -m64", "LONGSEQUENCES=1"]
    args << "OPENMP=1" if build.with? "openmp"
    maxkmerlength = ARGV.value("with-maxkmerlength") || "-1"
    categories = ARGV.value("with-categories") || "-1"
    args << "MAXKMERLENGTH=#{maxkmerlength}" if maxkmerlength.to_i > 0
    args << "CATEGORIES=#{categories}" if categories.to_i > 0

    system "make", "velveth", "velvetg", *args
    bin.install "velveth", "velvetg"

    # install additional contributed scripts
    (share / "velvet/contrib").install Dir["contrib/shuffleSequences_fasta/shuffleSequences_*"]
  end

  def caveats
    <<-EOS.undent
      Some additional user contributed scripts are installed here:
      #{share}/velvet/contrib
    EOS
  end

  test do
    system "velveth", "--help"
    system "velvetg", "--help"
  end
end
