class Butterflow < Formula
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow-0.1.5.tar.gz"
  sha1 "38930e674e0c7fb5b035022c3ae7703a48ca962b"

  # To satisfy OpenCL 1.1 requirement
  depends_on :macos => :mavericks

  depends_on "pkg-config" => :build
  depends_on "ffmpeg" => ["with-libvorbis", "with-libass"]
  depends_on "homebrew/science/opencv" => "with-ffmpeg"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    Language::Python.setup_install "python", libexec
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/butterflow", "--version"
  end
end
