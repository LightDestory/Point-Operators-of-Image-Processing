# Affine Transformation of Image Processing

## About the project

 A very basic showcase of image processing's point operators (negative, solarization, binaryzation, ect...) created using Processing.

 The aim of this project is to show the various point operators available.

---

## Features

These are the implementation goal of this project:

- [x] Negative
- [x] Solarization
- [x] RGB2Gray
- [x] Logarithm
- [x] Gamma
- [x] Simple Interaction

---

## How it works

It just applies the basic point operators on a sample image (Lenna). Using the pre-configured keys you can manipulate the transformation.

- Pressing __C__ (_case-insensitive_) will change the current point operator;
- Pressing __R__ (_case-insensitive_) will reset the current image to the initial __origin image__;
- Pressing __+, -__ will increase/decrease the rectangle size;
- Pressing __/, *__ will alter the point operator:
  - Gamma: Increase/Decrease the gamma factor;
  - Binaryzation: Increase/Decrease the threshold of the operator;
  - Solarization: Increase/Decrease the alpha factor of the polynom;

---

## Solarization Polynom

The solarization is applied via the following polynom courtesy of Dario Allegra:

![Solarization Polynom](solarization_polynom/polynom.PNG)

---

## How to use a custom image

This showcase doesn't allow to load a custom image, but you can easly import your own image by replacing the _"lenna.png"_ image located inside the __data__ folder.

__*__ It is important that your image is in a PNG format and that it is called "lenna.png"

---

## Requirements

If you are using the no java-jre bundle version you require:

- Java8+ installed on your system

Otherwise you don't need any pre-requisite.

---

## How to build

Use Processing editor to export a new application with the updated source.

---

## License

This project is under [MIT License](LICENSE)
