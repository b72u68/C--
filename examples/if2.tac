  jump l3
l3:
  jump l0
l4:
  jump l1
l0:
  jump l6
l8:
  jump l5
l5:
  b = 1
  jump l7
l6:
  b = 2
l7:
  jump l2
l1:
  b = 3
l2:
  ret b
