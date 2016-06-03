class Daligner < Formula
  desc "DALIGNER: Find all significant local alignments between reads"
  homepage "https://github.com/thegenemyers/DALIGNER"
  # doi "10.1007/978-3-662-44753-6_5"
  # tag "bioinformatics"

  url "https://github.com/thegenemyers/DALIGNER/archive/V1.0.tar.gz"
  sha256 "2fb03616f0d60df767fbba7c8f0021ec940c8d822ab2011cf58bd56a8b9fb414"

  head "https://github.com/thegenemyers/DALIGNER.git"

  bottle do
    cellar :any
    sha256 "5be3c4c9da4b1e05921ced5fe07882012835dc83acf8dfc31f102985c17344f5" => :yosemite
    sha256 "3483a17210caff7a027dcf2fdb0b5610514a41285c4fe32cc2411f101856758b" => :mavericks
    sha256 "2599b9b12ddb85dded8c32f04b452bc1cd68313ae23527644cb9de25b4c6ecb9" => :mountain_lion
    sha256 "88c32023a74576cda100f29cbdeef83b64734b913b9f12729f099b2693b0011f" => :x86_64_linux
  end

  def install
    system "make"
    bin.install %w[daligner HPCdaligner HPCmapper LAcat LAcheck LAmerge LAshow LAsort LAsplit]
    doc.install "README"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/daligner 2>&1", 1)
  end
end
