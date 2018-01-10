class Msieve < Formula
  desc "Factor large integers"
  homepage "https://sourceforge.net/projects/msieve/"
  url "https://downloads.sourceforge.net/project/msieve/msieve/Msieve%20v1.52/msieve152.tar.gz"
  sha256 "8a895544d316b8befe0e93a1fd7a1d508e8aa0f734035e2632aa4d928a2ef20b"

  bottle do
    cellar :any
    sha256 "69ba18e8bbdb68809801bb3b455b80a46365ff9be9f95991cd48a7a731f89506" => :el_capitan
    sha256 "6552b9142096eef4b37de4e0d9ad0a062a85f29bf36be73cbf88b0f89723d9db" => :yosemite
    sha256 "398a24bac441f50f6a9481e2ae464ecf37e441da3ad05d65d0a4758c87d4eaaf" => :mavericks
  end

  depends_on "gcc"

  def install
    system "make", "all"
    mkdir bin
    bin.install "msieve"
  end

  test do
    system "#{bin}/msieve", "-q", "12"
  end
end
