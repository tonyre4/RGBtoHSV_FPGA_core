import cv2
import numpy as np

img = cv2.imread("marialeon.jpg")

shape = img.shape
npx = shape[0]*shape[1]

with open("H.txt","r") as f:
    l = list()
    for line in f:
        l.append(int(line))
while(len(l)!=npx):
    l.append(0)
H = np.array(l)

with open("S.txt","r") as f:
    l = list()
    for line in f:
        l.append(int(line))
while(len(l)!=npx):
    l.append(0)
S = np.array(l)

with open("V.txt","r") as f:
    l = list()
    for line in f:
        l.append(int(line))
while(len(l)!=npx):
    l.append(0)
V = np.array(l)



hsv = cv2.cvtColor(img,cv2.COLOR_BGR2HSV)
h,s,v = cv2.split(hsv)

H = H.reshape(h.shape)
S = S.reshape(s.shape)
V = V.reshape(v.shape)

H = H.astype(np.uint8)
S = S.astype(np.uint8)
V = V.astype(np.uint8)

cv2.imshow("horig",h)
cv2.imshow("sorig",s)
cv2.imshow("vorig",v)
cv2.imshow("h",H)
cv2.imshow("s",S)
cv2.imshow("v",V)

np.savetxt("H.csv", H, delimiter=",")

cv2.waitKey(0)
