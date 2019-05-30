import numpy as np
import cv2


def rgbtohsvpaper(img):
    B,G,R = cv2.split(img)
    H,S,V = cv2.split(np.copy(img))

    for r in range(img.shape[0]):
        for c in range(img.shape[1]):
            pixel =  np.array([B[r,c],G[r,c],R[r,c]])
            print("Pix: ", pixel)
            maxi = np.max(pixel)
            V[r,c]= maxi
            mini = np.min(pixel)
            diff = maxi-mini
            S[r,c]= diff/maxi

            if S[r,c] == 0:
                H[r,c] = 0
            elif V[r,c]==R[r,c]:
                res = G[r,c]-B[r,c]
                mul = 43*res
                div = mul/diff
                H[r,c] = div + 0
            elif V[r,c]==G[r,c]:
                res = B[r,c]-R[r,c]
                mul = 43*res
                div = mul/diff
                H[r,c] = div + 85
            elif V[r,c]==B[r,c]:
                res = R[r,c]-G[r,c]
                mul = 43*res
                div = mul/diff
                H[r,c] = div + 171
            px1 = [H[r,c],S[r,c],V[r,c]]
            print("HSV man: ",px1)
            px2 = cv2.cvtColor(np.array([[pixel]]), cv2.COLOR_BGR2HSV)
            print("HSV auto: ", px2)
    return H,S,V

def rgbtohsvopen(img):
    B,G,R = cv2.split(img)
    H,S,V = cv2.split(np.copy(img))

    for r in range(img.shape[0]):
        for c in range(img.shape[1]):
            pixel =  np.array([B[r,c],G[r,c],R[r,c]])
            print("Pix: ", pixel)
            maxi = np.max(pixel)
            V[r,c]= maxi
            mini = np.min(pixel)
            diff = maxi-mini
            S[r,c]= (diff*255)/maxi
            print("Max: ",maxi,"Min:",mini)
            print("Diff:", diff)

            if S[r,c] == 0:
                ph = 0
            elif maxi==R[r,c]:
                print("Red case")
                res = int(G[r,c])-int(B[r,c])
                mul = 60*res
                div = int(mul/diff)
                ph = div 
            elif maxi==G[r,c]:
                print("Green case")
                res = int(B[r,c])-int(R[r,c])
                mul = 60*res
                div = int(mul/diff)
                ph = div + 120
            elif maxi==B[r,c]:
                print("Blue case")
                res = int(R[r,c])-int(G[r,c])
                mul = 60*res
                div = int(mul/diff)
                ph = div + 240
            if ph<0:
                ph += 360
            H[r,c] = ph/2

            px1 = np.array([H[r,c],S[r,c],V[r,c]])
            print("HSV man: ",px1)
            px2 = cv2.cvtColor(np.array([[pixel]]), cv2.COLOR_BGR2HSV)
            print("HSV auto: ", px2)
            dife = px2.astype(int)-px1.astype(int)
            if np.sum(dife)>0:
                print("dife: " , (px2-px1))
                input()
    return H,S,V


def rgbtohsvvhdl(img):
    B,G,R = cv2.split(img)
    H,S,V = cv2.split(np.copy(img))

    for r in range(img.shape[0]):
        for c in range(img.shape[1]):
            gg = G[r,c]
            bb = B[r,c]
            rr = R[r,c]

            pixel =  np.array([B[r,c],G[r,c],R[r,c]])
            print("Pix: ", pixel)
            
            #Max Value
            if rr>=bb:
                if rr>=gg:
                    maxi=rr
                else:
                    maxi=gg
            else:
                if gg>=bb:
                    maxi=gg
                else:
                    maxi=bb

            #Min Value
            if rr<gg:
                if rr<bb:
                    mini = rr
                else:
                    mini = bb
            else:
                if gg<bb:
                    mini = gg
                else:
                    mini = bb
            
            V[r,c]= maxi
            diff = maxi-mini
            if maxi!=0:
                S[r,c]= (diff*255)/maxi
            else:
                S[r,c]= 0
            print("Max: ",maxi,"Min:",mini)
            print("Diff:", diff)

            
            gmb = gg-bb
            bmg = bb-gg
            bmr = bb-rr
            rmb = rr-bb
            rmg = rr-gg
            gmr = gg-rr

            print(gmb,bmg,bmr,rmb,rmg,gmr)
            
            
            gmb60=gmb.astype(np.uint16)*60
            bmg60=bmg.astype(np.uint16)*60
            bmr60=bmr.astype(np.uint16)*60
            rmb60=rmb.astype(np.uint16)*60
            rmg60=rmg.astype(np.uint16)*60
            gmr60=gmr.astype(np.uint16)*60

    
            if diff==0:
                fdiff = 1
            else:
                fdiff=diff

            gmbdiv=np.uint64(gmb60/fdiff)
            bmgdiv=np.uint64(bmg60/fdiff)
            bmrdiv=np.uint64(bmr60/fdiff)
            rmbdiv=np.uint64(rmb60/fdiff)
            rmgdiv=np.uint64(rmg60/fdiff)
            gmrdiv=np.uint64(gmr60/fdiff)

            print(gmbdiv,
                  bmgdiv,
                  bmrdiv,
                  rmbdiv,
                  rmgdiv,
                  gmrdiv)

            S0sum=np.uint16(gmbdiv)
            S1sum=np.uint16(360-bmgdiv)
            S2sum=np.uint16(bmrdiv+120)
            S3sum=np.uint16(-120-rmbdiv)
            S4sum=np.uint16(rmgdiv+240)
            S5sum=np.uint16(240-gmrdiv)

            print(S0sum,
                  S1sum,
                  S2sum,
                  S3sum,
                  S4sum,
                  S5sum)

            if maxi == rr:
                if gg>bb:
                    s=0
                else:
                    s=1
            elif maxi == gg:
                if bb>rr:
                    s=2
                else:
                    s=3
            elif maxi == bb:
                if rr>gg:
                    s=4
                else:
                    s=5

            print("sel", s)

            if diff == 0:
                H[r,c] = 0
            else:
                if s==0:
                    H[r,c] = np.uint8(S0sum/2)
                elif s==1:
                    H[r,c] = np.uint8(S1sum/2)
                elif s==2:
                    H[r,c] = np.uint8(S2sum/2)
                elif s==3:
                    H[r,c] = np.uint8(S3sum/2)
                elif s==4:
                    H[r,c] = np.uint8(S4sum/2)
                elif s==5:
                    H[r,c] = np.uint8(S5sum/2)

            px1 = np.array([H[r,c],S[r,c],V[r,c]])
            print("HSV man: ",px1)
            px2 = cv2.cvtColor(np.array([[pixel]]), cv2.COLOR_BGR2HSV)
            print("HSV auto: ", px2)
            dife = px2.astype(int)-px1.astype(int)
            if np.sum(dife)>3:
                print("dife: " , (px2-px1))
                input()
    return H,S,V

img = cv2.imread("tvpatt.jpg")
hsv = cv2.cvtColor(img,cv2.COLOR_BGR2HSV)
h,s,v = cv2.split(hsv)
H,S,V = rgbtohsvvhdl(img)


