% Copyright (c) Facebook, Inc. and its affiliates.
%
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.

-module(nonmatch_match_expr).

-export([
    test_match_a_Ok/0,
    test_match_b_Bad/0,
    test_match_c_Ok/0,
    test_match_d_Ok/0,
    test_match_e_Bad/0,
    test_match_f_Ok/0,
    test_match_g_Bad/0,
    test_match_in_pattern_a_Ok/0,
    test_match_in_pattern_b_Bad/0,
    test_match_in_pattern_c_Bad/0,
    test_match_in_pattern_d_Bad/0,
    test_match_in_pattern_e_Ok/0,
    test_match_in_pattern_f_Bad/0,
    test_match_nested1_Ok/0,
    test_match_nested2_Bad/0,
    test_match_nested3_Bad/0,
    test_match_eager_Ok/0,
    test_match_eager_Bad/0,
    fp_test_match_func_args_Ok/0,
    test_match_func_args_Bad/0,
    test_match_func_arg_Ok/0,
    test_match_func_arg_Bad/0,
    test_match_with_var_Ok/0,
    test_match_with_var_Bad/0,
    test_match_with_var_swapped_Ok/0,
    test_match_with_var_swapped_Bad/0,
    test_simple_match_Bad/0,
    test_match_anonymus_Ok/0,
    test_not_real_anon_match1_Bad/0,
    test_not_real_anon_match2_Bad/0
]).

tail([_ | Xs]) -> Xs.

test_match_a_Ok() ->
    _X = two().

test_match_b_Bad() ->
    [_ | _] = two().

test_match_c_Ok() ->
    [_X, _Y] = [1, 2].

test_match_d_Ok() ->
    [_ | Xs] = [1, 2],
    tail(Xs).

test_match_e_Bad() ->
    [_ | Xs] = [1],
    tail(Xs).

test_match_f_Ok() ->
    X = (Y = 1),
    only_accepts_one(X),
    only_accepts_one(Y).

test_match_g_Bad() ->
    X = 2,
    only_accepts_one(X).

test_match_in_pattern_a_Ok() ->
    X = 2,
    case X of
        2 = 2 -> ok
    end.

test_match_in_pattern_b_Bad() ->
    X = 3,
    case X of
        2 = 2 -> ok
    end.

test_match_in_pattern_c_Bad() ->
    X = 2,
    case X of
        2 = 3 -> ok
    end.

test_match_in_pattern_d_Bad() ->
    X = 3,
    case X of
        3 = 2 -> ok
    end.

test_match_in_pattern_e_Ok() ->
    X = 2,
    case X of
        Y = 2 -> ok
    end,
    case Y of
        2 -> ok
    end.

test_match_in_pattern_f_Bad() ->
    X = 1,
    case X of
        Y = 2 -> ok
    end.

test_match_nested1_Ok() ->
    (1 = X) = 1,
    only_accepts_one(X).

test_match_nested2_Bad() ->
    (1 = _X) = 2.

test_match_nested3_Bad() ->
    (2 = _X) = 1.

no_op(_) -> ok.

test_match_eager_Ok() ->
    no_op(1 = 1).

test_match_eager_Bad() ->
    % Even though the argument is not used, it is still evaluated (causing crash).
    no_op(1 = 2).

%% internal
%% These functions are used to fool the compiler, which would warn if these were inlined.

only_accepts_one(1) -> ok.
two() -> 2.

%% Tests for matching against already bound variables

% Currently FP because equality model for unknown types
crash_if_different(A, B) ->
    A = B.

fp_test_match_func_args_Ok() ->
    crash_if_different(1, 1).

test_match_func_args_Bad() ->
    crash_if_different(1, 2).

crash_if_not_one(A) ->
    A = 1.

test_match_func_arg_Ok() ->
    crash_if_not_one(1).

test_match_func_arg_Bad() ->
    crash_if_not_one(2).

crash_if_not_one_with_var(A) ->
    B = 1,
    A = B.

test_match_with_var_Ok() ->
    crash_if_not_one_with_var(1).

test_match_with_var_Bad() ->
    crash_if_not_one_with_var(2).

crash_if_not_one_with_var_swapped(A) ->
    B = 1,
    B = A.

test_match_with_var_swapped_Ok() ->
    crash_if_not_one_with_var_swapped(1).

test_match_with_var_swapped_Bad() ->
    crash_if_not_one_with_var_swapped(2).

test_simple_match_Bad() ->
    A = 1,
    A = 2.

test_match_anonymus_Ok() ->
    _ = 1,
    _ = 2.

test_not_real_anon_match1_Bad() ->
    % `_` is the only truly anonymus name
    _A = 1,
    _A = 2.

test_not_real_anon_match2_Bad() ->
    % `_` is the only truly anonymus name
    __ = 1,
    __ = 2.
