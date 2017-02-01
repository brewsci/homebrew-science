class A5 < Formula
  desc "Pipeline for de novo assembly of microbial genomes"
  homepage "https://sourceforge.net/projects/ngopt/"
  # doi "10.1371/journal.pone.0042304", "arXiv:1401.5130"
  # tag "bioinformatics"

  if OS.mac?
    url "https://downloads.sourceforge.net/project/ngopt/a5_miseq_macOS_20160825.tar.gz"
    sha256 "e89b2c3b6d1fe030c82cce4089023fee8320297c9bf251d49d6bc6a5210f8350"
  elsif OS.linux?
    url "https://downloads.sourceforge.net/project/ngopt/a5_miseq_linux_20160825.tar.gz"
    sha256 "76a2798d617d45f4539e73ef2df5f899503ac4a54c3a406faf37db6282127fe9"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c212fd42f487bfa10b4d8c7d39fc22838590db1340cb1c799e760dbacb282e7a" => :sierra
    sha256 "fcf4927415227a5fe49b6d88f089c4c026862d37ead5ce4a2c4d17ac4c6dbd1f" => :el_capitan
    sha256 "c212fd42f487bfa10b4d8c7d39fc22838590db1340cb1c799e760dbacb282e7a" => :yosemite
    sha256 "2030fc095c10ee08ef57e68a6de19edf145b39404d1103f557fd0883c79f41f5" => :x86_64_linux
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
