class Timbl < Formula
  desc "Memory-based learning algorithms"
  homepage "https://ilk.uvt.nl/timbl/"
  url "https://github.com/LanguageMachines/timbl/releases/download/v6.4.10/timbl-6.4.10.tar.gz"
  sha256 "c95ad52e78136840245e7732ec6403282894ecf187b18b49a8271f34520c2dcb"

  bottle do
    cellar :any
    sha256 "214e7accd71efb5a00c3e49a013c86364128c24849f6df261061dae470d3641a" => :high_sierra
    sha256 "87ccbd5562101e4b0ad2445f6879f98bfca2dbffee967ab983f92d96586a23b3" => :sierra
    sha256 "e760bffe1dab2a76c2600072b16d24e019005598ca435cbd01fbfa621617d7c3" => :el_capitan
    sha256 "ff87651babdda285e330764b07a595009bbcb2139927df5351f2491e1664a2f2" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "ticcutils"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
