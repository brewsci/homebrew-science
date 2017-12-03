class Neuron < Formula
  desc "Simulation environment for modeling individual neurons and networks of neurons"
  homepage "https://www.neuron.yale.edu/neuron/"
  # NB: The Neuron authors are old-school physicists and don't do point releases, so bug-fixes
  # are often pushed to download link of their latest version, which breaks the the SHA check of this
  # formula. This commit is the earliest version that builds on High Sierra.
  url "https://github.com/nrnhines/nrn/archive/e0950a19a722b661882d1609fe7748ec67b68ba8.tar.gz"
  version "7.5"
  # url "https://www.neuron.yale.edu/ftp/neuron/versions/v7.5/nrn-7.5.tar.gz"
  sha256 "1d5510033c35654edde04ad89dbb9568a4a7c50770018e7f2e1ca4cf167e6e2c"
  head "http://github.com/nrnhines/nrn", :using => :git

  bottle do
    rebuild 1
    sha256 "2e045ddbbd13cce16acb6c0d8c9f8878982d69034944ddc2456445ba09d17375" => :high_sierra
    sha256 "1f838029eb4bbc150c0320254c8c18ad2f4c085901ae55b05328e1e4e3f9cde1" => :sierra
    sha256 "099fabcff6ea468ca73f0d6c006cc5be756499d1cbc90f26281d2d3cdc0eb2a2" => :el_capitan
    sha256 "0b4214ac066e1e9f93dfdbc1282bba83c9fb87cc4f8878482d12fa5e27dc02b8" => :x86_64_linux
  end

  # Autotools goodies required to build Neuron from scratch
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "flex" => :build
  depends_on "bison" => :build

  # Dependencies of the simulator itself
  depends_on "inter-views" => :optional
  depends_on :mpi => :optional
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  # NEURON uses .la files to compile HOC files at runtime
  skip_clean :la

  # 1. The build fails (for both gcc and clang) when trying to build
  #    src/mac/mac2uxarg.c, which uses Carbon.
  #    According to the lead developer, Carbon is not available for 64-bit
  #    machines, and is an "ancient launcher helper", so we remove it,
  #    as was suggested in this forum thread:
  #       https://www.neuron.yale.edu/phpBB/viewtopic.php?f=4&t=3254
  # 2. The build assumes InterViews kept .la files around. It doesn't,
  #    so we link directly to the .dylib instead.
  patch :DATA

  def install
    args = []
    args << "--with-paranrn" if build.with? "mpi"
    if build.with? "python3"
      args << "--with-nrnpython=python3"
      python_exec = "python3"
    else
      args << "--with-nrnpython"
      python_exec = "python"
    end

    if build.with? "inter-views"
      args << "--with-iv=#{Formula["inter-views"].opt_prefix}"
    else
      args << "--without-x"
      args << "--disable-rx3d"
    end

    # NB: autotools need to be run if building from a GitHub commit.
    # Comment out if downloading from the released version on the NEURON
    # downloads page "https://www.neuron.yale.edu/ftp/neuron/versions/"
    # You will also need to change the patch below to point to the Makefile.in
    # instead of the Makefile.am.
    system "./build.sh"

    # Needs to come after ./build.sh call
    dylib = OS.mac? ? "dylib" : "so"
    inreplace "configure", "$IV_LIBDIR/libIVhines.la", "$IV_LIBDIR/libIVhines.#{dylib}"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-pysetup=no",
                          "--without-mpi",
                          "--prefix=#{prefix}",
                          "--exec-prefix=#{libexec}",
                          *args

    system "make"
    system "make", "check"
    system "make", "install"

    cd "src/nrnpython" do
      system python_exec, *Language::Python.setup_install_args(prefix)
    end

    # Neuron builds some .apps which are useless and in the wrong place
    %w[idraw mknrndll modlunit mos2nrn neurondemo nrngui].each do |app|
      rm_rf "#{prefix}/../#{app}.app"
    end

    ln_sf Dir["#{libexec}/lib/*.dylib"], lib
    ln_sf Dir["#{libexec}/lib/*.so.*"], lib
    ln_sf Dir["#{libexec}/lib/*.so"], lib
    ln_sf Dir["#{libexec}/lib/*.la"], lib
    ln_sf Dir["#{libexec}/lib/*.o"], lib

    %w[hoc_ed ivoc modlunit mos2nrn neurondemo
       nocmodl nrngui nrniv nrnivmodl sortspike].each do |exe|
      bin.install_symlink "#{libexec}/bin/#{exe}"
    end
  end

  def caveats; <<-EOS.undent
    NEURON recommends that you set an X11 option that raises the window
    under the mouse cursor on mouseover. If you don't set this option,
    NEURON's GUI will still work, but you will have to click in each window
    before you can interact with the widgets in that window.

    To raise the window on mouse hover, execute:
        defaults write org.macosforge.xquartz.X11 wm_ffm -bool true
    To revert this behavior, execute:
        defaults write org.macosforge.xquartz.X11 wm_ffm -bool false
    EOS
  end

  test do
    if build.with? "python3"
      python_exec = "python3"
    else
      python_exec = "python"
    end
    system "#{bin}/nrniv", "--version"
    system python_exec, "-c", "import neuron; neuron.h.Section()"
  end
end

__END__
diff --git a/src/mac/Makefile.am b/src/mac/Makefile.am
index a612653..76d9389 100755
--- a/src/mac/Makefile.am
+++ b/src/mac/Makefile.am
@@ -14,22 +14,3 @@ EXTRA_DIST = maccmd.c njconf.h nrnneosm.h bbsconf.h macnrn.h nrnconf.h \

 host_cpu = @host_cpu@

-if MAC_DARWIN
-carbon = @enable_carbon@
-bin_SCRIPTS = $(launch_scripts)
-install: install-am
-if UniversalMacBinary
-	$(CC) -arch ppc -o aoutppc -Dcpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-	$(CC) -arch i386 -o aouti386 -Dcpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-	lipo aouti386 aoutppc -create -output a.out
-else
-	gcc -g -arch i386 -Dncpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-
-endif
-	carbon=$(carbon) sh $(srcdir)/launch_inst.sh "$(host_cpu)" "$(DESTDIR)$(prefix)" "$(srcdir)"
-	for i in $(S) ; do \
-		sed "s/^CPU.*/CPU=\"$(host_cpu)\"/" < $(DESTDIR)$(bindir)/$$i > temp; \
-		mv temp $(DESTDIR)$(bindir)/$$i; \
-		chmod 755 $(DESTDIR)$(bindir)/$$i; \
-	done
-endif
