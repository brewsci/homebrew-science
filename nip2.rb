class Nip2 < Formula
  desc "A GUI for the VIPS image processing system"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.2/nip2-8.2.tar.gz"
  sha256 "18151e2185eb9db60196d98354ef751eb55ea9d3b55ef090f4a039125d465fca"

  bottle do
    cellar :any
    sha256 "66ee4db4daa9331151ccda266527f0f34fc4ab3bc650bf6f6b8b2c735fa23798" => :yosemite
    sha256 "4f5b965c6fa470f39c46b870a1cfca5db9f4a37840873b1c17008b784ecbb646" => :mavericks
    sha256 "fd8632028e5e781aaac730defea585a2b78ff1afb1aaa14dde1df38851716db7" => :mountain_lion
  end

  option "with-check", "Enable build-time checking"

  depends_on "pkg-config" => :build
  depends_on "XML::Parser" => :perl
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "libxml2"
  depends_on "vips"

  depends_on "fftw" => :recommended
  depends_on "gsl" => :recommended
  depends_on "goffice" => :recommended
  depends_on "libgsf" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    # when first run, nip2 tries to create ~/Library/nip2-x.y.z
    # to hold temp files ... ~/Library is not present in homebrew's
    # private test home directory
    require "fileutils"
    mkdir_p ENV["HOME"] + "/Library"

    system "#{bin}/nip2", "--benchmark"
  end
end
