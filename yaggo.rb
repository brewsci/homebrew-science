class Yaggo < Formula
  homepage "https://github.com/gmarcais/yaggo"
  url "https://github.com/gmarcais/yaggo/archive/v1.5.4.tar.gz"
  sha1 "fc31de9ef3d0d0bdc2f01ebeea05b612bf1f7847"
  head "https://github.com/gmarcais/yaggo.git"

  def install
    system "make"
    bin.install "yaggo"
    doc.install "README.md"
  end

  test do
    system "#{bin}/yaggo", "--version"
  end
end
