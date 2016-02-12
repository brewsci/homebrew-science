class RstudioServer < Formula
  homepage "http://www.rstudio.com"
  head "https://github.com/rstudio/rstudio.git"
  url "https://github.com/rstudio/rstudio/archive/v0.99.878.tar.gz"
  sha256 "e02b7423c62820c2ab35a5889711c7ff08102b292e664502c977e431ad15c7b5"

  bottle do
    sha256 "de1d21783adbc2c091fa463966d9667310aa3208e6677041d46d3aff8cbe1945" => :el_capitan
    sha256 "d19c47da684e4f9cb85c18319cdcd5d16bba84a20df7fdf7ec9e12573f9d6a12" => :yosemite
    sha256 "a8e0d7dc2e2cfb544c643e5d1aa2a489ed13dee7a9116968f93fe83b4f2c6c84" => :mavericks
  end

  depends_on "ant" => :build
  depends_on "cmake" => :build
  depends_on "homebrew/versions/boost150"
  depends_on "r"
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
    url "https://s3.amazonaws.com/rstudio-buildtools/mathjax-23.zip"
    sha256 "5242d35eb5f0d6fae295422b39a61070c17f9a7923e6bc996c74b9a825c1d699"
  end

  resource "pandoc" do
    url "https://s3.amazonaws.com/rstudio-buildtools/pandoc-1.15.2.zip"
    sha256 "ebd94d50a95fb9e141d0fa37e51ee89ebbba5d0d0b03365b1541750092399201"
  end

  resource "libclang" do
    url "https://s3.amazonaws.com/rstudio-buildtools/libclang-3.5.zip"
    sha256 "ecb06fb65ddf0eb7c04be28edd11cc38717102afbe4dbfd6e237ea58d1da85ea"
  end

  resource "libclang-builtin-headers" do
    url "https://s3.amazonaws.com/rstudio-buildtools/libclang-builtin-headers.zip"
    sha256 "0b8f54c8d278dd5cd2fb3ec6f43e9ea1bfc9e8d595ff88127073d46550e88a74"
  end

  resource "rsconnect" do
    url "https://github.com/rstudio/rsconnect.git", :branch => "master"
  end

  def install

    gwt_lib = buildpath/"src/gwt/lib/"
    (gwt_lib/"gin/1.5").install resource("gin")
    (gwt_lib/"gwt/2.7.0").install resource("gwt")
    gwt_lib.install resource("junit")
    (gwt_lib/"selenium/2.37.0").install resource("selenium")
    (gwt_lib/"selenium/2.37.0").install resource("selenium-server")
    (gwt_lib/"selenium/chromedriver/2.7").install resource("chromedriver-mac")

    common_dir = buildpath/"dependencies/common"

    (common_dir/"dictionaries").install resource("dictionaries")
    (common_dir/"mathjax-23").install resource("mathjax")

    resource("pandoc").stage do
      (common_dir/"pandoc/1.15.2/").install "mac/pandoc"
      (common_dir/"pandoc/1.15.2/").install "mac/pandoc-citeproc"
    end

    resource("libclang").stage do
      (common_dir/"libclang/3.5/").install "mac/x86_64/libclang.dylib"
    end

    (common_dir/"libclang/builtin-headers").install resource("libclang-builtin-headers")

    (common_dir/"rsconnect").install resource("rsconnect")
    chdir("dependencies/common") { system "R", "CMD", "build", "rsconnect" }

    mkdir "build" do
      system "cmake", "..",
        "-DRSTUDIO_TARGET=Server",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DBOOST_ROOT=#{Formula["boost150"].opt_prefix}",
        "-DBoost_INCLUDE_DIR=#{Formula["boost150"].opt_prefix}/include",
        "-DCMAKE_INSTALL_PREFIX=#{prefix}/rstudio",
        "-DCMAKE_EXE_LINKER_FLAGS=-L#{Formula["openssl"].opt_prefix}/lib",
        "-DCMAKE_CXX_FLAGS=-I#{Formula["openssl"].opt_prefix}/include"
      system "make", "install"
    end

    bin.install_symlink prefix/"rstudio/bin/rserver" => "rstudio-server"

    (prefix/"etc/org.rstudio.launchd.rserver.plist").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
              "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
              <key>Label</key>
              <string>com.rstudio.launchd.rstudio</string>
              <key>ProgramArguments</key>
              <array>
                      <string>#{opt_prefix}/rstudio/bin/rserver</string>
              </array>
              <key>RunAtLoad</key>
              <true/>
      </dict>
      </plist>
    EOS
  end

  def caveats
    <<-EOS.undent
      If you get \"Invalid username/password\" error,
      install rstudio PAM by

        sudo cp /etc/pam.d/ftpd /etc/pam.d/rstudio

      To configure the server to start at boot

        sudo cp #{opt_prefix}/etc/org.rstudio.launchd.rserver.plist /Library/LaunchDaemons/org.rstudio.launchd.rserver.plist
        sudo defaults write /Library/LaunchDaemons/org.rstudio.launchd.rserver.plist Disabled -bool false
        sudo launchctl load /Library/LaunchDaemons/org.rstudio.launchd.rserver.plist
    EOS
  end

  test do
    system "rstudio-server", "--help"
  end
end
