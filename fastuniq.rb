class Fastuniq < Formula
  homepage "http://sourceforge.net/projects/fastuniq/"
  # tag "bioinformatics"
  # doi "10.1371/journal.pone.0052249"

  url "https://downloads.sourceforge.net/project/fastuniq/FastUniq-1.1.tar.gz"
  sha256 "9ebf251566d097226393fb5aa9db30a827e60c7a4bd9f6e06022b4af4cee0eae"

  def install
    inreplace "source/fastq_uniq.c", "FSATQ", "FASTQ"  # fix typo
    system "make", "-C", "source"
    bin.install "source/fastuniq"
    doc.install "README.txt"
    (share / "fastuniq").install Dir["example/*"]
  end

  test do
    assert_match "read pairs", shell_output("fastuniq 2>&1", 1)
  end
end
