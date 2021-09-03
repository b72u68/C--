  jump l1
l0:
  two2 = 2
l2:
  t2 = two2 - 0
  jneg l3 t2
  jump l4
l3:
  two2 = two2 + 1
  jump l2
l4:
l1:
  n = arg
  r = 1
  t4 = n - 0
  jneg l5 t4
  jump l7
l7:
  t5 = n - 0
  jz l5 t5
  jump l6
l5:
  ret r
l6:
l8:
  t6 = 0 - n
  jneg l9 t6
  jump l11
l11:
  t7 = 0 - n
  jneg l9 t7
  jump l10
l9:
  ndiv = n / 2
  t11 = n - 1
  nmdiv = t11 / 2
  newn = n
  t13 = ndiv - nmdiv
  jz l12 t13
  jump l13
l12:
  t14 = n - 1
  newn = t14 / 2
  jump l14
l13:
  newn = n / 2
l14:
  n = newn
  r = r + 1
  jump l8
l10:
  ret r
