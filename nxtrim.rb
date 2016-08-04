class Nxtrim < Formula
  desc "Trim adapters for Illumina Nextera Mate Pair libraries"
  homepage "https://github.com/sequencing/NxTrim"
  # doi "10.1101/007666"
  # tag "bioinformatics"
  revision 1

  url "https://github.com/sequencing/NxTrim/archive/v0.4.0.tar.gz"
  sha256 "aaa2dafefa1c0cca5966d8290eef758cfcca87426a2ba019506c4f38309161ea"
  head "https://github.com/sequencing/NxTrim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99cbd6c41735a519543d95a9bd28cb14e876b3aeefad714390dbbc97581450b7" => :el_capitan
    sha256 "a10e999c509236a139fcec9fb8517dc72656ef9f75d352e2ac010f255e46c065" => :yosemite
    sha256 "d52ca66367ad2d753cb4034575ac386ac83f5193d27012674f4f17af0122f488" => :mavericks
    sha256 "f0fa495301158007ce1a1a4ff25ea5a12927fa48d1f67da022e44b1f0389e9d2" => :x86_64_linux
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
