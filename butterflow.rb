class Butterflow < Formula
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow-0.1.8.tar.gz"
  sha256 "252580bb5d473a7e265cb5882102ab005eabc14e810a48b7032318875afe652d"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "2bb1cb4b3245102673a997bb3684b3791fd62d905dbb3b3544b82807a9ff6a17" => :yosemite
    sha256 "f0ea5d4602536f81655dcf652971ba806f5b77513a1c8e84f68a1c580b8c3757" => :mavericks
  end

  # To satisfy OpenCL 1.1 requirement
  depends_on :macos => :mavericks

  depends_on "pkg-config" => :build
  depends_on "ffmpeg" => ["with-libvorbis", "with-libass"]
  depends_on "opencv" => "with-ffmpeg"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/butterflow", "-d"
  end
end
