class QrMumps < Formula
  desc "Parallel sparse QR factorization"
  homepage "http://buttari.perso.enseeiht.fr/qr_mumps"
  url "http://buttari.perso.enseeiht.fr/qr_mumps/releases/1.0/qr_mumps-1.0.tgz"
  sha256 "69bfcb2f5718480c5dec88cc4241c57fec15b44eac53c2e14542f4838f375049"
  revision 2

  bottle do
    sha256 "998db17b2124d6a1f85c162f986def9df5c55fd97c2a98b73b7a5344bb63f9cb" => :el_capitan
    sha256 "048e3ebb6d8acf22566542f0c434bacb65b1a0c5f194e4f5cbb18c5478553927" => :yosemite
    sha256 "631667284a61985d19f5550a4d1d071fd2a4670e8a9122fb73045d280be67b8a" => :mavericks
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran

  depends_on "metis4" => :recommended
  depends_on "scotch5" => :optional
  depends_on "openblas" => ((OS.mac?) ? :optional : :recommended)
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?

  needs :openmp

  def make_shared(l, extra)
    if OS.mac?
      so = "dylib"
      all_load = "-Wl,-all_load"
      noall_load = "-Wl,-noall_load" # gives a warning but gfortran doesn't want this empty.
    else
      so = "so"
      all_load = "-Wl,-whole-archive"
      noall_load = "-Wl,-no-whole-archive"
    end
    system ENV["FC"], "-fPIC", "-shared", all_load, "#{l}.a", noall_load, "-o", "#{l}.#{so}", "-lgomp", *extra
  end

  def install
    ENV.deparallelize
    cp "makeincs/Make.inc.gnu", "Make.inc"
    topdir = ["TOPDIR=#{pwd}"]
    make_args = ["CC=#{ENV["CC"]} -fPIC", "FC=#{ENV["FC"]} -fPIC"]
    libs = []
    if build.with? "metis4"
      libs << "-L#{Formula["metis4"].opt_lib}" << "-lmetis"
      make_args << "LMETIS=-L#{Formula["metis4"].opt_lib} -lmetis"
      make_args << "IMETIS=-I#{Formula["metis4"].opt_include}"
    end
    if build.with? "scotch5"
      libs << "-L#{Formula["scotch5"].opt_lib}" << "-lscotch" << "-lscotcherr"
      make_args << "LSCOTCH=-L#{Formula["scotch5"].opt_lib} -lscotch -lscotcherr"
      make_args << "ISCOTCH=-I#{Formula["scotch5"].opt_include}"
    end
    if build.with? "openblas"
      libs << "-L#{Formula["openblas"].opt_lib}" << "-lopenblas"
      make_args << "LBLAS=-L#{Formula["openblas"].opt_lib} -lopenblas"
      make_args << "LLAPACK=-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      libs << "-lveclibfort"
      make_args << "LBLAS=-lveclibfort" << "LLAPACK=-lveclibfort"
    end

    system "make", "sprec", "dprec", "cprec", "zprec", *(topdir + make_args)
    if build.with? "check"
      system "make", "stest", "dtest", "ctest", "ztest", *(topdir + make_args)
      cd "test" do
        ["./sqrm_coverage", "./dqrm_coverage", "./cqrm_coverage", "./zqrm_coverage"].each do |cmd|
          system cmd
        end
      end
    end

    # Build shared libraries.
    cd "lib" do
      make_shared "libqrm_common", libs
      %w[libsqrm libdqrm libcqrm libzqrm].each do |l|
        make_shared l, (["-L.", "-lqrm_common"] + libs)
      end
    end

    so = (OS.mac?) ? "dylib" : "so"
    lib.install Dir["lib/*.a"], Dir["lib/*.#{so}"]
    include.install Dir["include/*.h"]
    (libexec / "modules").install Dir["include/*.mod"]
    doc.install Dir["doc/*"]
    pkgshare.install "examples"
    (pkgshare/"examples").install Dir["include/*.pl"]

    prefix.install "Make.inc" # For the record.
    File.open(prefix / "make_args.txt", "w") do |f|
      f.puts(make_args.join(" ")) # Record options passed to make.
    end
  end

  def caveats; <<-EOS.undent
    Fortran modules were installed to
      "#{libexec}/modules"
    EOS
  end

  test do
    ENV.fortran
    (testpath/"test.f90").write <<-EOS
      program _qrm_test
        use _qrm_mod
        implicit none

        type(_qrm_spmat_type)          :: qrm_mat
        _qrm_data, allocatable, target :: b(:), x(:), r(:)
        _qrm_real                      :: rnrm, onrm

        call qrm_spmat_init(qrm_mat)
        call qrm_set('qrm_eunit', 6)

        call qrm_palloc(qrm_mat%irn, 13)
        call qrm_palloc(qrm_mat%jcn, 13)
        call qrm_palloc(qrm_mat%val, 13)

        qrm_mat%jcn = (/1,1,1,2,2,3,3,3,3,4,4,5,5/)
        qrm_mat%irn = (/2,3,6,1,6,2,4,5,7,2,3,2,4/)
        qrm_mat%val = (/0.7,0.6,0.4,0.1,0.1,0.3,0.6,0.7,0.2,0.5,0.2,0.1,0.6/)
        qrm_mat%m   = 7
        qrm_mat%n   = 5
        qrm_mat%nz  = 13

        call qrm_set(qrm_mat, 'qrm_ib', 2)
        call qrm_set(qrm_mat, 'qrm_nb', 2)
        call qrm_set(qrm_mat, 'qrm_nthreads', 1)
        call qrm_set(qrm_mat, 'qrm_ordering', qrm_natural_)

        call qrm_analyse(qrm_mat, 'n')
        call qrm_factorize(qrm_mat, 'n')

        call qrm_aalloc(b, qrm_mat%m)
        call qrm_aalloc(r, qrm_mat%m)
        call qrm_aalloc(x, qrm_mat%n)

        b = _qrm_one
        r = b

        call qrm_apply(qrm_mat, 't', b)
        call qrm_solve(qrm_mat, 'n', b, x)

        call qrm_residual_norm(qrm_mat, r, x, rnrm)
        call qrm_residual_orth(qrm_mat, r, onrm)
        write(*, '("||r||/||A||    = ", e10.2)') rnrm
        write(*, '("||A^Tr||/||r|| = ", e10.2)') onrm

        call qrm_adealloc(b)
        call qrm_adealloc(r)
        call qrm_adealloc(x)
        call qrm_spmat_destroy(qrm_mat, all=.true.)
      end program _qrm_test
    EOS

    %w[s d c z].each do |p|
      system "perl #{pkgshare}/examples/#{p}.pl < test.f90 > #{p}test.f90"
      system ENV["FC"], "#{p}test.f90", "-o", "#{p}test", "-I#{opt_libexec}/modules", "-L#{opt_lib}", "-lqrm_common", "-l#{p}qrm", "-lgomp"
      system "./#{p}test"
    end
  end
end
