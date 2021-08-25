arr_void=("#310904" "#4A0F04" "#621405" "#7B1A05" "#942006" $white)
arr_fire=("#9D0208" "#D00000" "#DC2F02" "#E85D04" "#F48C06" $black)
arr_greys=("#C0C0C0" "#E0E0E0" "#F0F0F0" "#F8F8F8" "#FFFFFF" $black)
arr_greens=("#52B69A" "#76C893" "#99D98C" "#B5E48C" "#D9ED92" $black)
arr_pastels=("#BFACFB" "#BEBCFC" "#BCCBFD" "#BBDBFE" "#BAEBFF" $black)
arr_eggplants=("#59363C" "#653E45" "#72464E" "#72464E" "#8B555E" $white)

colors=(void fire greys greens pastels eggplants)
index=$(($RANDOM % ${#colors[@]}))
color_choice=${colors[$index]}
arr="arr_$color_choice"
echo ${!arr[0]}
