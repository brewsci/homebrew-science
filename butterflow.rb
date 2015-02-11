class Butterflow < Formula
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow-0.1.5.tar.gz"
  sha1 "38930e674e0c7fb5b035022c3ae7703a48ca962b"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "948cf40377bae48c0d96d9203244bd86d1c2bfad" => :yosemite
    sha1 "fbeea3de4462fc323c4145c92f00683f5150f09b" => :mavericks
  end

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
