class Arpack < Formula
  homepage "http://forge.scilab.org/index.php/p/arpack-ng"
  url "http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_3.1.4.tar.gz"
  sha1 "1fb817346619b04d8fcdc958060cc0eab2c73c6f"
  head "git://git.forge.scilab.org/arpack-ng.git"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 2
    sha1 "64bc0fd798fc53502abdbe75c37e907742c17a66" => :yosemite
    sha1 "66750de80f91619ba39504421d144363ebe6f13f" => :mavericks
    sha1 "a5433059585eab3952b81cc324b46abb7ec43c3e" => :mountain_lion
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
