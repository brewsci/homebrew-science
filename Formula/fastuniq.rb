class Fastuniq < Formula
  homepage "https://sourceforge.net/projects/fastuniq/"
  # tag "bioinformatics"
  # doi "10.1371/journal.pone.0052249"

  url "https://downloads.sourceforge.net/project/fastuniq/FastUniq-1.1.tar.gz"
  sha256 "9ebf251566d097226393fb5aa9db30a827e60c7a4bd9f6e06022b4af4cee0eae"

  bottle do
    cellar :any
    sha256 "19465fcbe38c09187aed0df6a5ff2aeb640cabee976220b9a6eefb51d632de5e" => :yosemite
    sha256 "07890a374729fe11b214426e5ab17f5b57b80b735bd5f84611dd37f71de2259f" => :mavericks
    sha256 "f662ad9cce7dc9251ec813b170c3f3178e7f7998bcecd8399900742b1604d807" => :mountain_lion
    sha256 "707131d1bb1cb57f8e14edf496c6cefecb77ac917bc0b3bb4c894c8ef77dc9ac" => :x86_64_linux
  end

  def install
    inreplace "source/fastq_uniq.c", "FSATQ", "FASTQ" # fix typo
    system "make", "-C", "source"
    bin.install "source/fastuniq"
    doc.install "README.txt"
    (share / "fastuniq").install Dir["example/*"]
  end

  test do
    assert_match "read pairs", shell_output("fastuniq 2>&1", 1)
  end
end
