class Apophenia < Formula
  desc "C library for statistical and scientific computing"
  homepage "http://apophenia.info/"
  url "https://github.com/b-k/apophenia/archive/v1.0.tar.gz"
  sha256 "c753047a9230f9d9e105541f671c4961dc7998f4402972424e591404f33b82ca"
  revision 2

  head "https://github.com/b-k/apophenia.git"

  bottle do
    cellar :any
    sha256 "cd78c8a651577d511679b79aa66f43f50fbc5644d3152846142215252a3a3c9c" => :sierra
    sha256 "adf789318a1acc972ff0f1917f6b7006669b6b5f17aedc16e4cf413d7476dcf6" => :el_capitan
    sha256 "db04d9ea7bb72b6d51cdd35d509e488513a59f4d5eaa7c46cf8f3b6020f8b259" => :yosemite
    sha256 "1ccf3e976071d815b5618f057a8e9063f0434620df43f732dadc4a496435def8" => :x86_64_linux
  end

  # doi "arXiv:1502.02614"
  # isbn "978-0-691-13314-0"
  # eISBN "978-1-4008-2874-6"

  depends_on "gsl"
  depends_on "mysql" => :optional
  depends_on "sqlite" unless OS.mac?

  def install
    system "./configure", "--enable-extended-tests", "--prefix=#{prefix}", ("--with-mysql=no" if build.without? "mysql")
    system "make"
    system "make", "install"
  end

  test do
    # write a sample csv text file to import
    (testpath/"foo.csv").write <<-EOS.undent
      thud,bump
      1,2
      3,4
      5,6
      7,8
    EOS
    # test the csv to sqlite importer (built with libapophenia) works
    system "#{bin}/apop_text_to_db", (testpath/"foo.csv"), "bar", (testpath/"baz.db")
    # verify that we created a table bar in the database baz.db
    system "sqlite3", "baz.db", ".dump bar"
    # test the graph plotting tool (built with libapophenia) works
    system "#{bin}/apop_plot_query", "-d", (testpath/"baz.db"), "-q", "select thud,bump from bar", "-f", "grumble"
  end
end
