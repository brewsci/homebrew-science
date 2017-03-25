class Mothur < Formula
  desc "16s analysis software"
  homepage "https://www.mothur.org/"
  url "https://github.com/mothur/mothur/archive/v1.39.5.tar.gz"
  sha256 "9f1cd691e9631a2ab7647b19eb59cd21ea643f29b22cde73d7f343372dfee342"
  head "https://github.com/mothur/mothur.git"
  # tag "bioinformatics"
  # doi "10.1128/AEM.01541-09"

  bottle do
    sha256 "e36995d4192047ec7426e0e5c4861065f7c0d1a3bc5219c4f57b2d501f866ac7" => :sierra
    sha256 "366829a37a3bab6c743b96c4453dc10c72cd0824bab47f9f118e138eb56dc5b8" => :el_capitan
    sha256 "b0c33d37d6e78767afd43f4b847695d0d17cb58c8752300a01efbfc8da3bc595" => :yosemite
  end

  depends_on "boost"
  depends_on "readline" unless OS.mac?

  def install
    boost = Formula["boost"]
    inreplace "Makefile", '"\"Enter_your_boost_library_path_here\""', boost.opt_lib
    inreplace "Makefile", '"\"Enter_your_boost_include_path_here\""', boost.opt_include
    system "make"
    bin.install "mothur", "uchime"
  end

  test do
    system "#{bin}/mothur", "-h"
    system "#{bin}/uchime", "--help"
  end
end
