class Nxtrim < Formula
  desc "Trim adapters for Illumina Nextera Mate Pair libraries"
  homepage "https://github.com/sequencing/NxTrim"
  # doi "10.1101/007666"
  # tag "bioinformatics"

  url "https://github.com/sequencing/NxTrim/archive/v0.4.0.tar.gz"
  sha256 "aaa2dafefa1c0cca5966d8290eef758cfcca87426a2ba019506c4f38309161ea"
  head "https://github.com/sequencing/NxTrim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ff85893ca6b912579bd0ca1cec049590ced304b4d64bac45c2fe16213f8e52d" => :el_capitan
    sha256 "ba16dd96bc704c65fa99bc19a00f124aca51f9cee8fb8ba3aff049c6fb70d265" => :yosemite
    sha256 "957d5b0449da272e80c329171f426ff3836dfae55144d76f6f3cf843b3174e72" => :mavericks
  end

  depends_on "boost"

  def install
    system "make", "BOOST_ROOT=#{Formula["boost"].prefix}"
    bin.install "nxtrim", "mergeReads"
    doc.install "Changelog", "LICENSE.txt", "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/nxtrim 2>&1")
  end
end
