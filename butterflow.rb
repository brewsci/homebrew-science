class Butterflow < Formula
  desc "Makes fluid slow motion and motion interpolated videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow/butterflow-0.2.1.tar.gz"
  sha256 "66cd8964854eae5b5b66b031e2f038d87a38c9052d19793820d55e1fe6338ffe"

  bottle do
    cellar :any
    sha256 "1c881f24932b1297bd1a0688e95a1378be35af0caaa5c466d8819ca1ed2b2797" => :el_capitan
    sha256 "285236c600d5ba279d86e99d58f3b51c1919d2cec4b7ccddea403de3dd812d7d" => :yosemite
    sha256 "1045fcdbe901d48b104163413a08b5092041b14b0249523dda553b48ba051bd0" => :mavericks
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
