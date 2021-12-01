# Matlab_project_template
**[Bryce M. Henson](https://github.com/brycehenson), other authors**  
A template for making a matlab project in git. Core BEC library already included as submodule.
**Status:** Consider inducing a status comment on the top explaining how ready this code is to use in other projects/works. eg This Code is **ready for use in other projects**. Unit Testing is implemented for **most** functions. Integration/system testing is **not** implemented.

## About this project
- what is is trying to accomplish
- what novel contributions does it make
- in broad strokes how does it work?


## Install 
Github does not copy the submodules when you hit the make git with template button. To get arround this
- make a repo using this template
- clone this repo with
```
 git clone --recurse-submodules -j8 https://github.com/brycehenson/matlab_proj_template.git
```
- then make this clone of the template repo point to your new project 
```
 git remote set-url origin https://github.com/brycehenson/my_new_project.git
 ```
 - then pull the new project into this local git
 ```
 git pull --allow-unrelated-histories
```
and then push.

If you need to update sumbodules at any point
```
git submodule update --init --recursive --remote --merge
```


## To Do
some steps for working on the project.
-[ ] unit tests
-[ ] implementation tests
-[ ] cool logo
-[ ] some figures showing schematicaly how the code operates
 


## Contributions  
This project would not have been possible without the many open source tools that it is based on. In no particular order: 

* ***James Conder*** [gaussfilt](https://au.mathworks.com/matlabcentral/fileexchange/43182-gaussfilt-t-z-sigma)
* ***Ander Biguri*** [Perceptually uniform colormaps](https://au.mathworks.com/matlabcentral/fileexchange/51986-perceptually-uniform-colormaps)
* ***Jan*** [FileTime](https://au.mathworks.com/matlabcentral/fileexchange/24671-filetime)
* ***Benjamin Kraus*** [nanconv](https://au.mathworks.com/matlabcentral/fileexchange/41961-nanconv)
* ***M. A. Hopcroft**** [allan](https://au.mathworks.com/matlabcentral/fileexchange/13246-allan)
* ***Daniel Eaton***  [sfigure](https://au.mathworks.com/matlabcentral/fileexchange/8919-smart-silent-figure)
* ***Denis Gilbert***  [M-file Header Template](https://au.mathworks.com/matlabcentral/fileexchange/4908-m-file-header-template)
* ***DrosteEffect***  [CIECAM02](https://github.com/DrosteEffect/CIECAM02)
* ***Bruno Luong*** [histcn](https://au.mathworks.com/matlabcentral/fileexchange/23897-n-dimensional-histogram)
* ***Kenneth Johnson*** [elementwise power](https://au.mathworks.com/matlabcentral/fileexchange/44574-elementwise-power)
* ***James*** [isalmost](https://au.mathworks.com/matlabcentral/fileexchange/15816-isalmost)
* ***Yair Altman*** [export_fig](https://github.com/altmany/export_fig)
* ***Christopher Thissen*** [errorbarxy](https://github.com/cthissen/errorbarxy)

