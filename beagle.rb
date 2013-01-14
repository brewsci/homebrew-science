require 'formula'

class NvidiaCudaRequirement < Requirement
  fatal true
	env :userpaths  # because nvcc has to be used

	def satisfied?
    # we have to assure the ENV is (almost) as during the build
    require 'superenv'
    ENV.setup_build_environment
    ENV.userpaths!
    which 'nvcc'
  end

  def message
    <<-EOS.undent
      To use this formula with NVIDIA graphics cards you will need to
      download and install the CUDA drivers and tools from nvidia.com.

          https://developer.nvidia.com/cuda-downloads

      Select "Mac OS" as the Operating System and then select the
      'Developer Drivers for MacOS' package.
      You will also need to download and install the 'CUDA Toolkit' package.

      The `nvcc` has to be in your PATH then (which is normally the case).

	EOS
  end
end

class Beagle < Formula
  homepage 'http://beagle-lib.googlecode.com/'
  head 'http://beagle-lib.googlecode.com/svn/trunk/'

  option 'with-cuda', 'Build with NVIDIA CUDA GPU drivers (see brew info beagle)'

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on :libtool
  depends_on NvidiaCudaRequirement.new if build.include? 'with-cuda'

  def patches
	DATA
  end

  def install
		system "./autogen.sh"

		args = "--prefix=#{prefix}"
		args << "--with-cuda=#{Pathname(which 'nvcc').dirname}" if build.include? 'with-cuda'
		# Help us!
		# If you want JNI bindings (Java), you need the JDK and we have to
		# pass --with-jdk=/path/to/jdk to configure

    system "./configure", *args
    system "make"
    system "make install"
    system "make check"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index eba488f..e7d7e36 100644
--- a/configure.ac
+++ b/configure.ac
@@ -64,7 +64,7 @@ AM_DISABLE_STATIC
 AC_PROG_LIBTOOL
 AM_PROG_LIBTOOL

-AM_CONFIG_HEADER(libhmsbeagle/config.h)
+AC_CONFIG_HEADERS(libhmsbeagle/config.h)

 # needed to support old automake versions
 AC_SUBST(abs_top_builddir)
