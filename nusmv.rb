class Nusmv < Formula
  homepage "http://nusmv.fbk.eu/"
  url "http://nusmv.fbk.eu/distrib/NuSMV-2.5.4.tar.gz"
  sha256 "3c250624cba801b1f62f50733f9507b0f3b3ca557ce1cd65956178eb273f1bdf"

  depends_on "wget"

  def install
    ENV.deparallelize
    system "make", "-C", "cudd-2.4.1.1", "--file=Makefile_os_x_64bit"

    cd "zchaff" do
      system "./build.sh"
      system "make", "-C", "zchaff64"
    end

    cd "nusmv" do
      system "./configure", "--enable-zchaff", "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end
