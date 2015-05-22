class Arpack < Formula
  homepage "http://forge.scilab.org/index.php/p/arpack-ng"
  url "http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_3.1.4.tar.gz"
  sha1 "1fb817346619b04d8fcdc958060cc0eab2c73c6f"
  head "git://git.forge.scilab.org/arpack-ng.git"
  revision 2

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "6279a2b0072b0e362d50d218fde6b0ec6ce0dd841e7c143f0045ea0b60601f34" => :yosemite
    sha256 "13e906401589f1964d9847e6e291b03f55bf8de7b25968d6ca31124482a8ff6e" => :mavericks
    sha256 "a17839b8ec3e0599361674bc2211cff6705e04661cab093f80ea4edea2b757b0" => :mountain_lion
  end

  depends_on :fortran
  depends_on :mpi => [:optional, :f77]
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    cc_args = (build.with? :mpi) ? ["F77=#{ENV["MPIF77"]}"] : []
    args = cc_args + ["--disable-dependency-tracking", "--prefix=#{libexec}"]
    args << "--enable-mpi" if build.with? :mpi
    if build.with? "openblas"
      args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif OS.mac?
      args << "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    else
      args << "--with-blas=-lblas -llapack"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib / "pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    (libexec / "share").install "TESTS/testA.mtx"
  end

  test do
    cd libexec/"share" do
      ["dnsimp", "bug_1323"].each do |slv|
        system "#{libexec}/bin/#{slv}"  # Reads testA.mtx
      end
    end
  end
end
