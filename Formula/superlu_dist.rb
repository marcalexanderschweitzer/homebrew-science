 class SuperluDist < Formula
  desc ""
  homepage "https://github.com/xiaoyeli/superlu_dist/"
  version "8.1.0"
  url "https://github.com/xiaoyeli/superlu_dist/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "9308844b99a7e762d5704934f7e9f79daf158b0bfc582994303c2e0b31518b34"

  depends_on "cmake"
  depends_on "metis"
  depends_on "openblas"
  depends_on "open-mpi"
  depends_on "marcalexanderschweitzer/science/parmetis"

  def install
    args = %W[
      -DCMAKE_C_COMPILER=#{Formula["open-mpi"].opt_bin}/mpicc
      -DCMAKE_CXX_COMPILER=#{Formula["open-mpi"].opt_bin}/mpicxx
      -DCMAKE_CXX_FLAGS=-std=c++11 
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_STATIC_LIBS=OFF
      -DTPL_ENABLE_PARMETISLIB=ON
      -DTPL_ENABLE_INTERNAL_BLASLIB=OFF
      -DTPL_BLAS_LIBRARIES=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -DXSDK_ENABLE_Fortran=OFF
      -Denable_openmp=OFF
    ]

    args << "-DTPL_PARMETIS_INCLUDE_DIRS=#{Formula["parmetis"].opt_include};#{Formula["metis"].opt_include} -DTPL_PARMETIS_LIBRARIES=#{Formula["parmetis"].opt_lib}/libparmetis.dylib;#{Formula["metis"].opt_lib}/libmetis.dylib"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

  end
end
