'''
Matrix NTRU system as defined in Nayak 2008

MAIN FUNCTIONS:

- Set parameters: setParameters([n,q])
- Key generation: keygen()
- Encryption: encrypt(M,H)
- Decryption: decrypt(E,X,Xp)

NOTES:

- p is fixed as 3 as in the original paper

REFERENCES

Nayak, R., Sastry, C., and Pradhan, J. (2008). A matrix formulation for ntru cryptosystem.
In 2008 16th IEEE International Conference on Networks, pages 1–5. IEEE.

'''


from sage.matrix.constructor import random_matrix,Matrix, block_matrix

# p is fixed as 3

def setParameters(values = [2,32]):
    # declare global variables
    global n
    global p
    global q
    global Rp
    global Rq

    # set n,q
    p = 3
    n,q = values[0], values[1]

    # Define Rp and Rq using the parameters p and q
    Rp = IntegerModRing(p)
    Rq = IntegerModRing(q)


def getParameters():
    if 'n' in globals() and 'q' in globals():
        print("Parameters set: n = " + str(n) + ", p = 3, q = " + str(q))
    else:
        print("Parameters not yet set. Run setPrameters to start")



def keygen(maxit = 100000):
    #num_steps = 0
    for i in range(maxit):
    #    num_steps = i
        try:
            X = random_matrix(ZZ, nrows = n, ncols = n, x=-1, y=2)
            Xp = Matrix(Rp,X).inverse()
            Xq = Matrix(Rq,X).inverse()
            Y = random_matrix(ZZ, nrows = n, ncols = n, x=-1, y=2)
            H = Matrix(Rq,p * Xq * Y)
            break
        except:
            1
    #print("steps to find inverse:" + str(num_steps)) # in general, around 15 steps for n <= 100 and q <= 1024.
    #if(i == maxit - 1):
    #    raise ValueError("Can not find inverses of Xp and or Xq.")
    #else:
    return X,Y,Xp,Xq,H

def centerLift2(A,c):
    # without center lift the algorithm does not work. 
    B = matrix(ZZ,n,n)
    for i in range(n):
        for j in range(n):
            B[i,j] = ((int(A[i,j]) + c//2) % c) - c//2
    return(B)


def centerLift(A, c):
# runs faster than centerLift2, its original version.
    # Get the dimensions of the matrix A
    n = A.nrows()

    # Perform center lift using vectorized operations
    B = matrix(ZZ, n, n, lambda i, j: ((int(A[i, j]) + c // 2) % c) - c // 2)

    return B

def encrypt(M,H):

    R = random_matrix(ZZ, nrows = n, ncols = n, x=-1, y=2)
    E = H * R + M

    return Matrix(Rq,E)


def decrypt(E,X,Xp):

    A = Matrix(Rq,X * E)
    A1 = centerLift(A,q)
    B = Matrix(Rp,A1)
    B1 = centerLift(B,p)
    C = Matrix(Rp, Xp * B1)
    C1 = centerLift(C,p)

    return C1 


def randomMessage():
    M = random_matrix(ZZ, nrows = n, ncols = n, x=-1, y=2)
    return M

