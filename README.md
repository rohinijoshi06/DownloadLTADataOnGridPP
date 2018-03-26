# DownloadLTADataOnGridPP
Stage LTA data https://lta.lofar.eu/Lofar
To download data in html.txt recieved - ./download

Things to do when downloading a different data set:
Update LTA username and password in download.sh
Stick new html.txt in this dir
Update location in file catalog where to put the files (create the dir first) in download.sh
Update number of lines in html.txt i.e. files in download.sh
Update number of parameters = number of files/3 in download
Update html file name in download if it is different
Update file name of html.txt in stripFilename as well
