CHILDREN = 16
data = null

prepare = ->
 data = new Int32Array 200000
 N = 1000
 i = 0
 n = 0
 while i < data.length
  n = 0 if n is N
  data[i] = n
  ++i
  ++n

count = ->
 c = 0
 k = 0
 while k < 1000
  t = 0
  i = 0
  while i < data.length
   if data[i] is k
    ++t
   ++i

  if t isnt 200
   throw new Error 'Counting error'
  c += t
  k++

 console.log c

prepare()

console.log 'start'
console.time 'count'
for j in [0...CHILDREN]
 count()

console.timeEnd 'count'

