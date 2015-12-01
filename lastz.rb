class Lastz < Formula
  homepage "http://www.bx.psu.edu/~rsharris/lastz/"
  url "http://www.bx.psu.edu/miller_lab/dist/lastz-1.02.00.tar.gz"
  sha256 "054515f27fdf9392f3d2e84ca421103b5e5575ba7a1979addf3c277212114a21"
  devel do
    url "http://www.bx.psu.edu/~rsharris/lastz/newer/lastz-1.03.34.tar.gz"
    sha256 "b831cfb7dabf85e2f9bf33a76641481ede0d18a941c3a72d57d373b018232fbf"
  end

  def install
    system "make definedForAll=-Wall"
    bin.install %w[src/lastz src/lastz_D]
  end

  test do
    system "lastz --help |grep -q lastz"
  end
end
