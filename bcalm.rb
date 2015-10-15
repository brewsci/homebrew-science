class Bcalm < Formula
  desc "de Bruijn CompAction in Low Memory"
  homepage "https://github.com/Malfoy/bcalm"
  # doi "10.1007/978-3-319-05269-4_4"
  # tag "bioinformatics"

  url "https://github.com/Malfoy/bcalm/archive/2.tar.gz"
  sha256 "dc50883d2b24bcd13abbc731211ea28f0eef4bd45a91bb24c0641b1ece80c9ce"

  head "https://github.com/Malfoy/bcalm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "275e8b52ba361c7b709bea9ad8d321cd72c3771d76fabe86054cea9c7dfbf9a9" => :el_capitan
    sha256 "6850356f860b9e9a52f97303b64fa8d63c32d9448df7961ccce17decbd383c8a" => :yosemite
    sha256 "35e0e2996bb345741d4c74165664df68e10507d9b007afd41e5a886a08f845ce" => :mavericks
  end

  def install
    ENV.libcxx
    system "make"
    bin.install "bcalm"
    doc.install "README.md"
  end
end
