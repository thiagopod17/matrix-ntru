# matrix-ntru

A SageMath implementation of the matrix NTRU cryptosystem, a lattice-based
public-key scheme where keys and messages are integer matrices instead of
polynomials. This repo implements the system as defined in Nayak et al.
(2008), together with an LLL/BKZ lattice-reduction attack that recovers the
private key (and, from it, encrypted messages), as described in do Rego
Sousa and Carneiro (2024).

Warning: this is research/experimental code for studying the scheme and its
attack, not a production-ready cryptographic implementation.

## Usage

Requires [SageMath](https://www.sagemath.org/) with a Jupyter kernel.

```
# in a Sage session or notebook cell
load("matrix_ntru_system.sage")

setParameters([7, 256])      # n, q (p is fixed at 3)
X, Y, Xp, Xq, H = keygen()   # private key (X,Y,Xp,Xq), public key H

M = randomMessage()
E = encrypt(M, H)
C = decrypt(E, X, Xp)
C == M
```

Suggested order to open the notebooks:

1. `EXAMPLES.ipynb` — walks through the basic usage above (set parameters,
   key generation, encryption, decryption).
2. `matrix_ntru_system_test.ipynb` — sanity/consistency checks on the core
   system (key generation, decryption failure probability, permutation
   invariance).
3. `lattice_attack.ipynb` — builds the NTRU lattice from the public key,
   runs BKZ, and measures how many rows of the private key are recovered
   (with a simulation study over `n`).
4. `lattice_attack-may.ipynb` — a dimension-reduced variant of the same
   attack (May's idea of cutting lattice columns before running BKZ).
5. `matrix_ntru_attack.ipynb` — uses the BKZ-reduced lattice to build a
   substitute private key and decrypt an intercepted message without ever
   seeing the real private key.

## Functions

Core system (`matrix_ntru_system.sage`):

| Function | Description |
|---|---|
| `setParameters([n, q])` | Sets the global system parameters `n`, `q` (`p` fixed at 3) and the rings `Rp`, `Rq` |
| `getParameters()` | Prints the currently set parameters |
| `keygen(maxit=100000)` | Generates the private key `(X, Y)`, its inverses `(Xp, Xq)` mod `p` and `q`, and the public key `H` |
| `encrypt(M, H)` | Encrypts a message matrix `M` with the public key `H` |
| `decrypt(E, X, Xp)` | Decrypts ciphertext `E` with the private key `(X, Xp)` |
| `randomMessage()` | Generates a random message matrix with entries in `{-1, 0, 1}` |
| `centerLift(A, c)` / `centerLift2(A, c)` | Center-lifts a matrix `A` mod `c` into the range `(-c/2, c/2]` |

Attack notebooks:

| Function | Notebook | Description |
|---|---|---|
| `matrixNTRULattice(H, n, p, q)` | `lattice_attack.ipynb`, `lattice_attack-may.ipynb` | Builds the NTRU lattice basis from the public key `H` |
| `matrixNTRULatticeAttack(H, n, p, q, X, Y)` | `lattice_attack.ipynb` | Reduces the lattice with BKZ and counts how many rows of the private key `(X, Y)` it recovers |
| `count_corresponding_lines(A, B)` | `lattice_attack.ipynb`, `lattice_attack-may.ipynb` | Counts rows of `A` that appear (up to sign) as rows of `B` |
| `may_attack_fixed_seed(n, p, q, cut, seed_id)` | `lattice_attack-may.ipynb` | Runs the private-key attack with `cut` columns removed before BKZ (May's dimension reduction) |
| `run_attack_and_save_results(...)` | `lattice_attack-may.ipynb` | Runs `may_attack_fixed_seed` over ranges of cuts/seeds and writes results to CSV |
| `reduceL(H, n, p, q)` | `matrix_ntru_attack.ipynb` | Builds the lattice and returns the BKZ-reduced candidate private key |
| `attack(n, q, verbose=False)` | `matrix_ntru_attack.ipynb` | Full message-recovery attack: generates a key pair and message, then decrypts using only the BKZ-derived key |

## Repository layout

- `matrix_ntru_system.sage` — core cryptosystem: parameters, key generation, encryption, decryption
- `EXAMPLES.ipynb` — basic walkthrough of the system
- `matrix_ntru_system_test.ipynb` — correctness and consistency tests for the core system
- `lattice_attack.ipynb` — BKZ lattice attack recovering the private key, with a simulation study over `n`
- `lattice_attack-may.ipynb` — dimension-reduced (May) variant of the private-key attack
- `matrix_ntru_attack.ipynb` — attack recovering an encrypted message via the BKZ-reduced lattice

## Reference

1. Nayak, R., Sastry, C., and Pradhan, J. (2008). A matrix formulation for ntru cryptosystem. In 2008 16th IEEE International Conference on Networks, pages 1–5. IEEE.
2. do Rego Sousa, T. and Carneiro, T. (2024). Lattice Base Reduction Attack on Matrix NTRU. SBSEG 2024.
