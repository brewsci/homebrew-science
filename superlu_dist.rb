class SuperluDist < Formula
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_dist_3.3.tar.gz"
  sha1 "1f44b6e8382b402a61ef107d962f8602e90498a4"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 2
    sha256 "4919b574eb4ac76c89fce13af6d9b0bf552aca676203b936619361a6687c3679" => :yosemite
    sha256 "f220fe2183c126df7fcaa352e4fe13e926a0f51c1462ba90444ec2ab26408db1" => :mavericks
    sha256 "8e9207d5533a9166ba9e870661d53689c60a088e9627ed4348883d343c675395" => :mountain_lion
  end

  depends_on :fortran
  depends_on :mpi => [:cc, :f77]

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
      CC           = #{ENV["MPICC"]}
      CFLAGS       = -fPIC -O2
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
    prefix.install "make.inc"  # Record make.inc used
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
