-module('tgen_matching-brackets').

-behaviour(tgen).

-export([
    revision/0,
    generate_test/2
]).

revision() -> 1.

generate_test(N, #{description := Desc, expected := Exp, property := Prop, input := #{value := Val}}) ->
    TestName = tgen:to_test_name(N, Desc),
    Property = tgen:to_property_name(Prop),

    Assert = "_" ++ case Exp of
        true -> "assert";
        false -> "assertNot"
    end,

    Fn = tgs:simple_fun(TestName ++ "_", [
        erl_syntax:tuple([
            tgs:string(Desc),
            tgs:call_macro(Assert, [
                tgs:call_fun("matching_brackets:" ++ Property, [
                    tgs:value(binary_to_list(Val))])])])]),

    {ok, Fn, [{Property, ["String"]}]}.
