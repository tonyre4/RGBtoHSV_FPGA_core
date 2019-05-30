import cv2
import numpy as np

#img = cv2.imread("colorcube.png")
#img = cv2.imread("marialeon.jpg")
img = cv2.imread("test.png")

shape = img.shape
npx = shape[0]*shape[1]
print (npx)

hsv = cv2.cvtColor(img,cv2.COLOR_BGR2HSV)
h,s,v = cv2.split(hsv)

print(np.max(h))
