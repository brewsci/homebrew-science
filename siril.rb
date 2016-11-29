class Siril < Formula
  desc "Astronomical image (pre-)processing application"
  homepage "http://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.5.tar.bz2"
  sha256 "8f25a8cb8dc1f2ca9da979161a51e6aacd4059674e21ee14edcc0f299e2a7924"
  head "https://free-astro.org/svn/siril/"

  bottle do
    sha256 "4c22c22e1bdf53270eeb62ea83fc953e9d51071bf0814ccafd8c39bfebbe5a52" => :sierra
    sha256 "b8ff15af7f8521a87e809ce53d655bb51fc9072bafef5bf3223d1eeaac4b66f4" => :el_capitan
    sha256 "f565dc9340c577eeb8647d821d9d0da0c986b60400ab5631300b3513f278c4d5" => :yosemite
  end

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
