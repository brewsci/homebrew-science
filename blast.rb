class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "http://blast.ncbi.nlm.nih.gov/"
  # doi "10.1016/S0022-2836(05)80360-2"
  # tag "bioinformatics"

  url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-src.tar.gz"
  mirror "http://mirrors.vbi.vt.edu/mirrors/ftp.ncbi.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-src.tar.gz"
  version "2.2.31"
  sha256 "f0960e8af2a6021fde6f2513381493641f687453a804239a7e598649b432f8a5"

  bottle do
    sha256 "66c5d14b4dc4b2d14b2088b78345a6eea5813fba084e5bac8bc7fe0639784e98" => :yosemite
    sha256 "f03007d42ed1286cdedd2f9dd4647f31e5f1c2463c575674b41172920c859bbe" => :mavericks
    sha256 "722ff4c4196cd81a3402734f141eb0131a1e8f1336431523b32d7108f3de260a" => :mountain_lion
  end

  # Fix configure: error: Do not know how to build MT-safe with compiler g++-5 5.1.0
  fails_with :gcc => "5"

  # Build failure reported to toolbox@ncbi.nlm.nih.gov on 11 May 2015,
  # patch provided by developers; should be included in next release
  patch :p0, :DATA

  option "without-static", "Build without static libraries & binaries"
  option "with-dll", "Build dynamic libraries"
  option "without-check", "Skip the self tests (Boost not needed)"

  depends_on "boost" if build.with? "check"
  depends_on "freetype" => :optional
  depends_on "gnutls"   => :optional
  depends_on "hdf5"     => :optional
  depends_on "jpeg"     => :recommended
  depends_on "libpng"   => :recommended
  depends_on "lzo"      => :optional
  depends_on "pcre"     => :recommended
  depends_on :mysql     => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Fix error:
    # /bin/sh: line 2: /usr/bin/basename: No such file or directory
    # See http://www.ncbi.nlm.nih.gov/viewvc/v1?view=revision&revision=65204
    inreplace "c++/src/build-system/Makefile.in.top", "/usr/bin/basename", "basename"

    # Move libraries to libexec. Libraries and headers conflict with ncbi-c++-toolkit.
    args = %W[--prefix=#{prefix} --libdir=#{libexec} --without-debug --with-mt]

    args << (build.with?("mysql") ? "--with-mysql" : "--without-mysql")
    args << (build.with?("freetype") ? "--with-freetype=#{Formula["freetype"].opt_prefix}" : "--without-freetype")
    args << (build.with?("gnutls") ? "--with-gnutls=#{Formula["gnutls"].opt_prefix}" : "--without-gnutls")
    args << (build.with?("jpeg")   ? "--with-jpeg=#{Formula["jpeg"].opt_prefix}" : "--without-jpeg")
    args << (build.with?("libpng") ? "--with-png=#{Formula["libpng"].opt_prefix}" : "--without-png")
    args << (build.with?("pcre")   ? "--with-pcre=#{Formula["pcre"].opt_prefix}" : "--without-pcre")
    args << (build.with?("hdf5")   ? "--with-hdf5=#{Formula["hdf5"].opt_prefix}" : "--without-hdf5")

    if build.without? "static"
      args << "--with-dll" << "--without-static" << "--without-static-exe"
    else
      args << "--with-static"
      args << "--with-static-exe" unless OS.linux?
      args << "--with-dll" if build.with? "dll"
    end

    # Boost is used only for unit tests.
    args << (build.with?("check") ? "--with-check" : "--without-boost")

    cd "c++" do
      system "./configure", *args
      system "make"
      system "make", "install"

      # Remove headers. Libraries and headers conflict with ncbi-c++-toolkit.
      rm_r include
    end
  end

  def caveats; <<-EOS.undent
    Using the option '--without-static' will create dynamic binaries instead of
    static. The NCBI Blast static installation is approximately 7 times larger
    than the dynamic.

    Static binaries should be used for speed if the executable requires
    fast startup time, such as if another program is frequently restarting
    the blast executables.
    EOS
  end

  test do
    system bin/"blastn", "-version"
  end
end

__END__
--- c++/include/corelib/ncbimtx.inl (revision 467211)
+++ c++/include/corelib/ncbimtx.inl (working copy)
@@ -388,7 +388,17 @@
     _ASSERT(m_Lock);

     m_ObjLock.Lock();
-    m_Listeners.remove(TRWLockHolder_ListenerWeakRef(listener));
+    // m_Listeners.remove(TRWLockHolder_ListenerWeakRef(listener));
+    // The above gives strange errors about invalid operands to operator==
+    // with the Apple Developer Tools release containing Xcode 6.3.1 and
+    // "Apple LLVM version 6.1.0 (clang-602.0.49) (based on LLVM 3.6.0svn)".
+    // The below workaround should be equivalent.
+    TRWLockHolder_ListenerWeakRef ref(listener);
+    TListenersList::iterator it;
+    while ((it = find(m_Listeners.begin(), m_Listeners.end(), ref))
+           != m_Listeners.end()) {
+        m_Listeners.erase(it);
+    }
     m_ObjLock.Unlock();
 }
