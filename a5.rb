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
    cellar :any_skip_relocation
    sha256 "5694a2ae1e9cf95c9c4fdcc2dcb23069c89fc305a05e18f4c3f759caa56c2124" => :sierra
    sha256 "712a52ae946e36d3410f6ea98425605aceffebaa738a397e6721100de6474e12" => :el_capitan
    sha256 "589bb490b43853bd8bbb0817018141efd3e65794844fbcfaf950d6ea55d4d7bb" => :yosemite
    sha256 "c6ae86aad65c91dbcf2b647acdbd25ac5672f8c04f34e7aa9fb991992d9e8fbd" => :mavericks
    sha256 "174ba48713d53b612375e2ac4b850455625a276a9078edb53f9e02882b11bfc4" => :x86_64_linux
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
