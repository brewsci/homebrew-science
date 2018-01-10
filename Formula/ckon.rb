class Ckon < Formula
  desc "C++ tool for data analyses in the CERN ROOT framework"
  homepage "https://tschaume.github.io/ckon/"
  url "https://github.com/tschaume/ckon/archive/v0.7.1.tar.gz"
  sha256 "4cc8bde10430e21520aed4b7ac5f6d96a80b8a91014760997f9a7039103a7e0d"
  revision 6
  head "https://github.com/tschaume/ckon.git"

  bottle :disable, "needs to be rebuilt with latest boost"

  depends_on "boost"
  depends_on "curl"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    autoreconf_args = ["-v", "--force", "--install", "-Wall"]
    system "autoreconf", *autoreconf_args
    boostopts = [
      "--with-boost=#{Formula['boost'].opt_prefix}", "--with-boost-filesystem",
      "--with-boost-system", "--with-boost-regex",
      "--with-boost-program-options"
    ]
    system "./configure", "--prefix=#{prefix}", *boostopts
    system "make", "install"
  end

  test do
    system "#{bin}/ckon", "--version"
    (testpath/"ckon.cfg").write <<-EOS.undent
    suffix=0
    yaml=1
    [ckon]
    src_dir=StRoot
    prog_subdir=programs
    build_dir=build
    install_dir=build
    exclSuffix=""
    NoRootCint="BesCocktail"
    cppflags="-Wall"
    boost="system filesystem program_options"
    [ldadd]
    cbes=-lMathMore
    EOS
    (testpath/"ckonignore").write <<-EOS.undent
    macros
    EOS
    (testpath/"ckon.out").write <<-EOS.undent
    found ignore string macros in StRoot/BesCocktail/macros
    found ignore string macros in StRoot/BesCocktail/macros/bingchu
    "StRoot/BesCocktail"
    found ignore string macros in StRoot/BesCocktail/macros
    found ignore string macros in StRoot/BesCocktail/macros
    Processing file "StRoot/BesCocktail/Analysis.h"
       class "Analysis" found at: 302
    Processing file "StRoot/BesCocktail/CmdLine.h"
       class "CmdLine" found at: 255
    Processing file "StRoot/BesCocktail/Database.h"
       class "DatabaseManager" found at: 1864
    Processing file "StRoot/BesCocktail/Functions.h"
       class "Functions" found at: 310
    Processing file "StRoot/BesCocktail/Simulation.h"
       class "Simulation" found at: 329
    Processing file "StRoot/BesCocktail/Utils.h"
       class "Utils" found at: 168
    Processing file "StRoot/BesCocktail/Analysis.h"
    Processing file "StRoot/BesCocktail/CmdLine.h"
    Processing file "StRoot/BesCocktail/Database.h"
       namespace "YAML" found at: 756
    Processing file "StRoot/BesCocktail/Functions.h"
    Processing file "StRoot/BesCocktail/Simulation.h"
    Processing file "StRoot/BesCocktail/Utils.h"
    core_lib_string:  lib/libMyCollection.la
    core_lib_string:  lib/libMyCollection.la
    1 sub-directories processed.
    EOS
    cd testpath
    mkdir "StRoot"
    system "git", "clone", "https://github.com/tschaume/BesCocktail.git", "StRoot/BesCocktail"
    cd("StRoot/BesCocktail") { system "git", "checkout", "-q", "28446981a89cb851c43536200cc21310628aa555" }
    result = File.open(testpath/"ckon.out").read
    require "open3"
    Open3.popen3("#{bin}/ckon", "-v", "dry") do |_, stdout, _|
      assert_equal result, stdout.read
    end
    system "#{bin}/ckon", "clean"
  end
end
