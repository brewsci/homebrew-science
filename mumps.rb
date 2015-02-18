class Mumps < Formula
  homepage "http://mumps.enseeiht.fr"
  url "http://mumps.enseeiht.fr/MUMPS_4.10.0.tar.gz"
  mirror "http://graal.ens-lyon.fr/MUMPS/MUMPS_4.10.0.tar.gz"
  sha1 "904b1d816272d99f1f53913cbd4789a5be1838f7"
  revision 2

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 6
    sha1 "350e070e49a192255e8189a3d5478da999258c4a" => :yosemite
    sha1 "40ae1cd222ebac49c10456d5b0e0376999e9f72d" => :mavericks
    sha1 "a1fb1c15d86d5737a6ef1898b50930f77dc5f23c" => :mountain_lion
  end

  depends_on "scotch5" => :optional     # Scotch 6 support currently broken.
  depends_on "openblas" => :optional

  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  if build.with? "mpi"
    depends_on "scalapack" => (build.with? "openblas") ? ["with-openblas"] : :build
  end
  depends_on "metis4" => :optional if build.without? "mpi"

  depends_on :fortran

  resource "mumps_simple" do
    url "https://github.com/dpo/mumps_simple/archive/v0.2.tar.gz"
    sha1 "21106a5fc9e79fb8da8d9bc50ded354e38f5c500"
  end

  def install
    if OS.mac?
      # Building dylibs with mpif90 causes segfaults on 10.8 and 10.10. Use gfortran.
      make_args = ["LIBEXT=.dylib",
                   "AR=#{ENV["FC"]} -dynamiclib -Wl,-install_name -Wl,#{lib}/$(notdir $@) -undefined dynamic_lookup -o ",
                   "RANLIB=echo"]
    else
      make_args = ["LIBEXT=.so", "AR=$(FL) -shared -Wl,-soname -Wl,$(notdir $@) -o ", "RANLIB=echo"]
    end
    orderingsf = "-Dpord"

    makefile = (build.with? "mpi") ? "Makefile.gfortran.PAR" : "Makefile.gfortran.SEQ"
    cp "Make.inc/" + makefile, "Makefile.inc"

    if build.with? "scotch5"
      make_args += ["SCOTCHDIR=#{Formula["scotch5"].opt_prefix}",
                    "ISCOTCH=-I#{Formula["scotch5"].opt_include}"]

      if build.with? "mpi"
        make_args << "LSCOTCH=-L$(SCOTCHDIR)/lib -lptesmumps -lptscotch -lptscotcherr"
        orderingsf << " -Dptscotch"
      else
        make_args << "LSCOTCH=-L$(SCOTCHDIR) -lesmumps -lscotch -lscotcherr"
        orderingsf << " -Dscotch"
      end
    end

    if build.with? "metis4"
      make_args += ["LMETISDIR=#{Formula["metis4"].opt_lib}",
                    "IMETIS=#{Formula["metis4"].opt_include}",
                    "LMETIS=-L#{Formula["metis4"].opt_lib} -lmetis"]
      orderingsf << " -Dmetis"
    end

    make_args << "ORDERINGSF=#{orderingsf}"

    if build.with? "mpi"
      make_args += ["CC=#{ENV["MPICC"]} -fPIC",
                    "FC=#{ENV["MPIFC"]} -fPIC",
                    "FL=#{ENV["MPIFC"]} -fPIC",
                    "SCALAP=-L#{Formula["scalapack"].opt_lib} -lscalapack",
                    "INCPAR=",  # Let MPI compilers fill in the blanks.
                    "LIBPAR=$(SCALAP)"]
    else
      make_args += ["CC=#{ENV["CC"]} -fPIC",
                    "FC=#{ENV["FC"]} -fPIC",
                    "FL=#{ENV["FC"]} -fPIC"]
    end

    if build.with? "openblas"
      make_args << "LIBBLAS=-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      make_args << "LIBBLAS=-lblas -llapack"
    end

    ENV.deparallelize  # Build fails in parallel on Mavericks.

    # First build libs, install them, and then link example programs.
    system "make", "alllib", *make_args

    lib.install Dir["lib/*"]
    lib.install ("libseq/libmpiseq" + ((OS.mac?) ? ".dylib" : ".so")) if build.without? "mpi"

    inreplace "examples/Makefile" do |s|
      s.change_make_var! "libdir", lib
    end

    system "make", "all", *make_args  # Build examples.

    if build.with? "mpi"
      include.install Dir["include/*"]
    else
      libexec.install "include"
      include.install_symlink Dir[libexec / "include/*"]
      # The following .h files may conflict with others related to MPI
      # in /usr/local/include. Do not symlink them.
      (libexec / "include").install Dir["libseq/*.h"]
    end

    doc.install Dir["doc/*.pdf"]
    (share + "mumps/examples").install Dir["examples/*[^.o]"]

    prefix.install "Makefile.inc"  # For the record.
    File.open(prefix / "make_args.txt", "w") do |f|
      f.puts(make_args.join(" "))  # Record options passed to make.
    end

    if build.with? "mpi"
      resource("mumps_simple").stage do
        simple_args = ["CC=#{ENV["MPICC"]}", "prefix=#{prefix}", "mumps_prefix=#{prefix}",
                       "scalapack_libdir=#{Formula["scalapack"].opt_lib}"]
        simple_args += ["scotch_libdir=#{Formula["scotch5"].opt_lib}",
                        "scotch_libs=-L$(scotch_libdir) -lptesmumps -lptscotch -lptscotcherr"] if build.with? "scotch5"
        simple_args += ["blas_libdir=#{Formula["openblas"].opt_lib}",
                        "blas_libs=-L$(blas_libdir) -lopenblas"] if build.with? "openblas"
        system "make", "SHELL=/bin/bash", *simple_args
        lib.install ("libmumps_simple." + ((OS.mac?) ? "dylib" : "so"))
        include.install "mumps_simple.h"
      end
    end
  end

  def caveats
    s = ""
    if build.without? "mpi"
      s += <<-EOS.undent
      You built a sequential MUMPS library.
      Please add #{libexec}/include to the include path
      when building software that depends on MUMPS.
      EOS
    end
    s
  end

  test do
    cmd = build.without?("mpi") ? "" : "mpirun -np 2"
    system "#{cmd} #{share}/mumps/examples/ssimpletest < #{share}/mumps/examples/input_simpletest_real"
    system "#{cmd} #{share}/mumps/examples/dsimpletest < #{share}/mumps/examples/input_simpletest_real"
    system "#{cmd} #{share}/mumps/examples/csimpletest < #{share}/mumps/examples/input_simpletest_cmplx"
    system "#{cmd} #{share}/mumps/examples/zsimpletest < #{share}/mumps/examples/input_simpletest_cmplx"
    system "#{cmd} #{share}/mumps/examples/c_example"
    ohai "Test results are in ~/Library/Logs/Homebrew/mumps"
  end
end
