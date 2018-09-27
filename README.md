# Drake example

This is an example to figure out why `drake` won't work when a fancy folder structure is used. 

## Problem

This works:
```
├── functions.R
├── README.md
├── raw_data.xlsx
├── drake-example.Rproj
├── make.R
└── report.Rmd

```

This makes things complicated:

```
├── R
│   └── functions.R
├── README.md
├── data
│   └── raw_data.xlsx
├── drake-example.Rproj
├── make.R
└── report
    ├── report.Rmd
```

- the `master` branch is a default example that works
- the `using-file-links` branch creates symbolic file links from the folders and kinda works
- the `using-folder` branch uses `here::here()` and it won’t run

## Solution
This https://github.com/ropensci/drake/issues/257#issuecomment-366567173 is probably relevant. Apparently directory targets are not possible. 
