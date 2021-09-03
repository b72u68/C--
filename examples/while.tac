  n = 5
  fact = 1
l0:
  t0 = n - 1
  jneg l2 t0
  jump l1
l1:
  fact = fact * n
  n = n - 1
  jump l0
l2:
  ret fact
