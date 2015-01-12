class Daligner < Formula
  homepage "https://github.com/thegenemyers/DALIGNER"
  #doi "10.1007/978-3-662-44753-6_5"
  #tag "bioinformatics"

  version "2015-01-09"
  url "https://github.com/thegenemyers/DALIGNER/archive/8edd180ba7b5302c6f1fc859eef5c646db99fd87.tar.gz"
  sha1 "790dc0e5b09716d3a66882efc74708ddfcea8e88"

  head "https://github.com/thegenemyers/DALIGNER.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "658f6bcdf275a4024b15bfafe6eb0391ee54c0a3" => :yosemite
    sha1 "3bfe5b57169b04c6a15bd9361fd6571096d77fe7" => :mavericks
    sha1 "473ce0f16f71dade9537264944e62e4791a2f322" => :mountain_lion
  end

  def install
    system "make"
    bin.install %w[daligner HPCdaligner HPCmapper LAcat LAcheck LAmerge LAshow LAsort LAsplit]
  end

  test do
    system "#{bin}/daligner 2>&1 |grep daligner"
  end
end
