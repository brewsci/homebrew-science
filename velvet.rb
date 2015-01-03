class Velvet < Formula
  homepage "http://www.ebi.ac.uk/~zerbino/velvet/"
  url "http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz"
  sha1 "216f0941609abf3a73adbba19ef1f364df489d18"
  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ecf378cb7ed8b9b566c3f0f1049083c6b83ea4af" => :yosemite
    sha1 "ebf96b199d156ed982d4adbf8609fe664db7b9a7" => :mavericks
    sha1 "a20d3967da762fcb77bef5530b80ad8634de4dd3" => :mountain_lion
  end

  #doi "10.1101/gr.074492.107"
  #tag "bioinformatics"
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
