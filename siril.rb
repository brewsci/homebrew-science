class Siril < Formula
  desc "Astronomical image (pre-)processing application"
  homepage "http://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.4.tar.bz2"
  sha256 "3c90111faac63f2d0f17f1a05891ef9e97a2819e5073db2d26e8c3ab7072d91e"
  head "https://free-astro.org/svn/siril/"

  option "with-openmp", "Enable OpenMP multithreading"

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

  patch :DATA

  needs :openmp if build.with? "openmp"
  needs :cxx11 if build.with? "openmp"

  def install
    ENV.cxx11 if build.with? "openmp"

    system "intltoolize", "-f", "-c"
    system "autoreconf", "-fi", "-Wno-portability"
    args = ["--prefix=#{prefix}"]
    args << "--enable-openmp" if build.with? "openmp"
    system "./configure", *args
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
