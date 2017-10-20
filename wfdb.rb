class Wfdb < Formula
  desc "Software library for working with physiologic signals"
  homepage "https://physionet.org/physiotools/"
  url "https://github.com/bemoody/wfdb/archive/10.5.24.tar.gz"
  sha256 "be3be34cd1c2c0eaaae56a9987de13f49a3c53bf1539ce7db58f885dc6e34b7b"
  head "https://github.com/bemoody/wfdb.git"

  bottle do
    rebuild 1
    sha256 "c33ed3f0cf3d7a1fd01e4906c29300657709231bdd8b036e01ec2c4bb7853716" => :yosemite
    sha256 "76a857947309a59644fef27374218e1e0f587412802f3f15c58550d70304a45c" => :mavericks
    sha256 "cb0b49a7d841be2c4600339aabb48ee02b605c77197d873b7054b794c0cd3c90" => :mountain_lion
  end

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

    pkgshare.install "examples", bin/"setwfdb", bin/"cshsetwfdb"

    # For some reason the configure script doesn't install the man pages properly
    # even though '--mandir' is used.
    share.install prefix/"man" if build.stable?
  end

  def caveats; <<-EOS.undent
    WFDB Example programs have been installed to:
      #{pkgshare}/examples
    EOS
  end

  test do
    cflags = `#{bin/"wfdb-config"} --cflags`.chomp
    libs = `#{bin/"wfdb-config"} --libs`.chomp
    system ENV.cc, cflags, "-o", "wfdbversion", pkgshare/"examples/wfdbversion.c", *libs.split
    system "./wfdbversion"
  end
end
