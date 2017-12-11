NB. Copyright 2016, Jsoftware Inc.  All rights reserved.
NB. Jd API
NB. Jd uses locales (Read__d'from table')
NB. Jd API wraps this for a possibly more convenient interface
NB. Jd API provices same interface to JD in task as to JD sever

NB. jd_cmd that uses abc must do jd_abc ... and not jd'abc ... to get errors

jdex_z_=: jdex_jd_

0 : 0
OSX expected error - filenames stored in decomposed form
Jd does not currently have code to convert 
decomposed file system form to composed form required by Jd

The following accented a chars look the same, but have different values.

   a.i.'ä' NB. utf8 from J
195 164
   a.i.'ä' NB. after 'corruption' from file system
97 204 136   

osx iconv utility converts decomposed file names to composed utf8

iconv -f UTF-8-MAC -t UTF-8 bad.txt > good.txt

possible fix is to shell iconv where necessary
this is Jd specific fix and not general J fix

this would need to be done for 1!:0, map, ???
)

0 : 0
ideas on error message

locale jde contains names to include in jdlast

new command starts with coerease<'jde'

info about the op (as it progresses but often just before assert)
is put in locale jde

tab_jde_=: 'mytab'

error processing adds all the names in jde to jdlast as name: value

preferred error usage:

'messed up'                                 assert condition
('insert table * col * bad'erf tab;col) assert condition 
)

coclass'jd'

todo=: 0 : 0
*** csvrd
boolean/varbyte CSTITCH doesn't work - see test/api_csvout.ijs

*** enum
support is incomplete
not supported in csvwr/csvrd

*** bulk update by key with inplace update

*** bulk insert - procdures

*** bulk merge (update and insert)
)


NB. 'insert table * col * bad'erf table;col
erf=: 4 : 0
y=. ')',~each'(',each boxopen y
i=. ('*'=x)#i.#x
t=. 'ABCDEFGHI'{.~#i
x=. t i}x
x rplc  ,(,.<"0 t),.,.boxopen y
)

JDOK=: ,.<'Jd OK'


0 : 0
API internal globals

 DB - database name - simple name - jdadmin connects to files and access rules

jd_... verbs typically start with getdb'' that sets:
 FLOC - locale of folder with database
 DLOC - locale of databse
)

jd_z_=: jd_jd_

demos=: (<'demo/'),each 'sandp/sandp.ijs';'northwind/northwind.ijs';'sed/sed.ijs';'vr/vr.ijs'

NB. getnext x args from boxed list
NB. error if too few or too many
getnext=: 4 : 0
'invalid number of args'assert x=#y
y
)

NB. y is jd_... ... 
NB. x is list of options and their arg counts
NB. result is y with options stripped
NB. option_name_jd_ set as option value
NB. options not provided are set to 0
NB. options provided with count 0 set to 1
NB. option value(s) must be numeric and non-negative
NB. a=. '/e 0 /nx 1 /foo 0'getoptions ca '/e /nx 23 abc'
getoptions=: 4 : 0
y=. ca y
t=. ca x
t=. (2,~-:#t)$t
n=. {."1 t
c=. ;0".each{:"1 t
p=. ;(<'_jd_ '),~each (<'option_'),each}.each n
(p)=: 0 NB. default value for options not provided
while. '/'={. ;{.y do.
 i=. n i. {.y
 ('invalid option: ',;{.y) assert i<#n
 e=. '_jd_',~'option_',}.;{.y
 a=. i{c NB. number of values for option
 if. a=0 do.
  (e)=: 1
 else.
  t=. 0+;_".each a{.}.y
  ('invalid option value: ',;{.y) assert 4=3!:0 t
  ('invalid option value: ',;{.y) assert t>:0 
  (e)=: ".":t NB. kludge so that single value is scalar - required in jd_csvcdefs use of jd_csvrd
 end.
 y=. y}.~>:a
end.
y
)

NB. jdget 'tab col'
jd_get=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
d=. getdb''
t=. getloc__d {.a
c=. getloc__t {:a
select. <typ__c
 case. <'autoindex' do. i.Tlen__t
 case. <'varbyte'   do.
  (forcecopy dat__c);forcecopy val__c
 case.  do. forcecopy dat__c
end.
)

NB. 'tab';'col';dat [;val]
NB. should enforce no hash or related data
jd_set=: 3 : 0
if. 3=#y do.
 'tab col dat'=. y
elseif. 4=#y do.
 'tab col dat val'=. y
elseif. 1 do.
 ECOUNT assert 0
end.
d=. getdb''
t=. getloc__d tab
snk=. getloc__t col
'jde: wrong shape' assert ($dat)-:$dat__snk
'jde: wrong type'  assert (3!:0 dat)=3!:0 dat__snk
if. 'varbyte'-:typ__snk do.
 'jde: no val and varbyte' assert 0=nc<'val'
 'jde: val wrong length' assert (+/{:"1 dat)=#val
 
 NB. rsizemap__snk 'val';#val does not work (error on remap???) - workaround
 jdunmap n=. 'val',Cloc__snk
 f=. PATH__snk,'val'
 ferase f
 jdcreatejmf f;#val
 jdmap n;f
 val__snk=. val
else.
 'jde: val and not varbyte' assert _1=nc<'val'
end. 
dat__snk=. dat
JDOK
)

initserver_z_=: 3 : 0
if. ''-:y do.
 d=. {."1[1!:0 jpath JDP,'config/server_*.ijs'
 >_4}.each 7}.each d
 return.
end. 
load'~addons/ide/jhs/core.ijs'
load JDP,'config/server_',y,'.ijs'
smoutput BIND_jhs_,':',":PORT_jhs_
smoutput jdadmin''
smoutput 'OKURL',;' ',each OKURL_jhs_
init_jhs_''
)

vsub=: 3 : 0
'bad arg: pairs of names;values' assert (2<:#y)*.0=2|#y
t=. (((#y)%2),2)$y
(,each{."1 t),.{:"1 t NB. ugly make scalar col names lists
)

dbpath=: 3 : 0
i=. ({."1 DBPATHS)i.<,y
'not a db access name'assert i<#DBPATHS
;i{{:"1 DBPATHS
)

jd_createdb=: 3 : 0
ECOUNT assert 0=#y
t=. dbpath DB
'w'jdadminlk t
'f db'=. getfolder''
Create__f db
JDOK
)

NB. box blank delimited name and the rest
bd2=: 3 : 0
if. 0=L.y do.
 t=. dltb y
 i=. t i. ' '
 dltb each (i{.t);}.i}.t
else.
 dltb each y 
end.
)

NB. box 2 blank delimited names and the rest
bd3=: 3 : 0
if. 0=L.y do.
 t=. dltb y
 i=. t i. ' '
 dltb each (<i{.t),bd2 i}.t
else.
 dltb each y 
end.
)

jd_createtable=: 3 : 0
erase<'DATACOL_jd_'
if. 0=L.y do. NB. string parse has , and LF in col defs
 a=. bdnames y
 y=. ''
 if. '/a'-:;{.a do.
  y=. 4{.a
  a=. 4}.a
 end.
 y=. y,{.a NB. table name
 a=. }.a
 NB. y=. y,<;' ',each a
 y=. y, a:-.~<;._2 LF,LF,~(;a,each' ')rplc',';LF
end. 
a=. y
if. '/a'-:;{.a do.
 alloc=. ;_1".each 3{.}.a
 EALLOC assert 0<alloc
 alloc=. 4 1 1>.alloc
 a=. 4}.a
else. 
 alloc=. ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_
end.
vtname FETAB=: t=. >0{a NB. table
a=. }.a
a=. ;cutcoldefs each a
if. #a do.
 b=. ><;._2 each a,each' '
 ns=. 0{"1 b
 ts=. 1{"1 b
 vcname each ns
 duplicate_assert ns
 ETYPE assert ts e.TYPES
 if. 3<:{:$b do. NB. have shapes
  EBTS assert 3={:$b
  ss=. 2{"1 b
  for_i. i.#ns do.
   FECOL_jd_=: ;i{ns
   p=. ;i{ts
   s=. ;i{ss
   if. 0~:#s do. NB. this quy has a shape
    s=. _1".s
    EBTS assert (p-:'byte'),(_1~:s),1=#s
   end. 
  end.
 end. 
end.
a=. }:;a,each','
d=. getdb''
Create__d t;a;'';alloc   NB. cols;data;alloc
JDOK
)

jd_createptable=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
'tab col'=: a
d=. getdb''
'not a table'assert NAMES__d e.~<tab
t=. jdgl tab
'not empty'assert 0=Tlen__t
'already a ptable'assert 0=S_ptable__t
c=. jdgl tab,' ',col
'bad col type'assert (<typ__c) e. ;:'int edate edatetime date datetime'
S_ptable__t=: 1
writestate__t''
jd_createtable tab,PTM
jd_createcol tab,PTM,' ',col,' ',typ__c,' ',":shape__c
JDOK
)

jdcdef=: 3 : 0
v=. vsub ,y
ns=. {."1 v
vs=. {:"1 v
vcname each ns
duplicate_assert ns
typ=. ;3!:0 each vs
ETYPE assert 8>:ts
typ=. typ{'';'boolean';'byte';'';'int';'';'';'';'float'
ts=. ":each }.each $each vs
ETALLY assert c={.c=. ;#each vs
deb _3}.' ',;ns,each' ',each typ,each' ',each ts,each<' , '
)


jdfixcolnames=: 3 : 0
v=. vsub ,y
ns=. {."1 v
vs=. {:"1 v
ns=. ns rplc each <'.';'-';' ';'_'
,ns,.vs
)

RESERVEDCHARS=: '/\ *.,:?<>|"''' NB. illegal chars in dan/table/col names
RESERVEDWORDS=: ;:'by from where order'

vdname=: 3 : 0 NB. validate dan name
('invalid name: ',y)assert (0~:#y) *. ('~'~:{.y) *.(2=3!:0 y) *. (2>$$y) *. (*./-.RESERVEDCHARS e. y) *. -.RESERVEDWORDS e.~<y
if. UNAME-:'Darwin' do. ('invalid name (OSX filename - unicode composed vs decomposed): ',y)assert 127>a.i.y end.
)

vtname=: 3 : 0 NB. validate table name
('invalid name: ',y)assert -.'jd'-:2{.y
vdname y
)

vcname=: vtname NB. validate column name

NB. not boxed  -> no dat and NB. boxed -> dat
jd_createcol=: 3 : 0
erase<'DATACOL_jd_'
d=. getdb''
if. 1=L.y do.
 NB. boxed assumes has dat
 dat=. >{:y  NB. col values
 y=. }:y
else.
 erase<'dat' NB. no col values
 y=. bdnames y
end.
FETAB=: ;0{y
FECOL=: ;1{y
vcname FECOL
if. 4=#y do.
 if. (,'_')-:;3{y do. y=. }:y end.
else.
 ECOUNT assert 3=#y
end.

shape=. ''
if. 4=#y do.
 if. -.''-:;3{y do.
  EBTS assert (2{y)-:<'byte'
 end.
 shape=. _".;{:y
 EBTS assert (_~:shape),1>:#shape
end.

if. 0=nc<'dat' do. NB. have column values
 type=. ;2{y
 ETYPE assert (<type) e. TYPES -. 'enum';'varbyte'
 t=. getloc__d FETAB
 'ptable data not allowed'assert 0=S_ptable__t
 if. (0=Tlen__t)*.0=#NAMES__t#~;(<'jd')~:2{.each NAMES__t do. setTlen__t #dat end.
 if. (1=3!:0 dat)*.-.type-:'boolean' do. dat=. 0+dat end.
 ETYPE assert ((TYPES i. <type){TYPESj)=3!:0 dat
 if. (Tlen__t,shape)-:$dat do.
  DATACOL_jd_=: dat
 else.
  if. ''-:shape do.
   ESHAPE assert 0=#$dat
  else.
   ESHAPE assert 2>#$dat
   ESHAPE assert shape>:#dat
   dat=. shape{.dat
  end.
  DATACOL_jd_=: (Tlen__t,shape)$dat
 end.
end.

ns=. getparttables ;{.y
for_i. i.#ns do.
 if. i=1 do. continue. end. NB. ignore f~
 InsertCols__d (i{ns),< ;' ',~each}.":each y
end.
JDOK
)


NB. run custom db jd_x... op in db locale if it exists
jd_x=: 3 : 0
d=. getdb''
JDE1001 assert 3=nc<'jd_',OP,'__d' 
('jd_',OP,'__d')~y
)

NB. left1 only join (fast and simple) - ref starts out as dirty
jd_ref=: 3 : 0
y=. '/left 0'getoptions y
ECOUNT assert (4<:#y)*.0=2|#y
d=. getdb''
t=. (2,(#y)%2)$y
0 validtc__d {.t NB. ptable allowed on left
validtc__d {:t
t=. ({."1 t),.<"1 (}."1 t)
ts=. getparttables ;{.y
ts=. ts#~PTM~:;{:each ts
n=. 'jdref', ;'_'&,&.> ; boxopen&.> }.,t
for_t1. ts do.
 a=. ;t1
 h=. jdgl :: 0: a,' ',n
 if. h-:0 do.
  loc=. getloc__d a
  c=. Create__loc n;'ref';<($t)$t1,}.,t
  left__c=: option_left
 else.
  'can not change /left option in existing ref'assert left__h=option_left
 end.
end.
JDOK
)

jd_tableinsert=: 3 : 0
y=. ca y
ECOUNT assert 2 3 e.~#y
'snkt srct srcdb'=. y
NB. 'srcdb same as snkdb' assert -.DB-:&filecase_j_ srcdb
d=. getdb''
snktloc=. getloc__d snkt
a=. jdcols snkt
snkcs=. {:"1 a
snkns=. {."1 a
db=. DB
try.
 jdaccess srcdb NB. possible security implication
 d=. getdb''
 a=. jdcols srct
 srccs=. {:"1 a
 srcns=. {."1 a
 srctloc=. getloc__d srct
 new=. Tlen__srctloc
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.
jdaccess db
t=. snkns-.srcns
if. #t do. throw 'required cols missing in src: ',;' ',each t end.
for_i. i.#snkns do.
 a=. i{snkcs
 b=. i{srccs
 assert NAME__a-:NAME__b
 assert typ__a-:typ__b
 assert shape__a-:shape__b
 
 getloc__snktloc NAME__a NB. make sure col is mapped
 getloc__srctloc NAME__b  NB. make sure col is mapped
 
 assert (}.$dat__a)-:}.$dat__b
end.
update_subscr__snktloc'' NB. mark ref dirty
setTlen__snktloc new+Tlen__snktloc
for_i. i.#snkns do.
 a=. i{snkcs
 b=. i{srccs
 if. 'varbyte'-:typ__a do.
   v=. 0,~#val__a 
  'val' appendmap__a val__b
  'dat' appendmap__a v+"1 dat__b
 else.
  'dat' appendmap__a dat__b
 end. 
end.
JDOK
)

jd_tablecopy=: 3 : 0
y=. bdnames y
ECOUNT assert 3=#y
'snk src srcdb'=. y
'srcdb same as snkdb' assert -.DB-:&filecase_j_ srcdb
snkpath=. jpath(dbpath DB),'/',snk
assert 0=#1!:0<jpath snkpath['snk table already exists'

db=. DB
try.
 jdaccess srcdb NB. possible security implication
 srcpath=. jpath(dbpath DB),'/',src
 assert 'table'-:jdfread srcpath,'/jdclass'
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.

jdaccess db
snkpath=. '"',snkpath,'"'
srcpath=. '"',srcpath,'"'
jd_close''
if. IFWIN do.
 r=. shell 'robocopy ',(hostpathsep srcpath),' ',(hostpathsep snkpath),' *.* /E'
 if. +/'ERROR' E. r do.
  smoutput r 
  assert 0['robocopy failed'
 end.
else.
 shell 'cp -r ',srcpath,' ',snkpath
end.
assert (2=ftypex) snkpath-.'"'['tablecopy failed'
JDOK
)

jd_tablemove=: 3 : 0
y=. bdnames y
ECOUNT assert 3=#y
'snk src srcdb'=. y
'srcdb same as snkdb' assert -.DB-:&filecase_j_ srcdb
snkpath=. jpath(dbpath DB),'/',snk
assert 0=#1!:0<jpath snkpath['snk table already exists'

db=. DB
try.
 jdaccess srcdb NB. possible security implication
 srcpath=. jpath(dbpath DB),'/',src
 assert 'table'-:jdfread srcpath,'/jdclass'
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.

jdaccess db
jd_close'' NB. does not release lock
assert 1=snkpath frename srcpath['frename failed'
JDOK
)

opened=: 3 : 0
ECOUNT assert 0=#y
r=. ''
for_n. NAMES_jd_ do.
 f=. Open_jd_ >n
 p=. PATH__f
 for_d. CHILDREN__f do.
  r=. r,<p,NAME__d
 end.
end.
r
)

jd_close=: 3 : 0
ECOUNT assert 0=#y
if. fexist 'jdcloseflush',~jdpath'' do. jd_flush'' end.
NB. read error (tab not found) orphans jdquery local
NB. coerase jdquery local (copath has number locals) leaves a damaged local
NB. brute force get rid of all jdquery locales
for_n. conl 1 do.
 if. 'jdquery'-:;{.copath n do. coerase n end.
end. 

t=. opened''
for_a. t do.
 a=. ;a
 i=. a i:'/'
 f=. Open_jd_ i{.a
 Close__f (>:i)}.a
end.

NB. coerase all folder locals for a clean slate
for_n. conl 1 do.
 if. 'jdfolder'-:;{.copath n do. coerase n end.
end.get
NAMES_jd_=: '' 
CHILDREN_jd_=: ''

JDOK
)

NB. needs work
jd_option=: 3 : 0
a=. ;:y
select. ;{.a 
case. 'space' do. optionspace=: 1=0".;1{a
case. 'sort'  do. optionsort =: 1=0".;1{a
case.         do. assert 0['unsupported option'
end.
JDOK
)

jd_gen=: 3 : 0
y=. bdnames y
select. ;{.y
case. 'test' do.
 gentest }.y
case. 'ref2' do.
 'atab arows acols btab brows'=. }.y
 arows=. 0".arows
 acols=. 0".acols
 brows=. 0".brows
 assert arows>:brows
 t=. (arows,12)$'abc def'
 jd_createtable atab
 jd_createtable btab
 jd_createcol atab;'akey' ;'int';'_';i.arows
 jd_createcol atab;'adata';'int';'_';i.arows
 jd_createcol atab;'aref' ;'int';'_';arows$i.brows
 if. acols do.
  t=. (arows,12)$'abc def'
  for_i. i.acols do.
   jd_createcol atab;('a',(":i));'byte';'12';t
  end.
 end. 
 t=. (brows,12)$'abc def'
 jd_createcol btab;'bref';'int' ;'_' ;i.brows
 jd_createcol btab;'bb12';'byte';'12';t
 jd'ref A aref B bref'rplc'A';atab;'B';btab NB. jd_ref_jd_ fails
case. 'one' do.
 genone }.y
case. 'two' do.
 gentwo }.y
case. do.
 assert 0['unknown gen type'
end.
JDOK
)

NB. gen two f 10 g 3
NB. generate 2 tables suitable for testing dynamics
gentwo=: 3 : 0
 'atab arows btab brows'=. 4{.y
 arows=. 0".arows
 if. 0=#brows do. brows=. 3>.>.arows%10 else. brows=. 0".brows end.
 jd_createtable atab
 jd_createtable btab
 jd_createcol atab;'a1';'int';'_';i.arows
 jd_createcol atab;'a2';'int';'_';arows$i.brows
 jd_createcol btab;'b2';'int';'_' ;i.brows
)

genone=: 3 : 0
'atab arows acols'=. y
jd_createtable atab
d=. i.0".arows
for_i. i.0".acols do. 
 NB. jd_close''
 jd_createcol atab;('a',":i);'int';'_';d
end. 
)

NB. insert of 1st col sets Tlen
NB. subsequent creaecol gets defauilt data of right size
NB. this means set works
NB. not optimal efficient as dat is created and then set
gentest=: 3 : 0
t=. bdnames y
ECOUNT assert 2=#t
'tab n'=. t
n=. 0".n
jd_droptable tab
jd_createtable tab;'x int'
jd_insert tab;'x';i.n NB. insert sets Tlen and new col creates get default data
jd_createcol tab,' datetime datetime'
jd_set tab;'datetime';(n#20130524203132)-10000000000*?.n#20
jd_createcol tab,' float float'
jd_set tab;'float';0.5+i.n
jd_createcol tab,' boolean boolean'
jd_set tab;'boolean';n$0 1 1
jd_createcol tab,' int int'
jd_set tab;'int';100+i.n
jd_createcol tab,' byte byte'
jd_set tab;'byte';n$AlphaNum_j_
jd_createcol tab,' byte4 byte 4'
jd_set tab;'byte4';(n,4)$AlphaNum_j_
jd_createcol tab,' varbyte varbyte'
if. 0~:n do.
 t=. n$?.100000$10
 t=. (0,}:+/\t),.t
 jd_set tab;'varbyte';t;(+/{:"1 t)$AlphaNum_j_
end. 
JDOK
)

getfolder=: 3 : 0
db=. dbpath DB
p=. jpath db
i=. p i:'/'
(Open_jd_ i{.p);(>:i)}.p
)

NB. valid tab and cols - float/varbyte
NB. validate ptable
validtc=: 3 : 0
1 validtc y
:
b=. (<'jd')=2{.each y
if. +./b do. ('jde: invalid name: name (NAME)' rplc 'NAME';;{.b#y) assert 0 end.
if. -.({.y)e.NAMES do. ('jde: not found: table (TAB)' rplc 'TAB';;{.y) assert 0 end.
t=. getloc {.y
if. x do. 'ptable not allowed'assert 0=S_ptable__t end. NB! test not right
a=. (}.y)-.NAMES__t
if. #a do. ('jde: not found: table (TAB) column (COL)' rplc 'TAB';(;{.y);'COL';;{.a)assert 0 end.
for_c. }.y do.
 w=. getloc__t c
 'varbyte not allowed' assert -.'varbyte'-:typ__w
 'float not allowed'   assert -.'float'-:typ__w
end. 
)

NB. get blank delimited (possibly in "s) arg from string
getarg=: 3 : 0
a=. dlb y
if. '"'={.a do.
 a=. }.a
 i=. a i.'"'
 'jde: unmatched double quote' assert i<#a
 r=. i{.a
 a=. }.i}.a
else.
 i=. a i.' '
 r=. i{.a
 a=. i}.a
end.
r;a
)

getopt=: 3 : 0
a=. dlb y
if. '/'={.a do.
 i=. a i.' '
 r=. }.i{.a
 a=. i}.a
else.
 r=. ''
end.
r;a
)

assertnoref=: 3 : 0
t=. jdgl y
a=. {."1 SUBSCR__t
'table has ref' assert 0=+/;(<'jdref')=5{.each a
'table has ref' assert 0=+/;+/each(<'.jdref')E.each a
)

assertnodynamic=: 3 : 0
t=. jdgl ;{.y
'col has dynamic' assert  -.({:y)e.;{:"1 SUBSCR__t
)

jd_renametable=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
assertnoref ;{.a

ns=. getparttables ;{.a
for_i. i.#ns do.
 tab=. i{ns
 t=. jdgl tab
 old=. }:PATH__t
 part=. (old i: PTM)}.old
 new=. ((->:#NAME__t)}.PATH__t),(;{:a),part
 jd_close''
 new frename old
end.

JDOK
)

jd_renamecol=: 3 : 0
a=. bdnames y
ECOUNT assert 3=#a
t=. jdgl {.a
'col not found'      assert   (1{a)e.NAMES__t
'col already exists' assert -.(2{a)e.NAMES__t
'jd prefix not allowed' assert -.(<'jd')=2{.each }.a
vcname ;2{a
assertnodynamic 2{.a
ns=. getparttables ;{.a
for_i. i.#ns do.
 if. i=1 do. continue. end. NB. ignore f~
 t=. jdgl (i{ns),1{a
 new=. ((->:#NAME__t)}.PATH__t),;{:a 
 old=. }:PATH__t
 jd_close''
 'file rename failed' assert 1=new frename old
end. 
JDOK
)
