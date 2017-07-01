class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.17.06.14.tar.gz"
  sha256 "6179a92bbe1893b7c5b1dff7c8eaba277c194870d17039addf2d389cbb68b87e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6df8c8b68234bb7ebc405c7ba34cc5d400b74329ecdc580e7cd125e19e4d694" => :sierra
    sha256 "7dd7557890532f4093c435a4406bbd3118d4e4de5b479aa2f55d02e4ba2ee6fc" => :el_capitan
    sha256 "9eb0209aa36e683c9a7fecca1dfdba7a5980e3d8b0647ba78764725ab8768740" => :yosemite
  end

  def install
    system "make"
    bin.install "clinfo"
    man1.install "man/clinfo.1"
  end

  test do
    output = shell_output bin/"clinfo"
    assert_match /Device Type +CPU/, output
  end
end
