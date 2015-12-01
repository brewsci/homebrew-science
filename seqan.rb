class Seqan < Formula
  homepage "http://www.seqan.de/"
  # doi "10.1186/1471-2105-9-11"
  # tag "bioinformatics"

  url "http://packages.seqan.de/seqan-library/seqan-library-1.4.2.tar.bz2"
  sha256 "77fb437c6f17d41ec41ce0a3bcc3533f91a3482ca63a3a55400e14cb73e64317"

  bottle do
    cellar :any
    sha256 "8a50bc2fa2e67c89d5c2c814704f220f872f982c8a9f4a7a04d87c7d5e2d2d98" => :yosemite
    sha256 "9a9685648e15afb2b68faf5227d7891e3c5c190fe18cdfe7f3f10991e98e5a71" => :mavericks
    sha256 "a2d63a2ba6e9eb3a541fd6714bc504a810be5e134220d6444b1c6bd1fce39c1b" => :mountain_lion
  end

  devel do
    url "http://packages.seqan.de/seqan-library/seqan-library-2.0.0.tar.bz2"
    sha256 "c9827a5617b35d8b5f5d10701f3ff064f2e89535ebbe3318758a2db99d15e8b8"
  end

  head "http://svn.seqan.de/seqan/trunk/core"

  def install
    include.install "include/seqan"
    doc.install Dir["share/doc/seqan/*"] unless build.head?
  end
end
