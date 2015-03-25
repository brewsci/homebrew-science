class Fastqc < Formula
  homepage "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  # tag "bioinformatics"

  url "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.3.zip"
  sha256 "ed2e8e6793bcedbd749d65a38dd8419be841e4653319e5fdd1e0e2b063b60ffb"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "fdd145443d6034ea7771f0029ac303e6525ce68b" => :yosemite
    sha1 "705413545eeab36baf99ad66863882c91a2bccb9" => :mavericks
    sha1 "0c78a464a90f35496d758023665d173f00f5b857" => :mountain_lion
  end

  depends_on :java

  def install
    chmod 0755, "fastqc"
    prefix.install Dir["*"]
    mkdir_p bin
    ln_s prefix/"fastqc", bin/"fastqc"
  end

  test do
    system "fastqc", "-h"
  end
end
