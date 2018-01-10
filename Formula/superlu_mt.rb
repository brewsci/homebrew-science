class SuperluMt < Formula
  desc "Multithreaded solution of large, sparse nonsymmetric systems"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_mt_3.0.tar.gz"
  sha256 "e5750982dc83ac62f4da31f24638aa62dbfe3ff00f9b8b786ad2eed5f9cabf56"

  bottle do
    cellar :any_skip_relocation
    sha256 "a460a5543263472459e092635ddc8e80ca5d98260774e08f7ac8f8307caaa649" => :el_capitan
    sha256 "eb3cb0a2af993bed8c3ebb3ec62b1b044d5df00b0c34bb196547de87d1aff663" => :yosemite
    sha256 "885528f086c805ddfdaa5001b087b70abe65ea7e0110c423b8dba8e513a66a2c" => :mavericks
  end

  option "with-openmp", "use OpenMP instead of Pthreads interface"

  # Accelerate single precision is buggy and causes certain single precision
  # tests to fail.
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)
  depends_on "veclibfort" if (build.without? "openblas") && OS.mac?

  needs :openmp if build.with? "openmp"

  def install
    ENV.deparallelize
    make_args = %W[CC=#{ENV.cc} CFLAGS=#{ENV.cflags} FORTRAN= LOADER=#{ENV.cc}]

    if build.with? "openmp"
      make_inc = "make.openmp"
      libname = "libsuperlu_mt_OPENMP.a"
      ENV.append_to_cflags "-D__OPENMP"
      make_args << "MPLIB=-fopenmp"
      make_args << "PREDEFS=-D__OPENMP -fopenmp"
    else
      make_inc = "make.pthread"
      libname = "libsuperlu_mt_PTHREAD.a"
      ENV.append_to_cflags "-D__PTHREAD"
    end
    cp "MAKE_INC/#{make_inc}", "make.inc"

    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      blas = OS.mac? ? "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort" : "-lblas"
    end
    make_args << "BLASLIB=#{blas}"

    system "make", *make_args
    lib.install Dir["lib/*.a"]
    ln_s lib/libname, lib/"libsuperlu_mt.a"
    (include/"superlu_mt").install Dir["SRC/*.h"]
    pkgshare.install "EXAMPLE"
    doc.install Dir["DOC/*.pdf"]
    prefix.install "make.inc"
    File.open(prefix/"make_args.txt", "w") do |f|
      make_args.each do |arg|
        var, val = arg.split("=")
        f.puts "#{var}=\"#{val}\"" # Record options passed to make, preserve spaces.
      end
    end
  end

  def caveats; <<-EOS.undent
    Default SuperLU_MT build options are recorded in

      #{opt_prefix}/make.inc

    Specific options for this build are in

      #{opt_prefix}/make_args.txt
    EOS
  end

  test do
    cp_r pkgshare/"EXAMPLE", testpath
    cp prefix/"make.inc", testpath
    make_args = []
    File.readlines(opt_prefix/"make_args.txt").each do |line|
      make_args << line.chomp.delete('\\"')
    end
    make_args << "HEADER=#{opt_include}/superlu_mt"
    make_args << "LOADOPTS="

    cd "EXAMPLE" do
      inreplace "Makefile", "../lib/$(SUPERLULIB)", "#{opt_lib}/libsuperlu_mt.a"
      system "make", *make_args
      # simple driver
      system "./pslinsol -p #{Hardware::CPU.cores} < big.rua"
      system "./pdlinsol -p #{Hardware::CPU.cores} < big.rua"
      system "./pclinsol -p #{Hardware::CPU.cores} < cmat"
      system "./pzlinsol -p #{Hardware::CPU.cores} < cmat"
      # expert driver
      system "./pslinsolx -p #{Hardware::CPU.cores} < big.rua"
      system "./pdlinsolx -p #{Hardware::CPU.cores} < big.rua"
      system "./pclinsolx -p #{Hardware::CPU.cores} < cmat"
      system "./pzlinsolx -p #{Hardware::CPU.cores} < cmat"
      # expert driver on several systems with same sparsity pattern
      system "./pslinsolx1 -p #{Hardware::CPU.cores} < big.rua"
      system "./pdlinsolx1 -p #{Hardware::CPU.cores} < big.rua"
      system "./pclinsolx1 -p #{Hardware::CPU.cores} < cmat"
      system "./pzlinsolx1 -p #{Hardware::CPU.cores} < cmat"
      # example with symmetric mode
      system "./pslinsolx2 -p #{Hardware::CPU.cores} < big.rua"
      system "./pdlinsolx2 -p #{Hardware::CPU.cores} < big.rua"
      # system "./pclinsolx2 -p #{Hardware::CPU.cores} < cmat" # bus error
      # system "./pzlinsolx2 -p #{Hardware::CPU.cores} < cmat" # bus error
      # example with repeated factorization of systems with same sparsity pattern
      # system "./psrepeat -p #{Hardware::CPU.cores} < big.rua" # malloc error
      system "./pdrepeat -p #{Hardware::CPU.cores} < big.rua"
      # system "./pcrepeat -p #{Hardware::CPU.cores} < cmat" # malloc error
      # system "./pzrepeat -p #{Hardware::CPU.cores} < cmat" # malloc error
      # example that integrates with other multithreaded application
      system "./psspmd -p #{Hardware::CPU.cores} < big.rua"
      system "./pdspmd -p #{Hardware::CPU.cores} < big.rua"
      system "./pcspmd -p #{Hardware::CPU.cores} < cmat"
      system "./pzspmd -p #{Hardware::CPU.cores} < cmat"
    end
  end
end
