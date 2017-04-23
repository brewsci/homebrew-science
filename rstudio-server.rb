class RstudioServer < Formula
  desc "Integrated development environment (IDE) for R"
  homepage "https://www.rstudio.com"
  url "https://github.com/rstudio/rstudio/archive/v1.0.143.tar.gz"
  sha256 "8ae88731b4474e5e2ff9030aa14e168903fe3a7ffc4fa716f497084a86801062"
  head "https://github.com/rstudio/rstudio.git"

  bottle do
    cellar :any
    sha256 "c002ebdb7b2b4ee774f658725084e1798c2d61e018e5218ea13f4c87e5652964" => :sierra
    sha256 "3425f9dc24546f067e33426a5445578d90828728708590159044be1afa341f29" => :el_capitan
    sha256 "7dd399c4f93c935295def9044c062f9dac2425049b715c8abd4815fc43ca060c" => :yosemite
  end

  depends_on "ant" => :build
  depends_on "cmake" => :build
  depends_on "r" => :recommended
  if OS.linux?
    depends_on "linuxbrew/extra/linux-pam" => :recommended
    depends_on "libuuid" => :recommended
    depends_on "libffi" => :recommended
    depends_on "jdk" => :recommended
    depends_on "patchelf"
  end
  depends_on "boost"
  depends_on "openssl"

  resource "gin" do
    url "https://s3.amazonaws.com/rstudio-buildtools/gin-1.5.zip"
    sha256 "f561f4eb5d5fe1cff95c881e6aed53a86e9f0de8a52863295a8600375f96ab94"
  end

  resource "gwt" do
    url "https://s3.amazonaws.com/rstudio-buildtools/gwt-2.7.0.zip"
    sha256 "aa65061b73836190410720bea422eb8e787680d7bc0c2b244ae6c9a0d24747b3"
  end

  resource "junit" do
    url "https://s3.amazonaws.com/rstudio-buildtools/junit-4.9b3.jar"
    sha256 "dc566c3f5da446defe36c534f7ee19cdfe7e565020038b2ef38f01bc9c070551"
  end

  resource "selenium" do
    url "https://s3.amazonaws.com/rstudio-buildtools/selenium-java-2.37.0.zip"
    sha256 "0eebba65d8edb01c1f46e462907c58f5d6e1cb0ddf63660a9985c8432bdffbb7"
  end

  resource "selenium-server" do
    url "https://s3.amazonaws.com/rstudio-buildtools/selenium-server-standalone-2.37.0.jar"
    sha256 "97bc8c699037fb6e99ba7af570fb60dbb1b7ce30cde2448287a44ef65b13023e"
  end

  resource "chromedriver-mac" do
    url "https://s3.amazonaws.com/rstudio-buildtools/chromedriver-mac"
    sha256 "5bf42fd9bcc45d45b54a0f59d5839feb454f39fd14170b8fab7f59bf59b1af64"
  end

  resource "chromedriver-linux" do
    url "https://s3.amazonaws.com/rstudio-buildtools/chromedriver-linux"
    sha256 "1ff3e9fc17e456571c440ab160f25ee451b2a4d36e61c8e297737cff7433f48c"
  end

  resource "dictionaries" do
    url "https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip"
    sha256 "4341a9630efb9dcf7f215c324136407f3b3d6003e1c96f2e5e1f9f14d5787494"
  end

  resource "mathjax" do
    url "https://s3.amazonaws.com/rstudio-buildtools/mathjax-26.zip"
    sha256 "939a2d7f37e26287970be942df70f3e8f272bac2eb868ce1de18bb95d3c26c71"
  end

  resource "pandoc" do
    url "https://s3.amazonaws.com/rstudio-buildtools/pandoc-1.17.2.zip"
    sha256 "887991ffbe191278ddc010146c8ab3e98810932d08a6201245a8acb1ddc38390"
  end

  resource "libclang" do
    url "https://s3.amazonaws.com/rstudio-buildtools/libclang-3.5.zip"
    sha256 "ecb06fb65ddf0eb7c04be28edd11cc38717102afbe4dbfd6e237ea58d1da85ea"
  end

  resource "libclang-builtin-headers" do
    url "https://s3.amazonaws.com/rstudio-buildtools/libclang-builtin-headers.zip"
    sha256 "0b8f54c8d278dd5cd2fb3ec6f43e9ea1bfc9e8d595ff88127073d46550e88a74"
  end

  if build.head?
    resource "rsconnect" do
      url "https://github.com/rstudio/rsconnect.git", :branch => "master"
    end

    resource "rmarkdown" do
      url "https://github.com/rstudio/rmarkdown.git", :branch => "master"
    end
  end

  unless build.head?
    # this piece of code has been removed from RStudio master as R API has changed.
    patch :DATA
  end

  def which_linux_distribution
    if File.exist?("/etc/redhat-release") || File.exist?("/etc/centos-release")
      distritbuion = "rpm"
    else
      distritbuion = "debian"
    end
    distritbuion
  end

  def install
    unless build.head?
      ENV["RSTUDIO_VERSION_MAJOR"] = version.to_s.split(".")[0]
      ENV["RSTUDIO_VERSION_MINOR"] = version.to_s.split(".")[1]
      ENV["RSTUDIO_VERSION_PATCH"] = version.to_s.split(".")[2]
    end

    gwt_lib = buildpath/"src/gwt/lib/"
    (gwt_lib/"gin/1.5").install resource("gin")
    (gwt_lib/"gwt/2.7.0").install resource("gwt")
    gwt_lib.install resource("junit")
    (gwt_lib/"selenium/2.37.0").install resource("selenium")
    (gwt_lib/"selenium/2.37.0").install resource("selenium-server")
    if OS.linux?
      (gwt_lib/"selenium/chromedriver/2.7").install resource("chromedriver-linux")
    elsif OS.mac?
      (gwt_lib/"selenium/chromedriver/2.7").install resource("chromedriver-mac")
    end

    common_dir = buildpath/"dependencies/common"

    (common_dir/"dictionaries").install resource("dictionaries")
    (common_dir/"mathjax-26").install resource("mathjax")

    if build.head?
      (common_dir/"rsconnect").install resource("rsconnect")
      (common_dir/"rmarkdown").install resource("rmarkdown")
    end

    resource("pandoc").stage do
      if OS.linux?
        arch = Hardware::CPU.is_64_bit? ? "x86_64" : "i686"

        (common_dir/"pandoc/1.17.2/").install "linux/#{which_linux_distribution}/#{arch}/pandoc"
        (common_dir/"pandoc/1.17.2/").install "linux/#{which_linux_distribution}/#{arch}/pandoc-citeproc"
      elsif OS.mac?
        (common_dir/"pandoc/1.17.2/").install "mac/pandoc"
        (common_dir/"pandoc/1.17.2/").install "mac/pandoc-citeproc"
      end
    end

    resource("libclang").stage do
      (common_dir/"libclang/3.5/").install OS.linux? ? "linux/x86_64/libclang.so" : "mac/x86_64/libclang.dylib"
    end

    (common_dir/"libclang/builtin-headers").install resource("libclang-builtin-headers")

    mkdir "build" do
      args = ["-DRSTUDIO_TARGET=Server", "-DCMAKE_BUILD_TYPE=Release"]
      args << "-DRSTUDIO_USE_LIBCXX=Yes"
      args << "-DRSTUDIO_USE_SYSTEM_BOOST=Yes"
      args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
      args << "-DBOOST_INCLUDEDIR=#{Formula["boost"].opt_include}"
      args << "-DBOOST_LIBRARYDIR=#{Formula["boost"].opt_lib}"
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}/rstudio-server"
      args << "-DCMAKE_CXX_FLAGS=-I#{Formula["openssl"].opt_include}"

      linkerflags = "-DCMAKE_EXE_LINKER_FLAGS=-L#{Formula["openssl"].opt_lib} -L#{Formula["boost"].opt_lib}"
      if OS.linux?
        linkerflags += " -L#{Formula["linux-pam"].opt_lib}" if build.with? "linux-pam"
      end
      args << linkerflags

      args << "-DPAM_INCLUDE_DIR=#{Formula["linux-pam"].opt_include}" if build.with? "linux-pam"

      system "cmake", "..", *args
      system "make", "install"
    end
    bin.install_symlink prefix/"rstudio-server/bin/rserver"
    bin.install_symlink prefix/"rstudio-server/bin/rstudio-server"
    prefix.install_symlink prefix/"rstudio-server/extras"
  end

  def post_install
    # patch path to rserver
    Dir.glob(prefix/"extras/**/*") do |f|
      if File.file?(f) && !File.readlines(f).grep(%r{#{prefix/"rstudio-server/bin/rserver"}}).empty?
        inreplace f, %r{#{prefix/"rstudio-server/bin/rserver"}}, opt_bin/"rserver"
      end
    end
    if OS.linux?
      # brew patchelf rstudio-server
      keg = Keg.new(prefix)
      keg.relocate_dynamic_linkage Keg::Relocation.new(
        :old_prefix => Keg::PREFIX_PLACEHOLDER,
        :old_cellar => Keg::CELLAR_PLACEHOLDER,
        :old_repository => Keg::REPOSITORY_PLACEHOLDER,
        :new_prefix => HOMEBREW_PREFIX.to_s,
        :new_cellar => HOMEBREW_CELLAR.to_s,
        :new_repository => HOMEBREW_REPOSITORY.to_s,
      )
    end
  end

  def caveats
    if OS.linux?
      if which_linux_distribution == "rpm"
        daemon = <<-EOS
              sudo cp #{opt_prefix}/extras/systemd/rstudio-server.redhat.service /etc/systemd/system/
        EOS
      else
        daemon = <<-EOS
              sudo cp #{opt_prefix}/extras/systemd/rstudio-server.service /etc/systemd/system/
        EOS
      end
    elsif OS.mac?
      daemon = <<-EOS
              If it is an upgrade or the plist file exists, unload the plist first
              sudo launchctl unload -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist

              sudo cp #{opt_prefix}/extras/launchd/com.rstudio.launchd.rserver.plist /Library/LaunchDaemons/
              sudo launchctl load -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist
      EOS
    end
    <<-EOS.undent
      - To test run RStudio Server,
          sudo #{opt_bin}/rserver --server-daemonize=0

      - To complete the installation of RStudio Server
          1. register RStudio daemon
#{daemon}
          2. install the PAM configuration
              sudo cp #{opt_prefix}/extras/pam/rstudio /etc/pam.d/

          3. sudo rstudio-server start

      - In default, only users with id >1000 are allowed to login. To relax
        requirement, add the following option to the configuration file located
        in `/etc/rstudio/rserver.conf`

          auth-minimum-user-id=500
    EOS
  end

  test do
    system "#{bin}/rstudio-server", "version"
  end
end

__END__
diff --git a/src/cpp/r/RRoutines.cpp b/src/cpp/r/RRoutines.cpp
--- a/src/cpp/r/RRoutines.cpp
+++ b/src/cpp/r/RRoutines.cpp
@@ -54,14 +54,6 @@ void registerAll()
    R_CMethodDef* pCMethods = NULL;
    if (s_cMethods.size() > 0)
    {
-      R_CMethodDef nullMethodDef ;
-      nullMethodDef.name = NULL ;
-      nullMethodDef.fun = NULL ;
-      nullMethodDef.numArgs = 0 ;
-      nullMethodDef.types = NULL;
-      nullMethodDef.styles = NULL;
-      s_cMethods.push_back(nullMethodDef);
-      pCMethods = &s_cMethods[0];
    }
