#!/bin/bash

zokrates compile -i ./commit_reveal.zok -o commit_reveal -r commit_reveal.r1cs -c bn128 -s commit_reveal.json
zokrates setup -i commit_reveal -b ark -s g16
zokrates export-verifier -i verification.key -o ../src/CommitRevealProofVerifier.sol
