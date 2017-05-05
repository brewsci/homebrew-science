class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.4.0.tar.gz"
  sha256 "69e9fa08bacb2475e636da05a6c222b17c67f1ebeab3793762062248dd9d842f"
  revision 1
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "68ce3848fa53eaf40ce74767dda5ab9cf7a052644ea49bed3e34d5b876132f6f" => :sierra
    sha256 "2e042c4787184ba0c04e4bbb9417e5c0b4e93f2f5873f398525e3919b15d33e3" => :el_capitan
    sha256 "179d8b3f9c929c2cd5418db41f500614967bca33b7d7ba778975a67b825f7cac" => :yosemite
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
