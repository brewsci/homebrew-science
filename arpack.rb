class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.4.0.tar.gz"
  sha256 "69e9fa08bacb2475e636da05a6c222b17c67f1ebeab3793762062248dd9d842f"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "4636e4856fd457de41d0ff7d62a52f2e6cef94acca2ab97777b8ba8ee4446c9f" => :sierra
    sha256 "b1a37921c005836ee4977fea7b8fb3ba136393361becc220aa01b63009e19a3c" => :el_capitan
    sha256 "2e4117baae0e916b6505ade1f858f444432c971b9c9633a8298b5b8f5359dcaf" => :yosemite
    sha256 "e29c366b94ddd94cb086eb61c4ace0ed8be9e91bea6b50ff4ce70eaff319fa7d" => :mavericks
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
