/******************************************************************************

                              Online C++ Compiler.
               Code, Compile, Run and Debug C++ program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <bits/stdc++.h>

using namespace std;
string s[64];
int mat[64][5][5];
int temp[64][5][5];
int par[64][5];
int rt[5][5];
unsigned long long rc[24];

void prnt(){
    for (int k = 0; k < 64; k++) {
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                cout << mat[k][j][i];
            }
        }
        cout << endl;
    }
}

void colPar() {
    for (int k = 0; k < 64; k++) {
        for (int i = 0; i < 5; i++) {
            par[k][i] = 0;
            for (int j = 0; j < 5; j++) {
                par[k][i] ^= mat[k][j][i];
            }
        }
    }
    for (int k = 0; k < 64; k++) {
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                mat[k][j][i] ^= par[k][(i+4)%5] ^ par[(k+63)%64][(i+1)%5];
            }
        }
    }
}

void rotateF() {
    rt[0][0] = 21;
    rt[0][1] = 8;
    rt[0][2] = 41;
    rt[0][3] = 45;
    rt[0][4] = 15;
    rt[1][0] = 56;
    rt[1][1] = 14;
    rt[1][2] = 18;
    rt[1][3] = 2;
    rt[1][4] = 61;
    rt[2][0] = 28;
    rt[2][1] = 27;
    rt[2][2] = 0;
    rt[2][3] = 1;
    rt[2][4] = 62;
    rt[3][0] = 55;
    rt[3][1] = 20;
    rt[3][2] = 36;
    rt[3][3] = 44;
    rt[3][4] = 6;
    rt[4][0] = 25;
    rt[4][1] = 39;
    rt[4][2] = 3;
    rt[4][3] = 10;
    rt[4][4] = 43;
    for (int k = 0; k < 64; k++) {
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                temp[k][j][i] = mat[(k - rt[j][i] + 64) % 64][j][i];
            }
        }
    }
    for (int k = 0; k < 64; k++) {
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                mat[k][j][i] = temp[k][j][i];
            }
        }
    }
}

void permuteF() {
    for (int k = 0; k < 64; k++) {
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                temp[k][(2 * (i + 3) + 3 * (j + 3) + 2) % 5][j] = mat[k][j][i];
            }
        }
    }
    for (int k = 0; k < 64; k++) {
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                mat[k][j][i] = temp[k][j][i];
            }
        }
    }
}

void reval() {
    for (int k = 0; k < 64; k++) {
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                temp[k][j][i] = mat[k][j][i] ^ (~mat[k][j][(i+1)%5] & mat[k][j][(i+2)%5]);
            }
        }
    }
    for (int k = 0; k < 64; k++) {
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                mat[k][j][i] = temp[k][j][i];
            }
        }
    }
}

void addRC(int round) {
    rc[0] = 0x0000000000000001ULL;
    rc[1] = 0x0000000000008082ULL;
    rc[2] = 0x800000000000808AULL;
    rc[3] = 0x8000000080008000ULL;
    rc[4] = 0x000000000000808BULL;
    rc[5] = 0x0000000080000001ULL;
    rc[6] = 0x8000000080008081ULL;
    rc[7] = 0x8000000000008009ULL;
    rc[8] = 0x000000000000008AULL;
    rc[9] = 0x0000000000000088ULL;
    rc[10] = 0x0000000080008009ULL;
    rc[11] = 0x000000008000000AULL;
    rc[12] = 0x000000008000808BULL;
    rc[13] = 0x800000000000008BULL;
    rc[14] = 0x8000000000008089ULL;
    rc[15] = 0x8000000000008003ULL;
    rc[16] = 0x8000000000008002ULL;
    rc[17] = 0x8000000000000080ULL;
    rc[18] = 0x000000000000800AULL;
    rc[19] = 0x800000008000000AULL;
    rc[20] = 0x8000000080008081ULL;
    rc[21] = 0x8000000000008080ULL;
    rc[22] = 0x0000000080000001ULL;
    rc[23] = 0x8000000080008008ULL;
    for (int k = 0; k < 64; k++) {
        int b = (rc[round] >> (63 - k)) & 1;
        mat[k][2][2] ^= b;
    }
}

int main()
{
    for (int i = 0; i < 64; i++){
        cin >> s[i];
        for (int j = 0; j < 5; j++){
            for (int k = 0; k < 5; k++){
                mat[i][j][k] = s[i][j*5+k] - '0';
            }
        }
    }
    for (int rnd = 0; rnd < 24; rnd++) {
        colPar();
        rotateF();
        permuteF();
        reval();
        addRC(rnd);
    }
    cout << "\noutput:\n" << endl;
    prnt();
    return 0;
}
