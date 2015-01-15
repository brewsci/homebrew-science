class Nusmv < Formula
  homepage "http://nusmv.fbk.eu"
  url "http://nusmv.fbk.eu/distrib/NuSMV-2.5.4.tar.gz"
  sha1 "968798a95eac0127e3324dd2dc05bc0ff3ccf2fd"

  depends_on "wget"

  def install
    ENV.deparallelize
    system "make", "-C", "cudd-2.4.1.1", "--file=Makefile_os_x_64bit"

    cd "zchaff" do
      system "./build.sh"
      system "make", "-C", "zchaff64"
    end

    cd "nusmv" do
      system "./configure --enable-zchaff --prefix=#{prefix}"
      system "make", "install"
    end
  end
end
