class Butterflow < Formula
  desc "Makes fluid slowmo and motion interpolated videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow-0.1.9.tar.gz"
  sha256 "9f62960bb1a58c7fd7b67e7260d32a51e95ef5c7ff9f0811307463c1f1f338cf"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "e0ee3bd62ebb24352c28bf56dadc8ba955ab010e8bc704101569db7ed7a18a0c" => :yosemite
    sha256 "04b037d4595596e3731b5dc0824ee294ac1de6b65b7b520c4a2da97029c4c0cd" => :mavericks
  end

  # To satisfy OpenCL 1.1 requirement
  depends_on :macos => :mavericks

  depends_on "pkg-config" => :build
  depends_on "ffmpeg" => ["with-libvorbis", "with-libass"]
  depends_on "opencv" => "with-ffmpeg"

  def install
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
