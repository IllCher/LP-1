start_of_question(X):-
    member(X, [how, who, "How", "Who"]).

quantity(X):-
    member(X, [much, many]).

multiples(X):-
    member(X, [sisters, brothers, sons, daughters]).

multiple(son, sons).
multiple(daughter, daughters).
multiple(sister, sisters).
multiple(brother, brothers).

do_does(X):-
    member(X, [do, does]).

have_has(X):-
    member(X, [have, has]).

is(X):-
    member(X,[is, "Is"]).

suffix(X):-
    member(X, ["'s"]).

mark_of_question(X):-
    member(X, ['?']).

his_her(X):-
    member(X, [his, her, he, she]).

% Пример запроса: [How, many, bros/sist, does, *name*, has ,?]

ask_the_question(List):-
      List = [Word, Quant, Relation, Does, Who, Have, Qstn],
      start_of_question(Word),
      quantity(Quant),
      multiples(Relation),
      do_does(Does),
      (sex(Who, m);
      sex(Who, f)),
      nb_setval(lastName, Who),
      have_has(Have),
      mark_of_question(Qstn),

      multiple(Rel1, Relation),
      setof(X, ask_relative(X, Who, Rel1),T),
             length(T, Res),!,
      write(Who),
      write(" has "),
      ((Res =:= 1, write(Res), write(" "), write(Rel1));
      (\+(Res =:= 1), write(Res), write(" "), write(Relation))),!.


% Пример запроса: [How, many, bros/sist, does, he, has, ?]
ask_the_question(List):-
      List = [Word, Quant, Rel1, Does, Who1, Have, Qstn],
      start_of_question(Word),
      quantity(Quant),
      multiples(Rel1),
      do_does(Does),
      his_her(Who1),
      nb_getval(lastName, Who),
      have_has(Have),
      mark_of_question(Qstn),

      multiple(Rel, Rel1),
      setof(X, ask_relative(X, Who, Rel), T),
      length(T, Res),
      write(Who),
      write(" has "),
      ((Res =:= 1,write(Res),write(" "),write(Rel));
      (\+(Res =:= 1),write(Res),write(" "),write(Rel1))),!.

% Пример запроса: [Who, is, *name*, "'s", mother, ?]
ask_the_question(List):-
      List = [Word, Is, Name, Suff, Relation, Qstn],
      start_of_question(Word),
      is(Is),
      (sex(Name, m);
      sex(Name, f)),
      nb_setval(lastName, N),
      suffix(Suff),
      chain_of_relation(Relation),
      mark_of_question(Qstn), !,
      connection(Relation, Res, Name),
      write(Res), write(" is "), write(Name), write("'s "), write(Relation).

% Пример запроса: [Who, is, his/her, mother, ?]
ask_the_question(List):-
      List = [Word, Is, Her, Relation, Qstn],
      start_of_question(Word),
      is(Is),
      his_her(Her),
      nb_getval(lastName, Name),
      chain_of_relation(D),
      mark_of_question(Qstn),!,
      connection(Relation, Res, Name),
      write(Res), write(" is "), write(Name), write("'s "), write(Relation).

% Пример запроса: [is, *name*, *name*, "`s", son, ?]
ask_the_question(List):-
      List = [Is, Name1, Name2, Suff, Relation, Qstn],
      nb_setval(lastName, Name2),
      is(Is),
      (sex(Name1, m);sex(Name1, f)),
      (sex(Name2, m);sex(Name2, f)),
      suffix(Suff),
      chain_of_relation(Relation),
      mark_of_question(Qstn),
      connection(Relation, Name1, Name2), !.

% Пример запроса: [is, *name*, his/her, son, ?]
ask_the_question(List):-
      List = [Is, Name, His, Relation, Qstn],
      is(Is),
      (sex(Name, m);
      sex(Name, f)),
      his_her(His),
      chain_of_relation(Relation),
      mark_of_question(Qstn),

      nb_getval(lastName, Rel1),
      connection(Relation, Name, Rel1), !.