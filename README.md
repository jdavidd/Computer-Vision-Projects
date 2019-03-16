# Computer-Vision-Projects
In this repo there are 3 projects that I have developed during the course "Computer Vision" using MATLAB.

## Project I
The purpose of this project is to create mosaic images (Figure 2) from a normal image (Figure 1).  
A mosaic image (called mosaic) is obtained by replacing the pixel blocks in a reference image with small images (we call them mosaic pieces) from a given collection of other images.  
Replacing pixel blocks with pieces is done in such a way that the resulting mosaic can best approximate the reference image.  

<p float="left">
  <img width="300" height="200" src="../master/Project_I/poze/ferrari.jpg">
   <figure>
      <figcaption>Fig.1 Original Image.</figcaption>
   </figure> 
  <img width="300" height="200" src="../master/Project_I/poze/ferrari_hexagon_distinct.jpg">
   <figure>
   <figcaption>Fig.2 Mosaic Image.</figcaption>
</figure> 
</p>

## Project II
The purpose of this project is to implement and test a version of the image resizing algorithm (Figure 1) proposed by S. Avidan and A. Shamir in the article "Seam Carving for Content-Aware Image Resizing".
<p align="center">
   <img width="760" height="300" src="../master/Project_II/poze/exemplu.jpg">
   <figure align="center">
   
   <figcaption> Figure1: Resizing images.  
                (a) Initial image (b) Initial image resized to an image with 50 pixels less in height than original image, using                                                          the algorithm from the paper
                 (c)Initial image resized to an image with 50 pixels less in height than orinal with the usual resizing algorithm (using the 'imresize.m' function from matlab) that scales all the content in the image.
).
     </figcaption>
</figure> 
</p>

## Project III
The purpose of this project is to implement and test a version of the synthesis algorithm (Figure 1) and transfer (Figure 3) of the texture proposed by Alexei Efros and William Freeman in the article "Image quilting for texture synthesis and transfer "

<p align="center">
   <img width="760" height="300" src="../master/Project_III/data/figure1.png">
   <figure>
      <figcaption> Figure 1: Texture synthesis. 
                    (a) The texture obtained with random blocks. 
                    (b) Texture obtained based on overlapping error. 
                    (c) The texture obtained bassed on overlapping error and the minimum cost boundary.
     </figcaption>
</figure> 
</p>
<p align="center">
   <img width="760" height="300" src="../master/Project_III/data/figure2.png">
   <figure>
      <figcaption>
        Figure 3: Texture tranfer. 
                  (a) Initial texture.
                  (b) The image to which the texture is transferred. 
                  (c) The result  after iteration 1.
                  (d) The result after iteration 2.
     </figcaption>
</figure> 
</p>

