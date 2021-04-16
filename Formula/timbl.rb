class Timbl < Formula
  desc "Memory-based learning algorithms"
  homepage "https://ilk.uvt.nl/timbl/"
  url "https://github.com/LanguageMachines/timbl/releases/download/v6.4.10/timbl-6.4.10.tar.gz"
  sha256 "c95ad52e78136840245e7732ec6403282894ecf187b18b49a8271f34520c2dcb"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, high_sierra:  "214e7accd71efb5a00c3e49a013c86364128c24849f6df261061dae470d3641a"
    sha256 cellar: :any, sierra:       "87ccbd5562101e4b0ad2445f6879f98bfca2dbffee967ab983f92d96586a23b3"
    sha256 cellar: :any, el_capitan:   "e760bffe1dab2a76c2600072b16d24e019005598ca435cbd01fbfa621617d7c3"
    sha256 cellar: :any, x86_64_linux: "ff87651babdda285e330764b07a595009bbcb2139927df5351f2491e1664a2f2"
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "ticcutils"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
