class Butterflow < Formula
  desc "Makes motion interpolated and fluid slow motion videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow/releases/butterflow-0.2.3.tar.gz"
  sha256 "83e3ce52eef57ae2e4f4b3dc98d97ab354621e4a095d9734751bd876c34b755e"
  revision 1

  bottle do
    sha256 cellar: :any, sierra:     "d8a9575b6f6f82dd97fbcbef7decbfe506662c16b0f241cf7d949b7b5a5e4102"
    sha256 cellar: :any, el_capitan: "cdba4c5a27de847adaf9057b538a858aebe6ebd9a3cf8c084a2444a8d04dd52c"
    sha256 cellar: :any, yosemite:   "04bad6a26382651b922394d2145914d2aa882e1daaf42b9b174e92fd276290e8"
  end

  depends_on "opencv@2"

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_lib/"python2.7/site-packages"
    ENV.prepend_path "PYTHONPATH", Formula["opencv@2"].opt_lib/"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/butterflow", "-d"
  end
end
