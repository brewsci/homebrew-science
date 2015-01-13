class A5 < Formula
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
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "3c6267d80a3b0100394b900793ea23c109d2593c" => :mountain_lion
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
