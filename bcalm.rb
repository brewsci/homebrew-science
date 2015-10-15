class Bcalm < Formula
  desc "de Bruijn CompAction in Low Memory"
  homepage "https://github.com/Malfoy/bcalm"
  # doi "10.1007/978-3-319-05269-4_4"
  # tag "bioinformatics"

  url "https://github.com/Malfoy/bcalm/archive/1.tar.gz"
  sha256 "1d9de0d0f4f7f41634a09135741432b681fd1e995934925442b409d47c19ecbf"

  head "https://github.com/Malfoy/bcalm.git"

  bottle do
    cellar :any
    sha256 "9643c4c2b921dd21cfbedd2225ae4f106e637578299fcfeb0bf98156228f4a46" => :yosemite
    sha256 "28f50d8f30f129a665e4f5064cc09b191a9d32b3f4373b07def55d859c922861" => :mavericks
    sha256 "bec10ae52ca743085f8129bf5524c204ee1014062bfa126b0dac108760d69cba" => :mountain_lion
  end

  def install
    ENV.libcxx
    system "make"
    bin.install "bcalm"
    doc.install "README.md"
  end
end
