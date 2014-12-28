require 'formula'

class Pocl < Formula
  homepage 'http://pocl.sourceforge.net'
  url 'http://pocl.sourceforge.net/downloads/pocl-0.10.tar.gz'
  sha1 'd1fb03637059b5098d61c4772a1dd7cc104a9276'

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on 'pkg-config' => :build
  depends_on 'hwloc'

  if OS.linux? or MacOS::CLT.version >= "6.0"
    depends_on 'llvm' => ['with-clang', 'rtti']
  else
    depends_on 'homebrew/versions/llvm34'
  end

  depends_on "libtool" => :run
  depends_on "autoconf" => :build if build.with? "check"

  # Check if ndebug flag is required for compiling pocl didn't work on osx.
  # https://github.com/pocl/pocl/pull/65
  patch do
    url "https://github.com/pocl/pocl/commit/fa86bf.diff"
    sha1 "10f3a3cebce0003cab921c0a201b5e521882c2bc"
  end

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--enable-direct-linkage",
                          "--disable-icd",
                          "--enable-testsuites=",
                          "--prefix=#{prefix}"
    system "make", "prepare-examples" if build.with? "check"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
