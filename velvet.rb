class Velvet < Formula
  homepage "http://www.ebi.ac.uk/~zerbino/velvet/"
  url "http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz"
  sha256 "884dd488c2d12f1f89cdc530a266af5d3106965f21ab9149e8cb5c633c977640"
  bottle do
    cellar :any
    sha256 "23c3dbe996eead11507bad1f51fd499c2165d21927fb71812d21da1e4f38669d" => :yosemite
    sha256 "f37e358add021cf9b8b6f9d6eb3f59b41f95c851caa57412d2314347ae8ba7e7" => :mavericks
    sha256 "f0b135f0ef7da58a0b0e396d90e3b96049ebd250ca76e5d081dceddcee1685c9" => :mountain_lion
    sha256 "2477e5faff7282470c8d05616c366f6c942069def5a5db15f92fdca0e4eaa2d3" => :x86_64_linux
  end

  # doi "10.1101/gr.074492.107"
  # tag "bioinformatics"
  head "https://github.com/dzerbino/velvet.git"

  option "with-maxkmerlength=", "Specify maximum k-mer length, any positive odd integer (default: 31)"
  option "with-categories=", "Specify number of categories, any positive integer (default: 2)"

  def install
    args = ["CFLAGS=-Wall -m64", "LONGSEQUENCES=1"]
    args << "OPENMP=1" unless ENV.compiler == :clang
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
