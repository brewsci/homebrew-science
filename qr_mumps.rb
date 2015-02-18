class QrMumps < Formula
  homepage "http://buttari.perso.enseeiht.fr/qr_mumps"
  url "http://buttari.perso.enseeiht.fr/qr_mumps/releases/1.0/qr_mumps-1.0.tgz"
  sha1 "6f02a92cb1ea25d66eb122a2fa065b6f7da48f7b"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "5836e9d849761a38e2e379c811f4087598ff1070" => :yosemite
    sha1 "1f19a0e5343f33db85da312a407fd862d2ff8a27" => :mavericks
    sha1 "f5a62b1c1c9e9a0eacab51da1362a39cf110ab6e" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran

  depends_on "metis4" => :recommended
  depends_on "scotch5" => :optional
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without? "openblas"

  needs :openmp

  def install
    ENV.deparallelize
    cp "makeincs/Make.inc.gnu", "Make.inc"
    topdir = ["TOPDIR=#{pwd}"]
    make_args = ["CC=#{ENV["CC"]} -fPIC", "FC=#{ENV["FC"]} -fPIC"]
    if build.with? "metis4"
      make_args << "LMETIS=-L#{Formula["metis4"].opt_lib} -lmetis"
      make_args << "IMETIS=-I#{Formula["metis4"].opt_include}"
    end
    if build.with? "scotch5"
      make_args << "LSCOTCH=-L#{Formula["scotch5"].opt_lib} -lscotch -lscotcherr"
      make_args << "ISCOTCH=-I#{Formula["scotch5"].opt_include}"
    end
    if build.with? "openblas"
      make_args << "LBLAS=-L#{Formula["openblas"].opt_lib} -lopenblas"
      make_args << "LLAPACK=-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
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
    so = (OS.mac?) ? "dylib" : "so"
    cd "lib" do
      Dir["*.a"].each do |l|
        lname = File.basename(l, ".a") + ".#{so}"
        mkdir "#{lname}_shared" do
          system "ar", "-x", "../#{l}"
          ofiles = Dir["*.o"]
          if OS.mac?
            system "#{ENV["FC"]}", "-dynamiclib",
                                    "-undefined", "dynamic_lookup",
                                    "-install_name", "#{lib}/#{lname}",
                                    "-o", "../#{lname}", *ofiles
          else
            system "#{ENV["FC"]}", "-shared",
                                    "-Wl,-soname", "-Wl,#{lib}/#{lname}",
                                    "-o", "../#{lname}", *ofiles
          end
        end
      end
    end

    lib.install Dir["lib/*.a"], Dir["lib/*.#{so}"]
    include.install Dir["include/*.h"]
    (libexec / "modules").install Dir["include/*.mod"]
    doc.install Dir["doc/*"]
    (share / "qr_mumps").install "examples"

    prefix.install "Make.inc"  # For the record.
    File.open(prefix / "make_args.txt", "w") do |f|
      f.puts(make_args.join(" "))  # Record options passed to make.
    end
  end

  def caveats; <<-EOS.undent
    Fortran modules were installed to
      "#{libexec}/modules"
    EOS
  end
end
