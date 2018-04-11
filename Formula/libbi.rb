class Libbi < Formula
  desc "Bayesian state-space modelling on parallel computer hardware"
  homepage "http://libbi.org"
  revision 7
  head "https://github.com/libbi/LibBi.git"

  stable do
    url "https://github.com/libbi/LibBi/archive/1.3.0.tar.gz"
    sha256 "0dd313dd71e72b2f16ca9074800fc2fa8bf585bec3b87a750ff27e467a9826d0"

    if build.without? "openmp"
      patch do
        # disable OpenMP if it is not used
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/08c981bbee01db804e8002868affbbda57a82436/libbi/libbi-1.3.0-openmp.patch"
        sha256 "236d288c79a505626ad5435f09761af371a2a562c3c35b32310a0a9d92edb3cf"
      end
    end
  end

  bottle :disable, "needs to be rebuilt with latest boost and netcdf"

  option "without-test", "Disable build-time checking (not recommended)"
  option "without-openmp", "Disable OpenMP"

  needs :openmp if build.with? "openmp"

  depends_on "perl"
  depends_on "qrupdate"
  depends_on "netcdf"
  depends_on "gsl"
  depends_on "boost"
  depends_on "automake"

  resource "Test::Simple" do
    url "https://www.cpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302086.tar.gz"
    sha256 "21e4c93c52529a10ef970afcf2cdb5719bcfef5f71af09cad3675fcf021995b1"
  end

  resource "Getopt::ArgvFile" do
    url "https://www.cpan.org/CPAN/authors/id/J/JS/JSTENZEL/Getopt-ArgvFile-1.11.tar.gz"
    sha256 "3709aa513ce6fd71d1a55a02e34d2f090017d5350a9bd447005653c9b0835b22"
  end

  resource "Carp::Assert" do
    url "https://www.cpan.org/CPAN/authors/id/N/NE/NEILB/Carp-Assert-0.21.tar.gz"
    sha256 "924f8e2b4e3cb3d8b26246b5f9c07cdaa4b8800cef345fa0811d72930d73a54e"
  end

  resource "File::Slurp" do
    url "https://www.cpan.org/CPAN/authors/id/U/UR/URI/File-Slurp-9999.19.tar.gz"
    sha256 "ce29ebe995097ebd6e9bc03284714cdfa0c46dc94f6b14a56980747ea3253643"
  end

  resource "Parse::Yapp" do
    url "https://www.cpan.org/CPAN/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.2.tar.gz"
    sha256 "4bd29f083c261253c6128303dc51bff88d6472c09c3846bd399e21f1f0c3e49a"
  end

  resource "Parse::Template" do
    url "https://www.cpan.org/CPAN/authors/id/P/PS/PSCUST/ParseTemplate-3.08.tar.gz"
    sha256 "3c7734f53999de8351a77cb09631d7a4a0482b6f54bca63d69d5a4eec8686d51"
  end

  resource "Parse::Lex" do
    url "https://www.cpan.org/CPAN/authors/id/P/PS/PSCUST/ParseLex-2.21.tar.gz"
    sha256 "f55f0a7d1e2a6b806a47840c81c16d505c5c76765cb156e5f5fd703159a4492d"
  end

  resource "Parse::RecDescent" do
    url "https://www.cpan.org/CPAN/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967003.tar.gz"
    sha256 "d4dac8dad012a7eef271a0ac8ec399f9e3b0b53902644df9c208daef8b4b7f0a"
  end

  resource "Math::Symbolic" do
    url "https://www.cpan.org/CPAN/authors/id/S/SM/SMUELLER/Math-Symbolic-0.612.tar.gz"
    sha256 "a9af979956c4c28683c535b5e5da3cde198c0cac2a11b3c9a129da218b3b9c08"
  end

  resource "YAML::Tiny" do
    url "https://www.cpan.org/CPAN/authors/id/E/ET/ETHER/YAML-Tiny-1.70.tar.gz"
    sha256 "bbce4b52b5eafdb04e3043975a08dbf394d00b7d2c958adb9d03d9f7e9291255"
  end

  resource "File::Remove" do
    url "https://www.cpan.org/CPAN/authors/id/S/SH/SHLOMIF/File-Remove-1.57.tar.gz"
    sha256 "b3becd60165c38786d18285f770b8b06ebffe91797d8c00cc4730614382501ad"
  end

  resource "inc::Module::Install::DSL" do
    url "https://www.cpan.org/CPAN/authors/id/E/ET/ETHER/Module-Install-1.18.tar.gz"
    sha256 "29068ac33502cec959844c206516c09cc4a847cb57327d41015f605153ca645e"
  end

  resource "Class::Inspector" do
    url "https://www.cpan.org/CPAN/authors/id/A/AD/ADAMK/Class-Inspector-1.28.tar.gz"
    sha256 "3ca4b7a3ed1f4cc846c9a3c08f9a6e9ec07a9cbfd92510dea9513db61a923112"
  end

  resource "File::ShareDir" do
    url "https://www.cpan.org/CPAN/authors/id/R/RE/REHSACK/File-ShareDir-1.102.tar.gz"
    sha256 "7c7334b974882587fbd9bc135f6bc04ad197abe99e6f4761953fe9ca88c57411"
  end

  resource "Template" do
    url "https://www.cpan.org/CPAN/authors/id/A/AB/ABW/Template-Toolkit-2.26.tar.gz"
    sha256 "e7e1cf36026f1ef96d8233e18a3fb39e1eafe9109edc639ecf25b20651cd76be"
  end

  resource "Graph" do
    url "https://www.cpan.org/CPAN/authors/id/J/JH/JHI/Graph-0.9704.tar.gz"
    sha256 "325e8eb07be2d09a909e450c13d3a42dcb2a2e96cc3ac780fe4572a0d80b2a25"
  end

  resource "thrust" do
    url "https://github.com/thrust/thrust/releases/download/1.8.2/thrust-1.8.2.zip"
    sha256 "00925daee4d9505b7f33d0ed42ab0de0f9c68c4ffbe2a41e6d04452cdee77b2d"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    perl_dir = Formula["perl"].bin.to_s
    perl = perl_dir + "/perl"

    resources.each do |r|
      r.stage do
        next if r.name == "thrust"
        perl_flags = "TT_ACCEPT=y" if r.name == "Template"
        system perl, "Makefile.PL", "INSTALL_BASE=#{libexec}", perl_flags
        system "make"
        system "make", "test" if build.with? "test"
        system "make", "install"
      end
    end

    resource("thrust").stage do
      (include/"thrust").install Dir["*"]
    end

    system perl, "Makefile.PL", "INSTALL_BASE=#{libexec}"

    system "make"
    rm "t/010_cpu.t" # remove test that fails in superenv
    system "make", "test" if build.with? "test"
    system "make", "install"

    bin.install libexec/"bin/libbi"
    (libexec/"share/test").install "Test.bi", "test.conf"
    env = {
      :PATH => perl_dir.chomp.concat(":\$PATH"),
      :PERL5LIB => ENV["PERL5LIB"].chomp.concat(":$PERL5LIB"),
      :CPPFLAGS => "\$CPPFLAGS -I#{HOMEBREW_PREFIX}/include",
      :LDFLAGS => "\$LDFLAGS -L#{HOMEBREW_PREFIX}/lib",
      :LD_LIBRARY_PATH => "#{HOMEBREW_PREFIX}/lib:\$LD_LIBRARY_PATH",
      :CXX => ENV["CXX"],
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  def caveats; <<~EOS
    libbi must be run with the same version of perl it was installed with.
    Changing perl versions might require a reinstall of libbi.
    EOS
  end

  test do
    cp Dir[libexec/"share/test/*"], testpath
    cd testpath do
      system "#{bin}/libbi", "sample", "@test.conf"
    end
  end
end
