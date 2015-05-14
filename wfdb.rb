class Wfdb < Formula
  desc "a software library for working with physiologic signals"
  homepage "http://physionet.org/physiotools/"
  url "https://github.com/bemoody/wfdb/archive/10.5.24.tar.gz"
  sha256 "be3be34cd1c2c0eaaae56a9987de13f49a3c53bf1539ce7db58f885dc6e34b7b"
  head "https://github.com/bemoody/wfdb.git"

  def install
    ENV.deparallelize

    if build.head?
      # We need to set the package version manually, otherwise the configure script will prompt user for it...
      # We'll take the version from the NEWS file:
      news_version = %q(`head -1 ../NEWS | awk '{printf "wfdb-%s", $1}'`)
      inreplace "configure", /^PACKAGE=`.*`$/, "PACKAGE=#{news_version}"
    end

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"

    # Force compilation, prevent "install up to date"
    system "sh", "-c", "echo '.PHONY: install' >> Makefile"

    system "make", "install"

    (share/"wfdb").install "examples", bin/"setwfdb", bin/"cshsetwfdb"

    # For some reason the configure script doesn't install the man pages properly
    # even though '--mandir' is used.
    share.install prefix/"man" if stable?
  end

  def caveats; <<-EOS.undent
    WFDB Example programs have been installed to:
      #{share}/wfdb/examples
    EOS
  end

  test do
    cflags = `#{bin/"wfdb-config"} --cflags`.chomp
    libs = `#{bin/"wfdb-config"} --libs`.chomp
    system ENV.cc, cflags, "-o", "wfdbversion", share/"wfdb/examples/wfdbversion.c", *libs.split
    system "./wfdbversion"
  end
end
