class Butterflow < Formula
  desc "Makes motion interpolated and fluid slow motion videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow/releases/butterflow-0.2.3.tar.gz"
  sha256 "83e3ce52eef57ae2e4f4b3dc98d97ab354621e4a095d9734751bd876c34b755e"

  bottle do
    cellar :any
    sha256 "b8b9dee4f0112c37cf3394f0342adfe30d25fff9e8fcb8f42b4bebe3cb75ac06" => :sierra
    sha256 "4c645b300030bd0098d52e567cf91cf21d8c91d3e89fe8ef18dc27c6fd82512b" => :el_capitan
    sha256 "3e1611b5d0af1f29c83bb16a1884cac9281080e05294ab5df2bf3d547b42f577" => :yosemite
  end

  # To satisfy OpenCL 1.2 requirement
  depends_on :macos => :mavericks

  depends_on "ffmpeg"
  depends_on "opencv" => ["with-ffmpeg"]

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_lib/"python2.7/site-packages"
    ENV.prepend_path "PYTHONPATH", Formula["opencv"].opt_lib/"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/butterflow", "-d"
  end
end
