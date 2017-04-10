class Butterflow < Formula
  desc "Makes motion interpolated and fluid slow motion videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow/releases/butterflow-0.2.3.tar.gz"
  sha256 "83e3ce52eef57ae2e4f4b3dc98d97ab354621e4a095d9734751bd876c34b755e"

  bottle do
    cellar :any
    sha256 "2976b91ae42f8c3f8a66829e236f1e8342a21e079a39446574383747792fbdf8" => :sierra
    sha256 "8963341697e99b066aa5b2f3f31f23328f33835bc14ce4f765d31b77f59cd866" => :el_capitan
    sha256 "acde10bce6ea15c27db27bdc59a366eb7922466f512a25d04bb32e073f5f9ada" => :yosemite
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
