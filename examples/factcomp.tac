  t0 = n - 1
  i = t0
l0:
  t3 = 1 - i
  jneg l1 t3
  jump l2
l1:
  t1 = n * i
  n = t1
  t2 = i - 1
  i = t2
  jump l0
l2:
  ret n
