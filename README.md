## Background

I am ashamed. I used chatGPT to make this script.

It 

## Installation 

Here is the alias you need for CLI use.

`alias batchresize="~/.scripts/batch_square_resize/batch_square_resize.sh"`

Edit the path in the alias to whatever you decide to drop the script folder then add the alias to your `.zprofile`, `.bash_profile`, `.bashrc`, or whatever cool guy thing you use.

## Use

`batchresize source_folder dest_folder resolution quality`

source_folder = the images you want to edit (can be .)
dest_folder = where you want the new images saved
resolution = (optional) enter one number for width and height (e.g. 900). default is 600.
quality = (optional) enter quality number between 1 and 100 (default is 95).