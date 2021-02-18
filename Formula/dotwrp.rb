class Dotwrp < Formula
  homepage "https://github.com/tenomoto/dotwrp"
  url "https://github.com/tenomoto/dotwrp/archive/v1.1.tar.gz"
  sha256 "369101851ecdffe89895ff91d21e535ef2df9c00c186f9e4f9443c709dfd825d"
  revision 2

  head "https://github.com/tenomoto/dotwrp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, sierra:     "3c9081727f4434a735784d7717ad7ad0ce03270e9166e1cdfe92d59ab3d37d1c"
    sha256 cellar: :any_skip_relocation, el_capitan: "8be4bfea890ed8dc4c91c83a95647528e41a8e797c98251920aeaff158a2c379"
    sha256 cellar: :any_skip_relocation, yosemite:   "98ad7164ef80c760fc0c8d63d0b8d6ff2949d4067b68bfc521073d0654f66bf4"
  end

  depends_on "gcc" if OS.mac? # for gfortran

  def install
    # NOTE: fno-underscoring is vital to override the symbols in Accelerate
    system "#{ENV.fc} #{ENV.fflags} -fno-underscoring -c dotwrp.f90"
    system "ar -cru libdotwrp.a dotwrp.o"
    system "ranlib libdotwrp.a"

    lib.install "libdotwrp.a"
  end
end
