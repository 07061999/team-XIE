from pyimagesearch.transform import four_point_transform
from skimage.filters import threshold_local
import matplotlib.pyplot as plt
import numpy as np
import pytesseract
from pytesseract import Output
import os
import argparse
import cv2
import re
import pyap
import imutils

image = cv2.imread('./Bills jpg/IMG_1106.jpg')
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
ratio = image.shape[0] / 500.0
orig = image.copy()
image = imutils.resize(image, height = 500)
# # convert the image to grayscale, blur it, and find edges
# # in the image
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
bilateral = cv2.bilateralFilter(gray, 15, 75, 75) 
ret3,edged = cv2.threshold(bilateral,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
cnts = cv2.findContours(edged.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
cnts = imutils.grab_contours(cnts)
cnts = sorted(cnts, key = cv2.contourArea, reverse = True)
c = cnts[0]
peri = cv2.arcLength(c, True)
approx = cv2.approxPolyDP(c, 0.02 * peri, True)
if len(approx) == 4:
  screenCnt = approx
  print("Screen Cnt is chosen from approx")
else:
  (x,y,w,h) = cv2.boundingRect(cnts[0])
  vertices = [[x,y],[x,y+h],[x+w,y+h],[x+w,y]]
  screenCnt = np.asarray(vertices)
  print(screenCnt)
  print("Screen Cnt is chosen from boundingRect")
print("STEP 2: Find contours of paper")
cv2.drawContours(image, [screenCnt], -1, (0, 255, 0), 2)
cv2.imshow("Outline", image)
cv2.waitKey(0)
cv2.destroyAllWindows()
warped = four_point_transform(orig, screenCnt.reshape(4, 2) * ratio)
warped = cv2.cvtColor(warped, cv2.COLOR_BGR2GRAY)
T = threshold_local(warped, 11, offset = 10, method = "gaussian")
warped = (warped > T).astype("uint8") * 255
print("STEP 3: Apply perspective transform")
cv2.imshow("Original", imutils.resize(orig, height = 650))
cv2.imshow("Scanned", imutils.resize(warped, height = 900))
cv2.waitKey(0)
im_directory=r"./receipts"
training_data=[]
pytesseract.pytesseract.tesseract_cmd = 'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'

kernel = np.array([[0, -1, 0], 
                   [-1, 5,-1], 
                   [0, -1, 0]])
img = cv2.imread("warped")

dilated=cv2.dilate(image,np.ones((5,5),np.uint8))

bg_image=cv2.medianBlur(image,21)

diff_image=255-cv2.absdiff(image,bg_image)

norm_img=diff_image.copy()

cv2.normalize(diff_image,norm_img,alpha=0,beta=255,norm_type=cv2.NORM_MINMAX,dtype=cv2.CV_8UC1)
_, threshold_img=cv2.threshold(norm_img,230,0,cv2.THRESH_TRUNC)
cv2.normalize(threshold_img,threshold_img,alpha=0,beta=255,norm_type=cv2.NORM_MINMAX,dtype=cv2.CV_8UC1)
cv2.imshow("Diff", threshold_img)


result=pytesseract.image_to_string(warped)
print(result)

with open("outfile.txt","w+") as file:
	file.write(result)


#Extracting Features Using Regular Expression

"""
d = pytesseract.image_to_data(threshold_img, output_type=Output.DICT)

n_boxes = len(d['level'])

for i in range(n_boxes):
    (x, y, w, h) = (d['left'][i], d['top'][i], d['width'][i], d['height'][i])
    cv2.rectangle(threshold_img, (x, y), (x + w, y + h), (0, 255, 0), 2)
cv2.imshow('img', threshold_img)
cv2.waitKey(0)
"""