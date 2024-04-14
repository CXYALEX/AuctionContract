// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

library Math {
    // 求int类型的绝对值的函数
    function abs(int num) internal pure returns (int) {
        if (num >= 0) {
            return num;
        } else {
            return (0 - num);
        }
    }

    // 快速幂取余算法
    function pow_mod(
        uint256 base,
        uint256 pow,
        uint256 mod
    ) internal pure returns (uint256 res) {
        res = 1;
        base = base % mod;

        for (; pow != 0; pow >>= 1) {
            if (pow & 1 == 1) {
                res = (base * res) % mod;
            }
            base = (base * base) % mod;
        }
    }

    function bytesToUint(bytes memory b) internal pure returns (uint256) {
        uint256 number;
        for (uint i = 0; i < b.length; i++) {
            number =
                number +
                uint(uint8(b[i])) *
                (2 ** (8 * (b.length - (i + 1))));
        }
        return number;
    }
}
