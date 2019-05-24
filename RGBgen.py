import cv2

img = cv2.imread("marialeon.jpg")
r,g,b = cv2.split(img)
cv2.imshow("r",r)
cv2.imshow("g",g)
cv2.imshow("b",b)
R = ""
G = ""
B = ""
for col in img:
    for pix in col:
        R += "%d\n" % pix[2]
        G += "%d\n" % pix[1]
        B += "%d\n" % pix[0]

with open("R.txt","w+") as f:
    f.write(R)
with open("G.txt","w+") as f:
    f.write(G)
with open("B.txt","w+") as f:
    f.write(B)
cv2.waitKey(0)

