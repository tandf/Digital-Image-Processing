#include "mex.h"
#include <cstring>

// mexFunction相当于mex中的main函数
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
    // plhs输出矩阵的指针数组; prhs输入矩阵的指针数组；
    // nlhs输出矩阵的个数; nrhs输入矩阵的个数；
    // mxArray是mex文件中的矩阵数据结构，是交互的核心

    long size = *mxGetPr(prhs[0]); // 获得prhs的第1个元素
    plhs[0] = mxCreateDoubleMatrix(size, size, mxREAL); // 创建新的矩阵，作为输出的第1个元素
    double list[size * 2 - 1];
    for (int i = 0; i < size * 2; ++i)
        list[i] = 1.0 / (i + 1);
    double* outCursor = mxGetPr(plhs[0]);
    for (int ii = 0; ii < size; ii++)
        memcpy(outCursor + size*ii, list + ii, size*sizeof(double));
}
