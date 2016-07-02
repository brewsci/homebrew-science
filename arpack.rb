class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.3.0.tar.gz"
  sha256 "ad59811e7d79d50b8ba19fd908f92a3683d883597b2c7759fdcc38f6311fe5b3"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "f0d5c5dde75b198b126a31a26b784e6622560ee5cbae7d3bf722ebff25c26f4c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on :fortran
  depends_on :mpi => [:optional, :f77]
  depends_on "openblas" => :optional
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
