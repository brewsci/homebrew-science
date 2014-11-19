require "formula"

class Numdiff < Formula
  homepage "http://www.nongnu.org/numdiff"
  url "http://mirror2.klaus-uwe.me/nongnu/numdiff/numdiff-5.8.1.tar.gz"
  sha1 "dae1fac5d2ba2e40b7713d6ef9647c94b572b4e1"

  # we need libintl.h which is normally a part of libc6-dev
  # but within Homebrew can be found in gettext
  depends_on "gettext"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula['gettext'].include}"
    ENV.append "LDFLAGS",  "-L#{Formula['gettext'].lib} -lintl"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"numdiff", "--version"
  end
end
