class Yeppp < Formula
  homepage "http://www.yeppp.info"
  url "http://bitbucket.org/MDukhan/yeppp/downloads/yeppp-1.0.0.tar.bz2"
  sha256 "042ea66e729969d0e9a532d99c62739f1cdf7bcfbead9cfd2ef2eedd038d4c3d"

  bottle do
    cellar :any
    sha256 "cfd2d005fb6bc917410e086137f7b08a80a68704b0dc053b7f287bf834b21988" => :yosemite
    sha256 "c0c5f3b268347af7b6b8a67465dd8be2839f28ca0b8a20c6f7d9be0bef28e154" => :mavericks
    sha256 "0304849b6b53aef237d18c6c21dfa31632e5d7a2c1a7bbe2f0feda653233315a" => :mountain_lion
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
