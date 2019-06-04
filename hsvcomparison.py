import cv2
import numpy as np
import sys

args = sys.argv

try:
    impath = args[1]
except:
    print("no input name")
    exit()

def getidx(img,val):
    for i,r in enumerate(img):
        for j,c in enumerate(r):
            if (val==c).all():
                return i,j


#img = cv2.imread("test.png")
img = cv2.imread(impath)

shape = img.shape
npx = shape[0]*shape[1]

with open("H.txt","r") as f:
    l = list()
    for line in f:
        l.append(int(line))
while(len(l)<npx):
    l.append(0)
H = np.array(l)

with open("S.txt","r") as f:
    l = list()
    for line in f:
        l.append(int(line))
while(len(l)<npx):
    l.append(0)
S = np.array(l)

with open("V.txt","r") as f:
    l = list()
    for line in f:
        l.append(int(line))

while(len(l)<npx):
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

HSV = cv2.merge([H,S,V])


#np.savetxt("H.csv", H, delimiter=",")
colors = np.unique(img.reshape(-1,img.shape[2]),axis=0)

#print(colors)
#print(colors.shape)

samples = colors.shape[0]
nsamp = int(colors.shape[0]/samples)

for sample in range(0,colors.shape[0],nsamp):
    color = colors[sample]
    r,c = getidx(img,color)
    err = np.sum(np.absolute(hsv[r,c].astype(int)-HSV[r,c].astype(int)))
    if err<=3:
        print("Sample %d of %d success!" % (sample,samples))
    else:
        print("Sample %d failed :/:" % sample)
        print("\tColor sample: " , color)
        print("\tOpencv HSV value: ", hsv[r,c])
        print("\tOutput HSV value: ", HSV[r,c])

while(1):
    cv2.imshow('img',img)
    cv2.imshow("horig",h)
    cv2.imshow("sorig",s)
    cv2.imshow("vorig",v)
    cv2.imshow("h",H)
    cv2.imshow("s",S)
    cv2.imshow("v",V)
    
    k = cv2.waitKey(33)
    if k==32:    # Esc key to stop
        break
    elif k==-1:  # normally -1 returned,so don't print it
        continue
    else:
        print (k) # else print its value
