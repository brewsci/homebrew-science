class A5 < Formula
  desc "Pipeline for de novo assembly of microbial genomes"
  homepage "https://sourceforge.net/projects/ngopt/"
  # doi "10.1371/journal.pone.0042304", "arXiv:1401.5130"
  # tag "bioinformatics"

  if OS.mac?
    url "https://downloads.sourceforge.net/project/ngopt/a5_miseq_macOS_20150522.tar.gz"
    sha256 "f7e2c42538fc16e3bd43623a74f1557af26d8864bd18041ab42c5477d3d78421"
  elsif OS.linux?
    url "https://downloads.sourceforge.net/project/ngopt/a5_miseq_linux_20150522.tar.gz"
    sha256 "1b8ccfceec78436ecf9f2e27998a7b91050d4a7f46918ef48b7de5d3aa4a8e5b"
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
