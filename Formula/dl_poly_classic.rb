class DlPolyClassic < Formula
  desc "General purpose molecular dynamics simulation package"
  homepage "https://ccpforge.cse.rl.ac.uk/gf/project/dl_poly_classic/"
  url "https://ccpforge.cse.rl.ac.uk/gf/download/frsrelease/255/4726/dl_class_1.9.tar.gz"
  sha256 "7068a44b13cf95a0659b61a3b0e76bf469051e49cc7b70e7796a98cf0d02db9c"
  revision 1
  # tag "chemistry"
  # doi "10.1016/S0263-7855(96)00043-4"

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  depends_on :fortran
  depends_on :mpi => :f90

  resource "test1" do
    url "https://ccpforge.cse.rl.ac.uk/gf/download/frsrelease/145/1314/TEST1.tar.gz"
    sha256 "307e8b17e9709b6df4ed6e8da6d8c383da396e1cedec44e6f36305e0875e0472"
  end

  def install
    # Makefiles do not support parallel build
    ENV.deparallelize

    # Build and install the serial version
    cd "source"
    ln_s "../build/MakeSEQ", "Makefile"
    system "make", "gfortran"
    bin.install "../execute/DLPOLY.X" => "DLPOLY.X.serial"

    # Build and install the MPI version
    system "make", "clean"
    rm "Makefile"
    ln_s "../build/MakePAR", "Makefile"
    system "make", "gfortran"
    bin.install "../execute/DLPOLY.X" => "DLPOLY.X.mpi"
  end

  test do
    resource("test1").stage do
      cd "VV"
      rm "OUTPUT"
      system "#{bin}/DLPOLY.X.serial"
      assert_match "time elapsed since job start", File.read("OUTPUT")
    end
  end
end
