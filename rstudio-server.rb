class RstudioServer < Formula
  homepage "http://www.rstudio.com"
  url "https://github.com/rstudio/rstudio/archive/v0.98.1103.tar.gz"
  sha256 "084049aae03cbaaa74a848f491d57cffab5ea67372ece0e256d54e04bd5fc6da"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "f565aadae5569dfbf64d48c9985929ef92e3736e2f59625b180f74bc2c92c11c" => :yosemite
    sha256 "de79c98f73085962bb880abad93036b8d0ddd35d2faad630806326337a40b862" => :mavericks
  end

  depends_on "ant" => :build
  depends_on "cmake" => :build
  depends_on "homebrew/versions/boost150" => :build
  depends_on "r"
  depends_on "openssl"

  resource "gin" do
    url "https://s3.amazonaws.com/rstudio-buildtools/gin-1.5.zip"
    sha256 "f561f4eb5d5fe1cff95c881e6aed53a86e9f0de8a52863295a8600375f96ab94"
  end

  resource "gwt" do
    url "https://s3.amazonaws.com/rstudio-buildtools/gwt-2.6.0.zip"
    sha256 "bd4c13a5d1078446d519a742ee233971e55c447d1b87ffd5b1f90e54dd876b9a"
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

  resource "pandoc" do
    url "https://s3.amazonaws.com/rstudio-buildtools/pandoc-1.13.1.zip"
    sha256 "7aedb183913f46cc7e5fd35098e5ed275c5436da0a0f82d5d56c057fd27caf5f"
  end

  resource "dictionaries" do
    url "https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip"
    sha256 "4341a9630efb9dcf7f215c324136407f3b3d6003e1c96f2e5e1f9f14d5787494"
  end

  resource "mathjax" do
    url "https://s3.amazonaws.com/rstudio-buildtools/mathjax-23.zip"
    sha256 "5242d35eb5f0d6fae295422b39a61070c17f9a7923e6bc996c74b9a825c1d699"
  end

  resource "shinyapps" do
    url "https://github.com/rstudio/shinyapps.git", :branch => "v0.98.1000"
  end

  def install
    # installation path of boost is hard coded, it has to be changed manually.
    inreplace "src/cpp/CMakeLists.txt",
      "/opt/rstudio-tools/boost/boost_1_50_0",
      "#{Formula["boost150"].opt_prefix}"

    gwt_lib = buildpath/"src/gwt/lib/"
    (gwt_lib/"gin/1.5").install resource("gin")
    (gwt_lib/"gwt/2.6.0").install resource("gwt")
    gwt_lib.install resource("junit")
    (gwt_lib/"selenium/2.37.0").install resource("selenium")
    (gwt_lib/"selenium/2.37.0").install resource("selenium-server")
    (gwt_lib/"selenium/chromedriver/2.7").install resource("chromedriver-mac")

    resource("pandoc").stage do
      (buildpath/"dependencies/common/pandoc/1.13.1/").install "mac/pandoc"
      (buildpath/"dependencies/common/pandoc/1.13.1/").install "mac/pandoc-citeproc"
    end

    (buildpath/"dependencies/common/dictionaries").install resource("dictionaries")
    (buildpath/"dependencies/common/mathjax-23").install resource("mathjax")
    (buildpath/"dependencies/common/shinyapps").install resource("shinyapps")
    chdir("dependencies/common") { system "R", "CMD", "build", "shinyapps" }

    mkdir "build" do
      system "cmake", "..",
        "-DRSTUDIO_TARGET=Server",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DBOOST_ROOT=#{Formula["boost150"].opt_prefix}",
        "-DBoost_INCLUDE_DIR=#{Formula["boost150"].opt_prefix}/include",
        "-DCMAKE_INSTALL_PREFIX=#{prefix}/rstudio"
      system "make", "install"
    end

    (bin/"rstudio-server").write <<-EOS.undent
      #!/usr/bin/env bash

      export PATH=#{opt_prefix}/rstudio/bin:$PATH
      export PATH=#{opt_prefix}/rstudio/bin/pandoc:$PATH
      export PATH=#{opt_prefix}/rstudio/bin/postback:$PATH

      #{opt_prefix}/rstudio/bin/rserver "$@"
    EOS
  end

  test do
    system "rstudio-server", "--help"
  end
end
