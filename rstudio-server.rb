class RstudioServer < Formula
  desc "Integrated development environment (IDE) for R"
  homepage "http://www.rstudio.com"
  url "https://github.com/rstudio/rstudio/archive/v1.0.44.tar.gz"
  sha256 "43ece6cfdd1a13ac0e17f2a50154a30a1a14ad6c1b3cf381cc6007988ce44a0f"
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

  # RStudio assumes that boost is linked against libstdc++,
  # however homebrew/boost is linked against libc++
  # https://support.rstudio.com/hc/en-us/community/posts/211702327-Build-RStudio-against-libc-
  # https://github.com/rstudio/rstudio/commit/a07274ed4ef1b9eae3bfe672f3de1ff25b5b0856
  patch :DATA

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
    (gwt_lib/"selenium/chromedriver/2.7").install resource("chromedriver-mac")

    common_dir = buildpath/"dependencies/common"

    (common_dir/"dictionaries").install resource("dictionaries")
    (common_dir/"mathjax-26").install resource("mathjax")

    resource("pandoc").stage do
      (common_dir/"pandoc/1.17.2/").install "mac/pandoc"
      (common_dir/"pandoc/1.17.2/").install "mac/pandoc-citeproc"
    end

    resource("libclang").stage do
      (common_dir/"libclang/3.5/").install "mac/x86_64/libclang.dylib"
    end

    (common_dir/"libclang/builtin-headers").install resource("libclang-builtin-headers")

    mkdir "build" do
      system "cmake", "..",
        "-DRSTUDIO_TARGET=Server",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}",
        "-DBOOST_INCLUDEDIR=#{Formula["boost"].opt_include}",
        "-DCMAKE_INSTALL_PREFIX=#{prefix}/rstudio-server",
        "-DCMAKE_EXE_LINKER_FLAGS=-L#{Formula["openssl"].opt_lib} -L#{Formula["boost"].opt_lib}",
        "-DCMAKE_CXX_FLAGS=-I#{Formula["openssl"].opt_include}"
      system "make", "install"
    end

    (bin/"rserver").write <<-EOS.undent
        #!/usr/bin/env bash -l
        export LANG=${LANG:-en_US.UTF-8}
        exec #{opt_prefix}/rstudio-server/bin/rserver "$@"
    EOS

    bin.install_symlink prefix/"rstudio-server/bin/rstudio-server"
    share.install_symlink prefix/"rstudio-server/extras/launchd/com.rstudio.launchd.rserver.plist"
    # patch path to rserver
    inreplace "#{bin}/rstudio-server", "/rstudio-server/bin/rserver", "/bin/rserver"
    inreplace "#{share}/com.rstudio.launchd.rserver.plist", "/rstudio-server/bin/rserver", "/bin/rserver"
  end

  def caveats
    <<-EOS.undent
      - To test run RStudio Server,

        sudo #{opt_bin}/rserver --server-daemonize=0

      - To install the launching daemon of RStudio Server,

          sudo cp #{opt_share}/com.rstudio.launchd.rserver.plist \\
                /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist
          sudo launchctl load -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist

        If you have ever installed the daemon, you should reload the service

          sudo launchctl unload -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist
          sudo launchctl load -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist

      - To start/stop the launching daemon,

          sudo rstudio-server start
          sudo rstudio-server stop

      - To launch RStudio Server at boot, you could edit the plist file
        `/Library/LaunchDaemons/com.rstudio.launchd.rserver.plist`
        and change the value of `RunAtLoad` to `<true/>`.

      - To remove the launching daemon,

          sudo launchctl unload -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist
          sudo rm /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist

      - If \"Invalid username/password\" error occurs, try installing rstudio PAM by

          sudo cp /etc/pam.d/ftpd /etc/pam.d/rstudio

      - In default, only users with id >1000 are allowed to login. You could relax this
        requirement by modifiying the `ProgramArguments` section of the file
        `/Library/LaunchDaemons/com.rstudio.launchd.rserver.plist`

          <key>ProgramArguments</key>
          <array>
                  <string>#{opt_bin}/rserver</string>
                  <string>--server-daemonize=0</string>
                  <string>--auth-minimum-user-id=500</string>
          </array>

        and then reload the service

          sudo launchctl unload -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist
          sudo launchctl load -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist
    EOS
  end

  test do
    system "#{bin}/rstudio-server", "version"
  end
end

__END__
diff --git a/src/cpp/CMakeLists.txt b/src/cpp/CMakeLists.txt
index 94fd99c..6f68f7e 100644
--- a/src/cpp/CMakeLists.txt
+++ b/src/cpp/CMakeLists.txt
@@ -69,8 +69,6 @@ if(UNIX)
       EXECUTE_PROCESS(COMMAND /usr/bin/sw_vers -productVersion OUTPUT_VARIABLE MACOSX_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
       message(STATUS "Mac OS X version: ${MACOSX_VERSION}")
       if(NOT(${MACOSX_VERSION} VERSION_LESS "10.9"))
-         set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libstdc++")
-         set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -stdlib=libstdc++")
       endif()
    endif()
