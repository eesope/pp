defmodule Lab1 do
    defp mi_aux(_, _, r, newr, _) when newr == 0 and r > 1, do: :not_invertible
    defp mi_aux(t, _, _, newr, n) when newr == 0 and t < 0, do: t + n
    defp mi_aux(t, newt, r, newr, n) do
        case newr do
            0 -> t
            _ ->
                quotient = div(r, newr)
                mi_aux(newt, (t - quotient * newt), newr, (r - quotient * newr), n)
        end
    end
    def mod_inverse(a, n) do
        mi_aux(0, 1, n, a, n)
    end

    defp mp_aux(acc, _, 0, _), do: acc
    defp mp_aux(acc, a, m, n) when rem(m, 2) == 0 do
        mp_aux(rem(acc, n), rem(a * a, n), div(m, 2), n)
    end
    defp mp_aux(acc, a, m, n) when rem(m, 2) == 1 do
        mp_aux(rem(acc * a, n), a, m - 1, n)
    end
    def mod_pow(a, m, n) do
        mp_aux(1, a, m, n)
    end

    # both mod_pow() doesn't need acc at all
    # not dividing half which makes much slower than mod_pow()
    defp mp_aux2(acc, a, m, n) when m > 0 do
        mp_aux2(rem(acc * rem(a, n), n), a, m - 1, n)
    end
    defp mp_aux2(acc, _, 0, _), do: acc
    def mod_pow2(a, m, n) do
        mp_aux2(1, a, m, n)
    end

    defp mp_aux(a, m, n) when m == 0, do: 1
    defp mp_aux(a, m, n) when rem(m, 2) == 0 do
        # 짝수 지수: a^m = (a^(m/2))^2
        rem(mp_aux(rem(a * a, n), div(m, 2), n), n)
    end
    defp mp_aux(a, m, n) when rem(m, 2) == 1 do
        # 홀수 지수: a^m = a * a^(m-1)
        rem(a * mp_aux(a, m - 1, n), n)
    end
    def mod_pow(a, m, n) do
        mp_aux(a, m, n)
    end
end
