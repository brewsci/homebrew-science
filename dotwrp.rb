class Dotwrp < Formula
  homepage "https://github.com/tenomoto/dotwrp"
  url "https://github.com/tenomoto/dotwrp/archive/v1.1.tar.gz"
  sha256 "369101851ecdffe89895ff91d21e535ef2df9c00c186f9e4f9443c709dfd825d"
  revision 1

  head "https://github.com/tenomoto/dotwrp.git"

  depends_on :fortran

  def install
    # note: fno-underscoring is vital to override the symbols in Accelerate
    system "#{ENV.fc} #{ENV.fflags} -fno-underscoring -c dotwrp.f90"
    system "ar -cru libdotwrp.a dotwrp.o"
    system "ranlib libdotwrp.a"

    lib.install "libdotwrp.a"
  end
end
