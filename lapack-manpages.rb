class LapackManpages < Formula
  homepage "http://netlib.org/lapack/"
  url "http://netlib.org/lapack/manpages.tgz"
  version "3.5.0"
  sha256 "055da7402ea807cc16f6c50b71ac63d290f83a5f2885aa9f679b7ad11dd8903d"

  def install
    man3.install Dir["#{buildpath}/man3/*"]
  end
end
