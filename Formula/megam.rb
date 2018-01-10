class Megam < Formula
  homepage "https://www.umiacs.umd.edu/~hal/megam/"
  url "http://eightnine.de/megam/megam-0.9.2.tgz"
  sha256 "dc0e9f59ff8513449fe3bd40b260141f89c88a4edf6ddc8b8a394c758e49724e"

  depends_on "ocaml"

  def install
    # Environment settings for Makefile to compile on MacOS
    ENV["WITHCLIBS"] = "-I #{Formula["objective-caml"].opt_lib}/ocaml/caml"
    ENV["WITHSTR"]   = "str.cma -cclib -lcamlstr"
    # Build the non-optimized version
    system "make", "-e"
    bin.install "megam"
    system "make", "clean"
    # Build the optimized version
    system "make", "-e", "opt"
    bin.install "megam.opt"
  end

  test do
    (testpath/"tiny.megam").write <<-EOS.undent
      0    F1 F2 F3
      1    F2 F3 F8
      0    F1 F2
      1    F8 F9 F10
    EOS
    system bin/"megam", "binary", "tiny.megam"
    system bin/"megam.opt", "binary", "tiny.megam"
  end
end
