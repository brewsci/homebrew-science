class Ucto < Formula
  desc "Unicode tokenizer"
  homepage "https://ilk.uvt.nl/ucto/"
  url "https://github.com/LanguageMachines/ucto/releases/download/v0.11/ucto-0.11.tar.gz"
  sha256 "f61f2465a1d1e79b964df7807a7957eba1cb4acc21c9cd74e91de662a8d192e8"

  bottle do
    sha256 "da154d4cd2648113d06fd505922a159f97f4b866ed34d1f4877ba907a2b22749" => :sierra
    sha256 "d7efe3bb35ac31bfdacd09bd4da7336d16cd970a83a58fa6399f56d28ba37779" => :el_capitan
    sha256 "ab8cbbcaff043acbebe4ca65f1aceab7acff12ecd2883491d2d93f394b6feb10" => :yosemite
    sha256 "d665537d8665a6b6d7c1e7ef18f2269bc25752988172295d0034b2370fd45af8" => :x86_64_linux
  end

  option "without-check", "skip build-time checks (not recommended)"

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libfolia"
  depends_on "libxslt"
  depends_on "libxml2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check" if build.with? "check"
  end
end
