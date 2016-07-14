class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "http://matio.sourceforge.net"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.8/matio-1.5.8.tar.gz"
  sha256 "6e49353d1d9d5127696f2e67b46cf9a1dc639663283c9bc4ce5280489c03e1f0"

  bottle do
    cellar :any
    sha256 "fc4f887587a4faf0efa6093e0c38cd172b8a9f3bb44e062d166ebdb34c44335c" => :el_capitan
    sha256 "92c4859f40adb08e7f98766a55c25daf5b4bffc000c9aa51ede93c2b46ac39c2" => :yosemite
    sha256 "ed278812215d9647a7451de2694995f6f028f27197223d195a677f1136c6d4f4" => :mavericks
  end

  option :universal
  option "with-hdf5", "Enable support for newer MAT files that use the HDF5-format"

  depends_on "hdf5" => :optional

  # sample MATLAB file from http://web.uvic.ca/~monahana/eos225/matlab_tutorial/tutorial_5/working_with_data.html
  resource "test_mat_file" do
    url "http://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
    sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
  end

  def install
    ENV.universal_binary if build.universal?
    args = %W[
      --prefix=#{prefix}
      --with-zlib=/usr
      --enable-extended-sparse=yes
    ]

    if build.with? "hdf5"
      args << "--with-hdf5=#{HOMEBREW_PREFIX}" << "--enable-mat73=yes"
    else
      args << "--with-hdf5=no"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("test_mat_file")
    mv "poc_data.mat.sfx", "test.mat"
    (testpath/"not-a-mat-file.mat").write("Not a mat file\n")
    (testpath/"mat.c").write <<-'EOS'.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <matio.h>
      #include <errno.h>
      int main(int argc, char **argv)
      {
        mat_t *matfp;
        errno = 0;
        matfp = Mat_Open(argv[1], MAT_ACC_RDONLY);
        if (NULL == matfp) {
          printf("errno %d", errno);
          return EXIT_FAILURE;
        }
        printf("errno %d", errno);
        Mat_Close(matfp);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    assert_equal "errno 2", shell_output("./mat no-such-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat not-a-mat-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat test.mat")
  end
end
