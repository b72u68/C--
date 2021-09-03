  i = n - 1
l0:
  t1 = 1 - i
  jneg l1 t1
  jump l2
l1:
  n = n * i
  i = i - 1
  jump l0
l2:
  ret n
