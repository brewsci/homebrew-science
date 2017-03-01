class Wcalc < Formula
  desc "Tool for the analysis and synthesis of transmission line structures."
  homepage "https://wcalc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/wcalc/wcalc/wcalc-1.1/wcalc-1.1.tar.gz"
  sha256 "7f9a06a66560cd6b21358b964bb4378a2f6016a4ec0582f37ddbb20aded83b5e"

  bottle do
    sha256 "e336524152627f7b3c4a81bbabe8e5d22fbdaa9faa6dae21aa00d94f6168df25" => :el_capitan
    sha256 "7875c9366bff5a46d4728e73cbfd40c27191e4517be2cf2b590f7db4ae0cf4be" => :yosemite
    sha256 "2c4b1887f6f365ee02a404c853e206cac436d3d02afcbacaae68ef43edc1cb56" => :mavericks
  end

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
