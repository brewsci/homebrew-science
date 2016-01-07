class Numdiff < Formula
  desc "Putative files comparison tool"
  homepage "http://www.nongnu.org/numdiff"
  url "http://mirror6.layerjet.com/nongnu//numdiff/numdiff-5.8.1.tar.gz"
  sha256 "99aebaadf63325f5658411c09c6dde60d2990c5f9a24a51a6851cb574a4af503"

  # we need libintl.h which is normally a part of libc6-dev
  # but within Homebrew can be found in gettext
  depends_on "gettext"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["gettext"].include}"
    ENV.append "LDFLAGS",  "-L#{Formula["gettext"].lib} -lintl"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"numdiff", "--version"
  end
end
