class Neuron < Formula
  homepage "http://www.neuron.yale.edu/neuron/"
  url "http://www.neuron.yale.edu/ftp/neuron/versions/v7.3/nrn-7.3.tar.gz"
  sha256 "71cff5962966c5cd5d685d90569598a17b4b579d342126b31e2d431128cc8832"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "1b48082098ae9a2691b575849c36419038f800c0fa21d90548e3befbf82de47b" => :yosemite
    sha256 "af20483fcc52a1fa9343eebca893dfb510b487243a76c345b8c74e8eaaac22d5" => :mavericks
    sha256 "93b83c24f246f6b574838563e20e5efeb729edfe163866a132490fb22a5e8340" => :mountain_lion
  end

  depends_on "inter-views"
  depends_on :mpi => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  # NEURON uses .la files to compile HOC files at runtime
  skip_clean :la

  # 1. The build fails (for both gcc and clang) when trying to build
  #    src/mac/mac2uxarg.c, which uses Carbon.
  #    According to the lead developer, Carbon is not available for 64-bit
  #    machines, and is an "ancient launcher helper", so we remove it,
  #    as was suggested in this forum thread:
  #       http://www.neuron.yale.edu/phpbb/viewtopic.php?f=4&t=3254
  # 2. The build assumes InterViews kept .la files around. It doesn't,
  #    so we link directly to the .dylib instead.
  patch :DATA

  def install
    dylib = OS.mac? ? "dylib" : "so"
    inreplace "configure", "$IV_LIBDIR/libIVhines.la", "$IV_LIBDIR/libIVhines.#{dylib}"

    args = ["--with-iv=#{Formula["inter-views"].opt_prefix}"]
    args << "--with-paranrn" if build.with? "mpi"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-pysetup=no",
                          "--with-nrnpython",
                          "--without-mpi",
                          "--prefix=#{prefix}",
                          "--exec-prefix=#{libexec}",
                          *args

    system "make"
    system "make", "check"
    system "make", "install"

    cd "src/nrnpython" do
      system "python", *Language::Python.setup_install_args(prefix)
    end

    # Neuron builds some .apps which are useless and in the wrong place
    ["idraw", "mknrndll", "modlunit",
     "mos2nrn", "neurondemo", "nrngui"].each do |app|
      rm_rf "#{prefix}/../#{app}.app"
    end

    ln_sf Dir["#{libexec}/lib/*.dylib"], lib
    ln_sf Dir["#{libexec}/lib/*.so.*"], lib
    ln_sf Dir["#{libexec}/lib/*.so"], lib
    ln_sf Dir["#{libexec}/lib/*.la"], lib
    ln_sf Dir["#{libexec}/lib/*.o"], lib

    ["hoc_ed", "ivoc", "modlunit", "mos2nrn", "neurondemo",
     "nocmodl", "nrngui", "nrniv", "nrnivmodl", "sortspike"].each do |exe|
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
    system "#{bin}/nrniv", "--version"
    system "python", "-c", "import neuron; neuron.test()"
  end
end

__END__
diff --git i/src/mac/Makefile.in w/src/mac/Makefile.in
index cecf310..7618ee0 100644
--- i/src/mac/Makefile.in
+++ w/src/mac/Makefile.in
@@ -613,17 +613,6 @@ uninstall-am: uninstall-binSCRIPTS
	uninstall-am uninstall-binSCRIPTS

 @MAC_DARWIN_TRUE@install: install-am
-@MAC_DARWIN_TRUE@@UniversalMacBinary_TRUE@	$(CC) -arch ppc -o aoutppc -Dcpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-@MAC_DARWIN_TRUE@@UniversalMacBinary_TRUE@	$(CC) -arch i386 -o aouti386 -Dcpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-@MAC_DARWIN_TRUE@@UniversalMacBinary_TRUE@	lipo aouti386 aoutppc -create -output a.out
-@MAC_DARWIN_TRUE@@UniversalMacBinary_FALSE@	gcc -g -arch i386 -Dncpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-
-@MAC_DARWIN_TRUE@	carbon=$(carbon) sh $(srcdir)/launch_inst.sh "$(host_cpu)" "$(DESTDIR)$(prefix)" "$(srcdir)"
-@MAC_DARWIN_TRUE@	for i in $(S) ; do \
-@MAC_DARWIN_TRUE@		sed "s/^CPU.*/CPU=\"$(host_cpu)\"/" < $(DESTDIR)$(bindir)/$$i > temp; \
-@MAC_DARWIN_TRUE@		mv temp $(DESTDIR)$(bindir)/$$i; \
-@MAC_DARWIN_TRUE@		chmod 755 $(DESTDIR)$(bindir)/$$i; \
-@MAC_DARWIN_TRUE@	done

 # Tell versions [3.59,3.63) of GNU make to not export all variables.
 # Otherwise a system limit (for SysV at least) may be exceeded.
