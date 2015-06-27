class Butterflow < Formula
  desc "Makes fluid slowmo and motion interpolated videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow-0.1.9.tar.gz"
  sha256 "9f62960bb1a58c7fd7b67e7260d32a51e95ef5c7ff9f0811307463c1f1f338cf"

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
