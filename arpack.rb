class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.4.0.tar.gz"
  sha256 "69e9fa08bacb2475e636da05a6c222b17c67f1ebeab3793762062248dd9d842f"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    rebuild 1
    sha256 "1dc2e654743752805c212f8c624b4392891176ff216d633daf4d44a97128a0dc" => :sierra
    sha256 "ece580b9a167720f57d13c16fa452ff1583eda615fbcacfd25afe03c801565b5" => :el_capitan
    sha256 "37882bb51410da6602c2660f894de3adcbf7b1c24d82b73c25aafe9a9776fbbd" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on :fortran
  depends_on :mpi => [:optional, :f77]
  depends_on "openblas" => OS.mac? ? :optional : :recommended
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = []

    if build.with? "mpi"
      args << "F77=#{ENV["MPIF77"]}"
      args << "--enable-mpi"
    end

    blas_val = if build.with? "openblas"
      "-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif OS.mac?
      "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    else
      "--with-blas=-lblas -llapack"
    end

    args += %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --with-blas=#{blas_val}
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    (libexec/"share").install "TESTS/testA.mtx"
    if build.with? "mpi"
      (libexec/"bin").install (buildpath/"PARPACK/EXAMPLES/MPI").children
    end
  end

  test do
    if build.with? "mpi"
      cp_r (libexec/"bin").children, testpath
      %w[pcndrv1 pdndrv1 pdndrv3 pdsdrv1
         psndrv1 psndrv3 pssdrv1 pzndrv1].each do |slv|
        system "mpirun", "-np", "4", slv
      end
    else
      true
    end
  end
end
