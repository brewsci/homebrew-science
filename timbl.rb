class Timbl < Formula
  desc "Memory-based learning algorithms"
  homepage "https://ilk.uvt.nl/timbl/"
  url "https://github.com/LanguageMachines/timbl/releases/download/v6.4.9/timbl-6.4.9.tar.gz"
  sha256 "02d58dc4a1b97cdd799541a597b6db5b4b8922614a02160a8c2d27c221db2f78"

  bottle do
    cellar :any
    sha256 "f96e343829eaa220579f120bbde601c6340400ffede6147774fc3eb10220eb14" => :el_capitan
    sha256 "bd9de88b4a642f4a31b5536b49f77a5dfa4401f7ad90a5a5fd83d90c42541930" => :yosemite
    sha256 "46c6b0f12e0d97088884abf54007b7ea70adff1a87038756a2285bc1a55e061e" => :mavericks
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
