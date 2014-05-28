require 'formula'

class Root < Formula
  homepage 'http://root.cern.ch'
  url 'ftp://root.cern.ch/root/root_v5.34.18.source.tar.gz'
  mirror 'https://fossies.org/linux/misc/root_v5.34.18.source.tar.gz'
  version '5.34.18'
  sha1 'e24e9bf8b142f2780f6cec9503409d87e4b9f8da'
  head 'https://github.com/root-mirror/root.git', :branch => 'v5-34-00-patches'

  option 'with-qt', "Build with Qt graphics backend and GSI's Qt integration"
  depends_on 'xrootd' => :recommended
  depends_on 'fftw' => :optional
  depends_on 'qt' => [:optional, 'with-qt3support']
  depends_on :x11 => :optional
  depends_on :python

  if build.with? "x11"
    patch :p1, :DATA
  else
    unless build.head?
      patch :p1 do
        # https://sft.its.cern.ch/jira/browse/ROOT-6297
        url "https://gist.githubusercontent.com/veprbl/9ab33daa07b68c28671c/raw/31317dfa11eba19595207dc32851a1bb2d836b0a/gistfile1.txt"
        sha1 "6d8625fd63fce92976e27248e4ad3698741e7eba"
      end
    end
  end

  def install
    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    inreplace Dir['config/roots.in', 'config/thisroot.*sh',
                  'etc/proof/utils/pq2/setup-pq2',
                  'man/man1/setup-pq2.1', 'README/INSTALL', 'README/README'],
      /bin.thisroot/, 'libexec/thisroot'

    # Determine architecture
    arch = MacOS.prefer_64_bit? ? 'macosx64' : 'macosx'

    # N.B. that it is absolutely essential to specify
    # the --etcdir flag to the configure script.  This is
    # due to a long-known issue with ROOT where it will
    # not display any graphical components if the directory
    # is not specified:
    # http://root.cern.ch/phpBB3/viewtopic.php?f=3&t=15072
    args = %W[
      #{arch}
      --all
      --enable-builtin-glew
    ]

    if build.with? 'x11'
      args << "--disable-cocoa"
      args << "--enable-x11"
    end

    if build.with? 'qt'
      args << "--enable-qt"
      args << "--enable-qtgsi"
    end

    args += %W[
      --prefix=#{prefix}
      --etcdir=#{prefix}/etc/root
      --mandir=#{man}
    ]

    system "./configure", *args

    # ROOT configure script does not search for Qt framework
    if build.with? 'qt'
      inreplace "config/Makefile.config" do |s|
        s.gsub! /^QTLIBDIR .*/, "QTLIBDIR := -F #{Formula["qt"].opt_lib}"
        s.gsub! /^QTLIB .*/, "QTLIB := -framework QtCore -framework QtGui -framework Qt3Support"
      end
    end

    system "make"
    system "make install"

    # needed to run test suite
    prefix.install 'test'

    libexec.mkpath
    mv Dir["#{bin}/*.*sh"], libexec
  end

  def test
    system "make -C #{prefix}/test/ hsimple"
    system "#{prefix}/test/hsimple"
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For csh/tcsh users:
      source `brew --prefix root`/libexec/thisroot.csh
    For bash/zsh users:
      . $(brew --prefix root)/libexec/thisroot.sh
    EOS
  end
end

__END__
# Consider removing this once
# /opt/X11/bin/freetype-config --ftversion
# is reporting version >=2.5.1
--- a/graf2d/freetype/Module.mk
+++ b/graf2d/freetype/Module.mk
@@ -8,7 +8,7 @@
 ifneq ($(BUILTINFREETYPE),yes)
 
 FREETYPELIBF    := $(shell freetype-config --libs)
-FREETYPEINC     := $(shell freetype-config --cflags)
+FREETYPEINC     := $(subst -I,-isystem,$(shell freetype-config --cflags)) -Wp,-v
 FREETYPELIB     := $(filter -l%,$(FREETYPELIBF))
 FREETYPELDFLAGS := $(filter-out -l%,$(FREETYPELIBF))
 FREETYPEDEP     :=
