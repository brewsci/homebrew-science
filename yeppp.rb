class Yeppp < Formula
  homepage "http://www.yeppp.info"
  url "http://bitbucket.org/MDukhan/yeppp/downloads/yeppp-1.0.0.tar.bz2"
  sha256 "042ea66e729969d0e9a532d99c62739f1cdf7bcfbead9cfd2ef2eedd038d4c3d"

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
    (share/"yeppp").install "examples"
  end

  test do
    Dir["#{share}/yeppp/examples/c/binaries/x64-macosx-sysv-default/*"].each do |x|
      system x
    end
  end
end
