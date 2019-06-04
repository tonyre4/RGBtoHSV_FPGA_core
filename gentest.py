import numpy as np
import matplotlib.pyplot as plt
import cv2

testimg = [ [0,0,0],
[0,0,0],
[0,0,0],
[204, 204, 204],
[  0, 255, 255],
[255, 255,   0],
[  1, 255,   0],
[254,   0, 255],
[  0,   0, 254],
[254,   0,   0],
[252,   1,   0],
[19, 19, 19],
[254,   0, 255],
[19, 19, 19],
[255, 255,   0],
[19, 19, 19],
[204, 204, 204],
[244, 244, 244],
[124, 124, 124],
[12, 12, 12],
[245, 245, 245],
[128, 128, 128],
[14, 14, 14],
[1, 1, 1],
[23, 23, 23],
[46, 46, 46],
[69, 69, 69],
[92, 92, 92],
[115, 115, 115],
[139, 139, 139],
[162, 162, 162],
[185, 185, 185],
[208, 208, 208],
[231, 231, 231],
[255, 255, 255],
[1, 1, 1]]

testimg = np.array(testimg)
testimg = testimg.reshape((6,6,3))

cv2.imwrite("test.png",testimg)

plt.imshow(testimg)





