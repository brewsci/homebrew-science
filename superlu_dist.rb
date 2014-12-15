require "formula"

class SuperluDist < Formula
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_dist_3.3.tar.gz"
  sha1 "1f44b6e8382b402a61ef107d962f8602e90498a4"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "5edab91513d1ef5efff95e93b30a037027338fb2" => :yosemite
    sha1 "31dcdd6c88ca5d6bc468001c9a3170679a9f4f75" => :mavericks
    sha1 "0b33b46ef6a277b6e8a6ff63393983e95dc79a89" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on :mpi => [:cc, :f90]

  depends_on "parmetis"
  depends_on "openblas" => :optional

  def install
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
      CC           = mpicc
      CFLAGS       = -O2
      NOOPTS       =
      FORTRAN      = mpif77
      F90FLAGS     = -O2
      LOADER       = mpif77
      LOADOPTS     =
      CDEFS        = -DAdd_
    EOS

    system "make", "lib"
    if build.with? "check"
        cd "EXAMPLE" do
          system "make"
          system "mpirun -np 4 pddrive -r 2 -c 2 g20.rua"
          system "mpirun -np 10 pddrive4 g20.rua"
          system "mpirun -np 4 pzdrive -r 2 -c 2 cg20.cua"
          system "mpirun -np 10 pzdrive4 cg20.cua"
        end
    end
    prefix.install "make.inc"  # Record make.inc used
    lib.install Dir["lib/*"]
    (include / "superlu_dist").install Dir["SRC/*.h"]
    doc.install Dir["Doc/*"]
    (share / "superlu_dist").install "EXAMPLE"
  end
end
