# photos-import
AppleScript for integrating Hazel with Apple Photos

It does the following
1. Generate folders and albums in Apple Photos from the directory structure documented below. 
2. Add "Processed" as a keyword to imported photos and import all photos without this keyword to Apple Photos

A typical workflow:

Various sources ⭄ Lightroom with year/album structure below → Render with [jf Folder Publisher Plugin](http://regex.info/blog/lightroom-goodies/folder-publisher) → [Hazel](https://www.noodlesoft.com) with this script → Apple Photos

Make sure to have Hazel execute the script with the album folder, i.e. the folder containing images, as input.

## Prerequisites
Install [exiftool](https://www.sno.phy.queensu.ca/~phil/exiftool/)

Homebrew:
```
brew install exiftool
```

## Required directory structure
Given the following structure in file system
```
Rendered
├── 2015
│   ├── 2015-03-29\ Some\ Album
│   │   ├── DSC_2315.jpg
│   │   └── DSC_2321.jpg
│   └── 2015-07-14\ Some\ Other\ Album
│       ├── DSC_3201.jpg
│       ├── DSC_3202.jpg
│       ├── DSC_3204.jpg
│       └── DSC_3206.jpg
└── 2017
    └── 2017-04-09\ Some\ Album
        ├── DSC_2039.jpg
        ├── DSC_2047.jpg
        ├── DSC_2051.jpg
```

Generates the following structure in Apple Photos
```
2015 <-- Folder
├── Some Album <-- Album without timestamp
│   ├── DSC_2315.jpg
│   └── DSC_2321.jpg
└── Some Other Album <-- Album without timestamp
    ├── DSC_3201.jpg
    ├── DSC_3202.jpg
    ├── DSC_3204.jpg
    └── DSC_3206.jpg
2017 <-- Folder
└── Some Album <-- Album without timestamp, same name but in another folder
    ├── DSC_2039.jpg
    ├── DSC_2047.jpg
    ├── DSC_2051.jpg
```
