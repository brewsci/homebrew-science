class QrMumps < Formula
  desc "Parallel sparse QR factorization"
  homepage "http://buttari.perso.enseeiht.fr/qr_mumps"
  url "http://buttari.perso.enseeiht.fr/qr_mumps/releases/1.2/qr_mumps-1.2.tgz"
  sha256 "6aacdab63c4d4160998f47ac736d4665f0dd5deb6002eeb2aa59de6eb274c337"
  revision 2
  head "https://wwwsecu.irit.fr/svn/qr_mumps/tags/1.2", :using => :svn

  bottle do
    sha256 "974dae7681a0dfbbf6c41bbba0d4d7d300de6db6f78f742ebb5e4301848653e9" => :sierra
    sha256 "aa3033e9fd661e18c05e607e96154d1895264aa8b0956137f610213bc0b325f0" => :el_capitan
    sha256 "b3a0b07ef14ba110550215308e21206f1d26ad1e13b300494a83534b50c79e50" => :yosemite
  end

  option "without-test", "Skip build-time tests (not recommended)"

  depends_on :fortran

  depends_on "metis4" => :recommended
  depends_on "scotch5" => :optional
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)
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
      libs << "-lvecLibFort"
      make_args << "LBLAS=-lvecLibFort" << "LLAPACK=-lvecLibFort"
    end

    system "make", "sprec", "dprec", "cprec", "zprec", *(topdir + make_args)
    if build.with? "test"
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

    so = OS.mac? ? "dylib" : "so"
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
