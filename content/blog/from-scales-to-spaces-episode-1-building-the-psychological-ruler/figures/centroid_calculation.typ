#set page(width: auto, height: auto, margin: 10pt)

$ bold(D) =
mat(
  Z(P(0, 0)), dots, Z(P(0, n-1));
  dots.v,      dots.down, dots.v;
  Z(P(n-1, 0)), dots, Z(P(n-1, n-1));
) 
= 

mat(
  D_(0,0), dots, D_(0,n-1);
  dots.v,  dots.down, dots.v;
  D_(n-1,0), dots, D_(n-1,n-1);
)
arrow.b^("averaging")
arrow.long.r^(sans("Centroid Calculation"))
mat(s_0, s_1, dots, s_(n-1))
$