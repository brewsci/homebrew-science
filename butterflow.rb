class Butterflow < Formula
  desc "Makes fluid slowmo and motion interpolated videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow/butterflow-0.2.0.tar.gz"
  sha256 "dc70927d78193543b4b364573e0cf2d0881a54483aa306db51cd9f57cf23781e"
  revision 1

  bottle do
    cellar :any
    sha256 "c9b17596c8c6cc5799d6e2e4ea37f3e501ef290dd04eb337ae85501363b268c4" => :el_capitan
    sha256 "c1a0a8299f083fef2a12b3e91b65bff252cd2110dae842622b02e0ba4df3dfd7" => :yosemite
    sha256 "f9a53d638183623253d06216cf9ffc858fbc35255c1afe956b9701b83398083e" => :mavericks
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
