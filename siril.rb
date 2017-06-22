class Siril < Formula
  desc "Astronomical image (pre-)processing application"
  homepage "http://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.6.tar.bz2"
  sha256 "0622c885667396f1181f5c727ac1f8e3985560de817fec4400cd7d5ae6ed970f"
  revision 1
  head "https://free-astro.org/svn/siril/"

  bottle do
    sha256 "dd09b3a18cad1d92f3c7d00e978115f6c5c723d1557ad278c8c51c19341a1c5b" => :sierra
    sha256 "0d0eedf935d3e457628dcc3a815e8de5fae3c37ffac72dae813651e3aa6ed4ee" => :el_capitan
    sha256 "b7a03c4e8f7b533c52dc4b92a497b1197aaaf393d62c50b4c424f978a62cbb43" => :yosemite
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
  depends_on "gnuplot" => :optional

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
