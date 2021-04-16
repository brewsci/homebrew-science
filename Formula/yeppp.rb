class Yeppp < Formula
  homepage "http://www.yeppp.info"
  url "https://bitbucket.org/MDukhan/yeppp/downloads/yeppp-1.0.0.tar.bz2"
  sha256 "042ea66e729969d0e9a532d99c62739f1cdf7bcfbead9cfd2ef2eedd038d4c3d"
  revision 1

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, el_capitan: "dd36939c6d8c50aec543b70084f7dfda3ba9d82d538424af20ad537e5c785936"
    sha256 cellar: :any, yosemite:   "a859cb1831f8a7d105d21c288a74b86941833a6da3fec54b09b3304a8138080f"
    sha256 cellar: :any, mavericks:  "ed279698e594303995a64fbc84569e8aa377f881272bbdb5c938c203d90ba6fe"
  end

  def install
    # It's normally not recommended to build from source
    # though we may in the future.
    prefix.install "set-vars.sh"
    include.install Dir["library/headers/*.h"]
    lib.install Dir["binaries/macosx/x86_64/*"]
    libexec.install "bindings"
    doc.install Dir["docs/*"]

    # Build C examples.
    ENV["YEPPLATFORM"] = "x64-macosx-sysv-default"
    ENV.append "CFLAGS", "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    cd "examples/c" do
      system "make"
    end
    pkgshare.install "examples"
  end

  test do
    Dir["#{share}/yeppp/examples/c/binaries/x64-macosx-sysv-default/*"].each do |x|
      system x
    end
  end
end
