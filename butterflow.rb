class Butterflow < Formula
  desc "Makes fluid slowmo and motion interpolated videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow/butterflow-0.2.0.tar.gz"
  sha256 "dc70927d78193543b4b364573e0cf2d0881a54483aa306db51cd9f57cf23781e"
  revision 1

  bottle do
    cellar :any
    sha256 "c3424c90e217cee45c461747545da5a4999967bbfed7f977312808ed7f6c79db" => :yosemite
    sha256 "0b5be6c1f6ff5df7659b213ba250784bfd53d4f1ef5c4fa03f5221c21497a80b" => :mavericks
  end

  # To satisfy OpenCL 1.2 requirement
  depends_on :macos => :mavericks

  depends_on "ffmpeg"
  depends_on "opencv" => ["with-ffmpeg", "with-opengl"]

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
