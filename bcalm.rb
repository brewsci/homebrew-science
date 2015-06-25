class Bcalm < Formula
  desc "de Bruijn CompAction in Low Memory"
  homepage "https://github.com/Malfoy/bcalm"
  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "9643c4c2b921dd21cfbedd2225ae4f106e637578299fcfeb0bf98156228f4a46" => :yosemite
    sha256 "28f50d8f30f129a665e4f5064cc09b191a9d32b3f4373b07def55d859c922861" => :mavericks
    sha256 "bec10ae52ca743085f8129bf5524c204ee1014062bfa126b0dac108760d69cba" => :mountain_lion
  end

  # tag "bioinformatics"

  url "https://github.com/Malfoy/bcalm/archive/1.tar.gz"
  sha256 "95901fbb748b7fc0fff26d3c638adc9f10343d21db5ca3ad0f71882d073a74de"

  head "https://github.com/Malfoy/bcalm.git"

  def install
    ENV.libcxx
    system "make"
    bin.install "bcalm"
    doc.install "README.md"
  end

  test do
    # Currently segfaults with no input file: https://github.com/Malfoy/bcalm/issues/1
    # No input file to test on yet: https://github.com/Malfoy/bcalm/issues/2
  end
end
