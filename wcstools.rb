class Wcstools < Formula
  desc "Tools for using World Coordinate Systems (WCS) in astronomical images"
  homepage "http://tdc-www.harvard.edu/wcstools/"
  url "http://tdc-www.harvard.edu/software/wcstools/wcstools-3.9.2.tar.gz"
  sha256 "481fe357cf755426fb8e25f4f890e827cce5de657a4e5044d4e31ce27bef1c8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e62507e22777515b183a1e9e311427033ac97d2db08b0f1c09937907f95bf4f4" => :el_capitan
    sha256 "70caab977d57e6b999a4242d381d1c1619b7ef2bde5da1317bc5f8672d322651" => :yosemite
    sha256 "f731758ecfb3fdf169be64b1db0c05ff16bb727aed01b76a6bdc20d2cb523890" => :mavericks
  end

  def install
    system "make", "-f", "Makefile.osx", "all"

    prefix.install "bin"
  end

  test do
    system "imhead 2>&1 | grep -q 'IMHEAD'"
  end
end
