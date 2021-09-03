  t0 = 1 + 1
  two = t0
  t1 = two - 0
  jneg l0 t1
  jump l1
l0:
  two2 = two
l2:
  t2 = two2 - 0
  jneg l3 t2
  jump l4
l3:
  t3 = two2 + 1
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
  one = 1
  t8 = one + two
  three = t8
  t9 = three + one
  four = t9
  t10 = n / two
  ndiv = t10
  t11 = n - one
  t12 = t11 / two
  nmdiv = t12
  newn = n
  t13 = ndiv - nmdiv
  jz l12 t13
  jump l13
l12:
  t14 = n - one
  t15 = t14 / two
  newn = t15
  jump l14
l13:
  t16 = n / two
  newn = t16
l14:
  n = newn
  t17 = r + one
  r = t17
  jump l8
l10:
  ret r
