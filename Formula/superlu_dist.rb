 class SuperluDist < Formula
  desc ""
  homepage "https://github.com/xiaoyeli/superlu_dist/"
  version "5.3.0"
  url "https://github.com/xiaoyeli/superlu/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "3e464afa77335de200aeb739074a11e96d9bef6d0b519950cfa6684c4be1f350"

  depends_on "cmake"
  depends_on "metis"
  depends_on "openblas"
  depends_on "open-mpi"
  depends_on "marcalexanderschweitzer/science/parmetis"

  def install


    args = %W[
      -TPL_ENABLE_PARMETISLIB=ON
      -DTPL_PARMETIS_INCLUDE_DIRS="#{Formula["parmetis"].opt_include};#{Formula["metis"].opt_include};"
      -DTPL_PARMETIS_LIBRARIES="#{Formula["parmetis"].opt_lib}/libparmetis.dylib;#{Formula["metis"].opt_lib}/libmetis.dylib"
      -DTPL_BLAS_LIBRARIES="#{Formula["openblas"].opt_lib}/libopenblas.dylib"
      -DCMAKE_C_COMPILER="mpicc"
      -DCMAKE_CXX_COMPILER="mpicxx"
      -DCMAKE_CXX_FLAGS="-std=c++11" \
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

  end
end
