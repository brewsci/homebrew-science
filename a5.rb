class A5 < Formula
  desc "Pipeline for de novo assembly of microbial genomes"
  homepage "https://sourceforge.net/projects/ngopt/"
  #doi "10.1371/journal.pone.0042304", "arXiv:1401.5130"
  #tag "bioinformatics"

  if OS.mac?
    url "https://downloads.sourceforge.net/project/ngopt/a5_miseq_macOS_20141120.tar.gz"
    sha1 "720728be842202345892dd76a74784c4f2eddbaa"
  elsif OS.linux?
    url "https://downloads.sourceforge.net/project/ngopt/a5_miseq_linux_20141120.tar.gz"
    sha1 "3a9bfdecb519064db98065cb3cb525705c641207"
  end

  bottle do
    cellar :any
    revision 1
    sha256 "72a967a1711b870b160972d2de8d3394a3ec707deb05aee1c7508edf5d9523cb" => :yosemite
    sha256 "e343316816ced903744afc45f6b52ada5b4ef211e87b284c6a3bc9aa22e87b3b" => :mavericks
    sha256 "ae232e4ee149c17c8726aae461105769ae4ec405df9b0d30d45e2a4d14a06e42" => :mountain_lion
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink "../libexec/bin/a5_pipeline.pl"
  end

  test do
    system "#{bin}/a5_pipeline.pl --version 2>&1 |grep A5"
    system "#{libexec}/test.a5.sh"
  end
end
