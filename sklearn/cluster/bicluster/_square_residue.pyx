import numpy as np

cimport numpy as np
cimport cython

np.import_array()

ctypedef np.float64_t DOUBLE
ctypedef np.int64_t LONG

# TODO: try getting submatrix first

def square_residue(np.ndarray[LONG, ndim=1, mode="c"] rows,
                   np.ndarray[LONG, ndim=1, mode="c"] cols,
                   np.ndarray[DOUBLE, ndim=2, mode="c"] X):
    cdef int n_rows = len(rows)
    cdef int n_cols = len(cols)
    cdef float arr_mean = 0.0

    cdef np.ndarray[DOUBLE, ndim = 1, mode = "c"] row_mean = None
    cdef np.ndarray[DOUBLE, ndim = 1, mode = "c"] col_mean = None
    row_mean = np.zeros(n_rows, dtype=np.float, order="c")
    col_mean = np.zeros(n_cols, dtype=np.float, order="c")

    cdef float val = 0.0

    for i in range(n_rows):
        for j in range(n_cols):
            val = X[rows[i], cols[j]]
            row_mean[i] += val
            col_mean[j] += val
            arr_mean += val

    for i in range(n_rows):
        row_mean[i] /= n_cols
    for j in range(n_cols):
        col_mean[j] /= n_rows
    arr_mean /= (n_rows * n_cols)

    cdef np.ndarray[DOUBLE, ndim = 2, mode = "c"] result = None
    result = np.zeros((n_rows, n_cols,), dtype=np.float64, order="c")
    for i in range(n_rows):
        for j in range(n_cols):
            val = (X[rows[i], cols[j]] - row_mean[i] - col_mean[j] + arr_mean)
            result[i, j] = val * val
    return result
