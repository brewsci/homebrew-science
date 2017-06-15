class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.5.0.tar.gz"
  sha256 "50f7a3e3aec2e08e732a487919262238f8504c3ef927246ec3495617dde81239"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "0ad6cbb66cbb710587e1ef51b0c90c32511267767faa74a8910bde0ff8fc3ba9" => :sierra
    sha256 "e9bcbc209d47b119c26f4608e93ed38e9fe895e43229db8ae52c1b5825c7c808" => :el_capitan
    sha256 "3de196b6c9a4b08509136bcd422bb469165b04a8468633f6324d686d1fd704e8" => :yosemite
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
