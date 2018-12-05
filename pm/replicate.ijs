NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

NB. replicate performance
NB. some stuff copied from replicate_test.ijs

0 : 0
usage: src-task creates src db and snk-task replicates

  src-task            snk-task
writerinit''
writersrc''
                    reader 0.01
writer 100000 0
NB. finishes
                    NB. finishes
repvalidate''                    
)

RLOG=: '~temp/jd/rlog/'

addsrc=: 3 : 0
d=. ?10000
d=. 'a';d;'b';d;'c';d;'d';d;'e';d;'f';d;'g';d;'h';d
jd'insert t';d
)

rd=: 3 : 0
jdaccess y
jd'reads count a from t'
)

setsrc=: 3 : 0
jd'createtable t'
jd'createcol t a int'
jd'createcol t b int'
jd'createcol t c int'
jd'createcol t d int'
jd'createcol t e int'
jd'createcol t f int'
jd'createcol t g int'
jd'createcol t h int'
)

NB. create src table t with a few rows
writerinit=: 3 : 0
jdadminnew'src'
setsrc''
)

NB. mark src db as repsrc
writersrc=: 3 : 0
jd'repsrc ',RLOG
)

NB. writer rows,delay
writer=: 3 : 0
'rows delay'=. y
while. rows do.
 rows=. <:rows
 addsrc'' 
 6!:3[delay
end.
jd'read count a from t'
)

NB. reader y - delay bettween update requests
NB. start delayed 5 seconds to let writer get started
NB. quit if no new updates in 5 seconds
reader=: 3 : 0
6!:3[5 NB. delay start for writerinit
jdadminnew'snk'
jd'repsnk ',RLOG
q=. >.5%y
n=. q
while. n do.
 c=. >{:jd'repupdate'
 if. c=0 do. n=. <:n break. end.
 n=. q
 6!:3[y
end.
(3!:1 jd'reads from t')fwrite RLOG,'/reader.dat'
jd'read count a from t'
)

repvalidate=: 3 : 0
(3!:2 fread RLOG,'/reader.dat')-:jd'reads from t'
)

NB. y is rows
report0=: 3 : 0
r=. 0 2$''


writerinit''
writersrc''
t=. timex'writer y 0'rplc 'y';":y
echo a=. t;'writer log on'
r=. r,a

writerinit''
t=. timex'writer y 0'rplc 'y';":y
echo a=. t;'writer log off'
r=. r,a
)

report1=: 3 : 0
r=. 0 2$''
writerinit''
writersrc''
t=. timex'writer y 0'rplc 'y';":y
echo a=. t;'writer log on with reader'
r=. r,a
)
