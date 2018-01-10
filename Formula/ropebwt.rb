class Ropebwt < Formula
  homepage "https://github.com/lh3/ropebwt"
  url "https://github.com/lh3/ropebwt/archive/216c9f7.tar.gz"
  version "20130801"
  sha256 "4c740c37ea68a4264c041bc4d5b00538b6151cc0662ab779471e0b6a0fede062"
  head "https://github.com/lh3/ropebwt.git"

  def install
    system "make"
    bin.install *%w[bcr-demo bpr-mt ropebwt]
  end

  test do
    system "ropebwt 2>&1 |grep -q ropebwt"
  end
end
