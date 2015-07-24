class QrMumps < Formula
  homepage "http://buttari.perso.enseeiht.fr/qr_mumps"
  url "http://buttari.perso.enseeiht.fr/qr_mumps/releases/1.0/qr_mumps-1.0.tgz"
  sha1 "6f02a92cb1ea25d66eb122a2fa065b6f7da48f7b"
  revision 1

  bottle do
    sha256 "71487d708b396d794bc9b7b6c1584a74f1a466afbc6814832226807cdf691ae0" => :yosemite
    sha256 "c1123bf4096116d03d511de1bebaa894df84cf043ad8f82600adb89e3bb95acf" => :mavericks
    sha256 "7eaca6620c9215fa69b415a832c3086916180451bc4376853cfe8b5e27c4309e" => :mountain_lion
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
