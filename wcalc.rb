class Wcalc < Formula
  desc "Tool for the analysis and synthesis of transmission line structures."
  homepage "http://wcalc.sourceforge.net"
  url "https://downloads.sourceforge.net/project/wcalc/wcalc/wcalc-1.1/wcalc-1.1.tar.gz"
  sha256 "7f9a06a66560cd6b21358b964bb4378a2f6016a4ec0582f37ddbb20aded83b5e"

  depends_on :x11
  depends_on "gtk+"
  depends_on "gettext"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "cat <<< 'air_coil_calc 6 0.0127 1.2 22 1.72e-8 0.00635 100e6 0' | stdio-wcalc"
  end
end
