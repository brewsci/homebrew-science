class Numdiff < Formula
  desc "Putative files comparison tool"
  homepage "http://www.nongnu.org/numdiff"
  url "http://mirror6.layerjet.com/nongnu//numdiff/numdiff-5.8.1.tar.gz"
  sha256 "99aebaadf63325f5658411c09c6dde60d2990c5f9a24a51a6851cb574a4af503"

  bottle do
    sha256 "8e42bfad74953a612e1ab9452a27c61e497d51ee771dc8a31ebfd8b16af24720" => :el_capitan
    sha256 "f66519d5d12c5c73b8d9b7bfd0e858b9913d4d535360ef1dca7016eb66e35448" => :yosemite
    sha256 "a9125d3a5e5fd61b96378bbb1be83425800fc9617baed6a5d155d63b920d89ae" => :mavericks
  end

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
