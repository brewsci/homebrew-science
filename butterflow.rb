class Butterflow < Formula
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow-0.1.8.tar.gz"
  sha256 "252580bb5d473a7e265cb5882102ab005eabc14e810a48b7032318875afe652d"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "948cf40377bae48c0d96d9203244bd86d1c2bfad" => :yosemite
    sha1 "fbeea3de4462fc323c4145c92f00683f5150f09b" => :mavericks
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
