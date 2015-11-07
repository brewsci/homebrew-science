class Msieve < Formula
  desc "Factor large integers"
  homepage "https://sourceforge.net/projects/msieve/"
  url "https://downloads.sourceforge.net/project/msieve/msieve/Msieve%20v1.52/msieve152.tar.gz"
  sha256 "8a895544d316b8befe0e93a1fd7a1d508e8aa0f734035e2632aa4d928a2ef20b"

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
