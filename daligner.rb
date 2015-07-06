class Daligner < Formula
  desc "DALIGNER: Find all significant local alignments between reads"
  homepage "https://github.com/thegenemyers/DALIGNER"
  # doi "10.1007/978-3-662-44753-6_5"
  # tag "bioinformatics"

  url "https://github.com/thegenemyers/DALIGNER/archive/V1.0.tar.gz"
  sha256 "2fb03616f0d60df767fbba7c8f0021ec940c8d822ab2011cf58bd56a8b9fb414"

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
    doc.install "README"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/daligner 2>&1", 1)
  end
end
