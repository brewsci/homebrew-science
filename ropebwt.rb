require 'formula'

class Ropebwt < Formula
  homepage 'https://github.com/lh3/ropebwt'
  url 'https://github.com/lh3/ropebwt/archive/216c9f7.tar.gz'
  version '20130801'
  sha1 '82516c132fcf8dadb95426d8f394ee904478dab6'
  head 'https://github.com/lh3/ropebwt.git'

  def install
    system 'make'
    bin.install *%w[bcr-demo bpr-mt ropebwt]
  end

  test do
    system 'ropebwt 2>&1 |grep -q ropebwt'
  end
end
