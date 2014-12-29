require "formula"

class Fastqc < Formula
  homepage "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  #tag "bioinformatics"

  url "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.2.zip"
  sha1 "d4dc1b903de35aa4de8e995c4974e0869db99dda"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "fdd145443d6034ea7771f0029ac303e6525ce68b" => :yosemite
    sha1 "705413545eeab36baf99ad66863882c91a2bccb9" => :mavericks
    sha1 "0c78a464a90f35496d758023665d173f00f5b857" => :mountain_lion
  end

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
