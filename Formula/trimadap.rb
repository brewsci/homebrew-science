class Trimadap < Formula
  desc "Fast but inaccurate adapter trimmer for Illumina reads"
  homepage "https://github.com/lh3/trimadap"
  # tag "bioinformatics"

  url "https://github.com/lh3/trimadap/archive/0.1.tar.gz"
  sha256 "553069d81004b120d9df7d6161edce9317c0f95e5eefe2ec3325dd4081a90acd"
  head "https://github.com/lh3/trimadap.git"

  bottle do
    cellar :any
    sha256 "8d249f2eab9c8ab60062c86863e6d50a200544f5ea04ba680c68d2587812284d" => :yosemite
    sha256 "f2feda18417156d7ebc03750267caa85a8375605eaa7b0941e7c7b3771379cbb" => :mavericks
    sha256 "92e6dbda5b7992577f565da669cfc5beb5a0fb14b37fc9b22a8c17279a189bd6" => :mountain_lion
    sha256 "eb1dc168c45987e1dc3144d992103e334a76032041c746dba8baecfc96aafc5b" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "trimadap-mt"
    doc.install "README.md", "illumina.txt", "test.fa"
  end

  test do
    assert_match "ACGT", shell_output("#{bin}/trimadap-mt /dev/null 2>&1")
  end
end
