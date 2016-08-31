class Apophenia < Formula
  desc "C library for statistical and scientific computing"
  homepage "http://apophenia.info/"
  url "https://github.com/b-k/apophenia/archive/v1.0.tar.gz"
  sha256 "c753047a9230f9d9e105541f671c4961dc7998f4402972424e591404f33b82ca"
  revision 1

  head "https://github.com/b-k/apophenia.git"

  bottle do
    cellar :any
    sha256 "da2829ec4b831d440d0462681515b42a38b5d15133f0c39cb2d4643edf0e5d9f" => :el_capitan
    sha256 "c12717497f2d73c1bc983c7c35642d9332cc647a16d5708834206c69f87379d5" => :yosemite
    sha256 "bb04cc51a07d2e48f4b760781d8644d0e20e4babff1ebc120ce1f5c60dd142e9" => :mavericks
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
