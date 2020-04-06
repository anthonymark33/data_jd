NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. mtm demo tests

NB. runs with json context

msrx=: 3 : 0
echo y
r=. msr y
echo r
r
)

NB. drop all tables and create table f 
clean=: 3 : 0
t=. ;{:{:jsondec msr'info table'
for_a. t do. msrx'droptable ',;a end.
msrx'createtable f'
msrx'createcol f a int'
)

test=: 3 : 0
clean''
msrx'insert f';'a';i.5
assert (i.5)-:>{:{:jsondec q=:msr'read from f'
msrx'delete f';'jdindex < 3'
assert 3 4-:>{:{:jsondec msr'read from f'
msrx'delete f';'jdindex ge 0'
assert (,:'')-:>{:"1 jsondec msr'read from f'
msrx'insert f';'a';i.3
assert (,:i.3)-:>{:"1 jsondec msr'read from f'
msrx'update f';'a=1';'a';23
assert (,:0 23 2)-:>{:"1 jsondec msr'read from f'
msrx'createtable g'
assert'fg'-:;;{:{:jsondec msrx'info table'
msrx'droptable g'
assert(,'f')-:;;{:{:jsondec msrx'info table'

NB. test derived col
msrx'createtable g'
msrx'createcol g a byte 4'
msrx'insert g';'a';3 4$'abcdefghijklmonop'
msrx'createdcol g b byte 2 bfroma'
msrx'reads from g'
msrx'insert g';'a';'zzzz'
msrx'read from g'
msrx'update g';'a="ijkl"';'a';'qqqq'
msrx'read from g'
assert 'abefqqzz'-:;;{:{:jsondec msr'read b from g'


a=. 10 10 10 2 #i.4
a=. a{~(#a)?#a
d=: 0
msrx each ". each jobs

NB. varbyte col
msrx'createcol f v varbyte'
msrx'insert f';'a';7 8 9;'v';<'abc';'d';'efgh'
assert'abcdefgh'-:;;{:{:jsondec msr'read from f'
i.0 0
)

jobs=: <;._2 [0 : 0
'info summary'
'read count a from f'
'insert f';'a';d[d=: >:d
'update f';'jdindex=1';'a';23
)

NB. drive 1000
drive=: 3 : 0
pid=. 2!:6''
for. i.y do.
 for. i.10 do.
  msr'insert f';'a';pid;'v';<<":pid
 end.
 echo msr'read count a from f'
end.
)

drive2=: 3 : 0
i=. 0
for. i.y do.
 NB. echo msr'update f';'jdindex=1';'a';i
 logit":i
 echo msr'read a from f where jdindex=',":i
 i=. >:i
end.
)

drive3=: 3 : 0
for_i. i.y do.
 echo i
 logit":i
 connect''
end.
)

 

