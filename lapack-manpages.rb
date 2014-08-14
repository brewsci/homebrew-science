require "formula"

class LapackManpages < Formula
  homepage "http://netlib.org/lapack/"
  url "http://netlib.org/lapack/manpages.tgz"
  version "3.5.0"
  sha1 "fb5829fca324f7a2053409b370d58e60f3aa4e6e"

  def install
    man3.install Dir["#{buildpath}/man3/*"]
  end
end
