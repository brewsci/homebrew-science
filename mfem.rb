class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM."
  homepage "http://www.mfem.org/"
  url "https://goo.gl/Vrpsns"
  version "3.3"
  sha256 "b17bd452593aada93dc0fee748fcfbbf4f04ce3e7d77fdd0341cc9103bcacd0b"

  bottle do
    cellar :any_skip_relocation
    sha256 "35e84e4e8ba4fda6a97f6ced36ac561902488ca716bb88c3a3dc7a4cc23d835a" => :sierra
    sha256 "58714c6611442447e0f8ef57f6fbb2b812e43d76e3525915144a4115563aa605" => :el_capitan
    sha256 "71941bca57236fec5493dd7e0bd40563cc3a52daf0a5fcc279fc29c254ed709e" => :yosemite
    sha256 "05341892c5f4530c5edead5b496894c2a6276c16dc4c3dd1febc2e1dd4faa478" => :x86_64_linux
  end

  option "with-mpi", "Build with mpi support (implies --with-hypre --with-metis)"
  option "with-suite-sparse", "Build with suite-sparse support (implies --with-metis)"

  depends_on :mpi => [:cxx, :optional]
  if build.with?("mpi")
    depends_on "metis"
    depends_on "hypre" => "with-mpi"
  else
    depends_on "hypre" => :optional
    depends_on "metis" => :optional
  end

  if OS.mac?
    depends_on "openblas" => :optional
  else
    depends_on "openblas"
  end

  depends_on "suite-sparse" => :optional
  depends_on "netcdf" => :optional
  depends_on "superlu_dist" => :optional

  def install
    make_args = ["PREFIX=#{prefix}"]

    if build.with?("openblas")
      lapack_lib = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      lapack_lib = "-llapack -lblas"
    end
    make_args += ["MFEM_USE_LAPACK=YES", "LAPACK_LIB=#{lapack_lib}"]

    if build.with?("hypre") || build.with?("mpi")
      make_args += ["HYPRE_DIR=#{Formula["hypre"].opt_prefix}",
                    "HYPRE_OPT=-I#{Formula["hypre"].opt_include}",
                    "HYPRE_LIB=-L#{Formula["hypre"].opt_lib} -lHYPRE"]
    end

    if build.with?("metis") || build.with?("mpi") || build.with?("suite-sparse")
      metis_lib = "-L#{Formula["metis"].opt_lib} -lmetis"
      make_args += ["MFEM_USE_METIS_5=YES",
                    "METIS_DIR=#{Formula["metis"].opt_prefix}",
                    "METIS_OPT=-I#{Formula["metis"].opt_include}",
                    "METIS_LIB=#{metis_lib}"]
    end

    make_args += ["MFEM_USE_MPI=YES"] if build.with?("mpi")

    if build.with?("suite-sparse")
      ss_lib = "-L#{Formula["suite-sparse"].opt_lib} "
      ss_lib += "-lklu -lbtf -lumfpack -lcholmod -lcolamd -lamd -lcamd "
      ss_lib += "-lccolamd -lsuitesparseconfig #{metis_lib} #{lapack_lib}"
      make_args += ["MFEM_USE_SUITESPARSE=YES",
                    "SUITESPARSE_DIR=#{Formula["suite-sparse"].opt_prefix}",
                    "SUITESPARSE_OPT=-I#{Formula["suite-sparse"].opt_include}",
                    "SUITESPARSE_LIB=#{ss_lib}"]
    end

    if build.with?("superlu_dist")
      superlu_lib = "-L#{Formula["superlu_dist"].opt_lib} -lsuperlu_dist"
      make_args += ["MFEM_USE_SUPERLU=YES",
                    "SUPERLU_DIR=#{Formula["superlu_dist"].opt_prefix}",
                    "SUPERLU_OPT=-I#{Formula["superlu_dist"].opt_include}",
                    "SUPERLU_LIB=#{superlu_lib}"]
    end

    if build.with?("netcdf")
      netcdf_lib = "-L#{Formula["netcdf"].opt_lib} -lnetcdf "
      netcdf_lib += "-L#{Formula["hdf5"].opt_lib} -lhdf5_hl -lhdf5 "
      if OS.mac?
        netcdf_lib += "-L/usr/lib -lz"
      else
        netcdf_lib += "-L#{Formula["zlib"].opt_lib} -lz"
      end
      zlib_dir = OS.mac? ? "/usr" : Formula["zlib"].opt_prefix.to_s
      make_args += ["MFEM_USE_NETCDF=YES",
                    "NETCDF_DIR=#{Formula["netcdf"].opt_prefix}",
                    "HDF5_DIR=#{Formula["hdf5"].opt_prefix}",
                    "ZLIB_DIR=#{zlib_dir}",
                    "NETCDF_OPT=-I#{Formula["netcdf"].opt_include}",
                    "NETCDF_LIB=#{netcdf_lib}"]
    end

    system "make", "config", *make_args
    system "make", "all"
    system "make", "install"

    # Install some examples in pkgshare for users learning the library
    (pkgshare/"examples").mkpath
    (pkgshare/"examples").install Dir["examples/*.cpp"]
    (pkgshare/"examples").install "examples/makefile"
    (pkgshare/"data").mkpath
    (pkgshare/"data").install Dir["data/*.mesh"]
    (pkgshare/"data").install Dir["data/*.vtk"]
    pkgshare.install "config"
  end

  test do
    cp_r "#{Formula["mfem"].opt_pkgshare}/examples", "./"
    cd "examples" do
      cp "#{Formula["mfem"].opt_pkgshare}/data/star.mesh", "./"
      system "make", "all", "MFEM_DIR=#{Formula["mfem"].opt_prefix}", "CONFIG_MK=$(MFEM_DIR)/config.mk", "TEST_MK=$(MFEM_DIR)/test.mk", "MFEM_LIB_FILE=$(MFEM_DIR)/lib/libmfem.a", "SRC="
      args = ["-m", "star.mesh", "--no-visualization"]
      if Tab.for_name("mfem").with? "mpi"
        system "mpirun", "-np", "4", "./ex1p", *args
      else
        system "./ex1", *args
      end
    end
  end
end
