class Siril < Formula
  desc "Astronomical image (pre-)processing application"
  homepage "http://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.5.tar.bz2"
  sha256 "8f25a8cb8dc1f2ca9da979161a51e6aacd4059674e21ee14edcc0f299e2a7924"
  revision 1
  head "https://free-astro.org/svn/siril/"

  bottle do
    sha256 "a2de16e5191b457c69493ac84963f4301f383117f04e7f7943cb52f9e553e4ca" => :sierra
    sha256 "3f0fef32acdec35de10120181f1a1b4ad5914c16c555837da35ce65623311c39" => :el_capitan
    sha256 "2d4cc1fb421d28ba184f23243945b436e0d18aede08cd8428825e058bc7a9d7a" => :yosemite
  end

  option "without-openmp", "Disable OpenMP"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "gtk-mac-integration"
  depends_on "llvm"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gnome-icon-theme"
  depends_on "openjpeg"
  depends_on "cfitsio"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "gsl"
  depends_on "opencv"

  if build.with? "openmp"
    depends_on "gcc"
    needs :openmp
    needs :cxx11
  end

  patch :DATA

  def install
    ENV.cxx11 if build.with? "openmp"

    args = ["--prefix=#{prefix}"]
    args << "--enable-openmp" if build.with? "openmp"
    system "./autogen.sh", *args
    system "make", "install"
    bin.install "src/siril"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end

__END__
--- a/src/io/avi_pipp/pipp_avi_write.h
+++ b/src/io/avi_pipp/pipp_avi_write.h
@@ -221,7 +221,6 @@
         int32_t m_bytes_per_pixel;
         int64_t m_last_frame_pos;
         int64_t m_riff_start_position;
-        std::string m_error_string;
         bool m_file_write_error;

         c_pipp_buffer m_temp_buffer;
