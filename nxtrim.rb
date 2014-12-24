class Nxtrim < Formula
  homepage "https://github.com/sequencing/NxTrim"
  head "https://github.com/sequencing/NxTrim.git"
  #doi "10.1101/007666"
  #tag "bioinformatics"

  url "https://github.com/sequencing/NxTrim/archive/v0.3.0-alpha.tar.gz"
  version "0.3.0"
  sha1 "6502be8546b8d0ebc0120cc2791aefd26471e8a4"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "7a4bb42527550571a9ba7597a20dbf83174586cf" => :yosemite
    sha1 "37593e250fbde7b93bd107dec77e12cacb51cd11" => :mavericks
    sha1 "f9db6b90a23cab1befc9b317ea8f8de8ad799cb1" => :mountain_lion
  end

  depends_on "boost"

  def install
    system "make", "BOOST_ROOT=#{Formula["boost"].prefix}"
    bin.install "nxtrim", "mergeReads"
    doc.install "Changes", "LICENSE.txt", "README.md"
  end

  test do
    system "#{bin}/nxtrim -h |grep NxTrim"
  end
end
