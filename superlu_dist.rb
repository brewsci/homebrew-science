class SuperluDist < Formula
  desc "A general purpose library for the direct solution of large, sparse, nonsymmetric systems of linear equations on high performance machines."
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_dist_4.1.tar.gz"
  sha256 "8afb48036e9b3020d268d49d5a3711aaed2f65105747aa6a111ff8f64dcde93e"

  bottle do
    cellar :any
    revision 2
    sha256 "f2db09d54fe786fe60bcdd3e615642509948d820074895a2cde6d8dbbce90367" => :yosemite
    sha256 "dae72d0217df82f924042deda337b5c78ba0f2e232d68ccce248f51cc67beed5" => :mavericks
    sha256 "1fcb04ec665ee2f413d55bcbfb1c9baa71e205017125c756f04c516b197e0ec6" => :mountain_lion
  end

  depends_on :fortran
  depends_on :mpi => [:cc, :f77]

  depends_on "parmetis"
  depends_on "openblas" => :optional

  # fix duplicate symbols [mc64dd_,mc64ed_,mc64fd_] when linking with superlu
  patch do
    url "https://bitbucket.org/petsc/pkg-superlu_dist/commits/2faf8669a2ba20250ffe2d8a1b63d4f8ef8c5b74/raw/"
    sha256 "09dcd7de83ef9d2590465742df76753cb7c61bfe8e7819c02613d9bcf20ed255"
  end

  def install
    # prevent linking errors on linuxbrew:
    ENV.deparallelize
    rm "#{buildpath}/make.inc"
    blaslib = ((build.with? "openblas") ? "-L#{Formula["openblas"].opt_lib} -lopenblas" : "-framework Accelerate")
    (buildpath / "make.inc").write <<-EOS.undent
      PLAT         = _mac_x
      DSuperLUroot = #{buildpath}
      DSUPERLULIB  = $(DSuperLUroot)/lib/libsuperlu_dist.a
      BLASDEF      = -DUSE_VENDOR_BLAS
      BLASLIB      = #{blaslib}
      METISLIB     = -L#{Formula["metis"].opt_lib} -lmetis
      PARMETISLIB  = -L#{Formula["parmetis"].opt_lib} -lparmetis
      FLIBS        =
      LIBS         = $(DSUPERLULIB) $(BLASLIB) $(PARMETISLIB) $(METISLIB)
      ARCH         = ar
      ARCHFLAGS    = cr
      RANLIB       = true
      CC           = #{ENV["MPICC"]}
      CFLAGS       = -fPIC -O2 -I#{Formula["parmetis"].opt_include} -I#{Formula["metis"].opt_include}
      NOOPTS       = -fPIC
      FORTRAN      = #{ENV["MPIF77"]}
      F90FLAGS     = -O2
      LOADER       = #{ENV["MPIF77"]}
      LOADOPTS     =
      CDEFS        = -DAdd_
    EOS

    system "make", "lib"
    cd "EXAMPLE" do
      system "make"
    end
    prefix.install "make.inc" # Record make.inc used
    lib.install Dir["lib/*"]
    (include / "superlu_dist").install Dir["SRC/*.h"]
    doc.install Dir["Doc/*"]
    (share / "superlu_dist").install "EXAMPLE"
  end

  test do
    cd (share / "superlu_dist/EXAMPLE") do
      system "mpirun", "-np", "4", "./pddrive", "-r", "2", "-c", "2", "g20.rua"
      system "mpirun", "-np", "10", "./pddrive4", "g20.rua"
      system "mpirun", "-np", "4", "./pzdrive", "-r", "2", "-c", "2", "cg20.cua"
      system "mpirun", "-np", "10", "./pzdrive4", "cg20.cua"
    end
  end
end
