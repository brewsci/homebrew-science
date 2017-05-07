class Tensorflow < Formula
  desc "Open-source software library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.1.0.tar.gz"
  sha256 "aad4470f52fa59f54de7b9a2da727429e6755d91d756f245f952698c42a60027"

  bottle do
    cellar :any
    sha256 "661e95754cfa35533f68af32701a70a72c0f732daa805e9a8f11434f70870840" => :sierra
    sha256 "7c8aa18046b2b203a00600e7e42efd01d515055764fa5b76bd29d14efc7a01a7" => :el_capitan
    sha256 "3c0af03fdef73be0482c0cb08fcdef3f9d69fce85b484e0d42e67aecc286dc87" => :yosemite
  end

  option "with-xla", "Enable XLA just-in-time compiler (experimental)"
  option "without-python", "Build without python2 support"

  depends_on "bazel" => :build
  depends_on "python" => :recommended
  depends_on :python3 => :optional

  with_pythons = []
  with_pythons << "without-python" if build.without?("python")
  with_pythons << "with-python3" if build.with?("python3")

  depends_on "numpy" => with_pythons
  depends_on "protobuf" => with_pythons

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    Language::Python.each_python(build) do |python, version|
      bundle_path = libexec/"lib/python#{version}/site-packages"
      bundle_path.mkpath
      ENV.prepend_path "PYTHONPATH", bundle_path

      resources.each do |package|
        package.stage do
          system python, *Language::Python.setup_install_args(libexec)
        end
      end
      (lib/"python#{version}/site-packages/homebrew-tensorflow-bundle.pth").write "#{bundle_path}\n"

      ENV["PYTHON_BIN_PATH"] = Formula[python].bin/"python#{version}"
      ENV["USE_DEFAULT_PYTHON_LIB_PATH"] = "1"
      ENV["CC_OPT_FLAGS"] = "-march=native"
      ENV["TF_NEED_JEMALLOC"] = "0"
      ENV["TF_NEED_GCP"] = "0"
      ENV["TF_NEED_HDFS"] = "0"
      ENV["TF_ENABLE_XLA"] = build.with?("xla") ? "1" : "0"
      ENV["TF_NEED_OPENCL"] = "0"
      ENV["TF_NEED_CUDA"] = "0"

      system "./configure"

      args = []
      unless build.bottle?
        args << "--copt=-mavx" if Hardware::CPU.avx?
        args << "--copt=-mavx2" if Hardware::CPU.avx2?
        args << "--copt=-msse4.1" if Hardware::CPU.sse4?
        args << "--copt=-msse4.2" if Hardware::CPU.sse4_2?
        args << "--copt=-mfma" if Hardware::CPU.features.include? :fma
      end

      system "bazel", "build", "--config=opt", *args, "//tensorflow/tools/pip_package:build_pip_package"

      tensorflow_pkg = Dir.mktmpdir
      system "bazel-bin/tensorflow/tools/pip_package/build_pip_package", tensorflow_pkg

      system Formula[python].bin/"pip#{version}", "install", "--prefix=#{prefix}", "-v", "--no-deps", Dir["#{tensorflow_pkg}/*.whl"][0]
    end
  end

  test do
    Language::Python.each_python(build) do |python, _|
      system python, "-c", "import tensorflow"
    end
  end
end
