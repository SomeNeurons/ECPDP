#!/bin/bash

# READ BEFORE USE 
# The script will download the individual pointcloud zip-files from the ecp webside using 'wget'.
# The zip-files are saved to a temporary location and will be extracted in the correct directory structure.
#
# Please adapt the following params:
# USER: your username from the ecp webside 
# PASS: your corresponding password
# EXTRACTION_ROOT: the directory the pointcloud data will be extracted to
# TMP_DOWNLOAD_LOCATION: the temporary location used to download the zip-files before extracting into $EXTRACTION_ROOT

USER="<your_username>"
PASS="<your_password>"

EXTRACTION_ROOT="./resources/data/"
TMP_DOWNLOAD_LOCATION="/tmp/"

# DO NOT CHANGE
BASE_URL="http://eurocity-dataset.tudelft.nl/eval/downloadFiles/downloadFile/ecpdp?file=ecpdata%2Fecpdp%2Fimg_zips%2F"

touch failed_to_download.log

while IFS=", " read -ra arr; do
  zip_file=${arr[1]}
  md5sum=${arr[0]}

  # Download zip
  wget --auth-no-challenge --user=$USER --password=$PASS --output-document=$TMP_DOWNLOAD_LOCATION$zip_file $BASE_URL$zip_file
  # Check md5sum of downloaded file
  md5_from_file=$(md5sum "$TMP_DOWNLOAD_LOCATION$zip_file" | cut -d " " -f1)
  if [[ $md5sum == $md5_from_file ]]
    then
      echo -e "\n\e[92mSUCCESS\e[39m"
    else
      echo -e "\n\e[91mFAILURE\e[39m\nMD5SUM missmatch for:\n$zip_file"
      echo $zip_file >> failed_to_download.log

      # Tidy up
      rm $TMP_DOWNLOAD_LOCATION$zip_file 
      continue
  fi

  # Extract and copy to correct location
  SPLIT=`echo $zip_file | cut -d "_" -f 3`
  CITY=`echo $zip_file | cut -d "_" -f 4 | cut -d "." -f 1`

  EXTR_DST=$EXTRACTION_ROOT"/imgs/"$SPLIT"/"$CITY
  if [[ ! -e $EXTR_DST ]]; then
    mkdir -p $EXTR_DST
  fi

  unzip $TMP_DOWNLOAD_LOCATION$zip_file -d $EXTR_DST
  rm $TMP_DOWNLOAD_LOCATION$zip_file 

echo "Done downloading. Check 'failed_to_download.log'"


done <<EOM
f434554653a5ae4b485c3e358c8ebbfb, ECPDP_img_test_amsterdam.zip
1aa786cd3403253a271ab80ca2d877ac, ECPDP_img_test_barcelona.zip
0b0c0ff122b5004188ac8cad889763a5, ECPDP_img_test_basel.zip
73183cdab8a5b50e0620544c22d09556, ECPDP_img_test_berlin.zip
447937bebbddf4167bed78ded7d6ce93, ECPDP_img_test_bologna.zip
36f5c10aaddf9f82001a15ab17d1c977, ECPDP_img_test_bratislava.zip
2bc2710945e36722df163679867b5503, ECPDP_img_test_brno.zip
c9ccbd6cfcdabe2a7390d889d58b54ef, ECPDP_img_test_budapest.zip
78249e2447d89db279c4085c2cf5484e, ECPDP_img_test_dresden.zip
c6ec4ddce7f1ced0cc6d33705a206a26, ECPDP_img_test_firenze.zip
ff11edd3aa615067c77577380345409c, ECPDP_img_test_hamburg.zip
d848bbe69b52a37e09db7cc2475079a5, ECPDP_img_test_koeln.zip
68ff787091dc80eb81ecef68796970c4, ECPDP_img_test_leipzig.zip
9151c19850e44f16946573fbf9fc208b, ECPDP_img_test_ljubljana.zip
5509c704b35a3e4cfab408552bdf7eda, ECPDP_img_test_lyon.zip
217f359fe0f84d0965eccf2ad4ed1f27, ECPDP_img_test_marseille.zip
6fdb3cb612a4cab65817c3772c06732c, ECPDP_img_test_milano.zip
0d5dd46ca59421e93497f861289c65ab, ECPDP_img_test_montpellier.zip
2a07f0905d56d5cd0440f96541fd6025, ECPDP_img_test_nuernberg.zip
ead23341bc9093b6cad27119d7ef2308, ECPDP_img_test_pisa.zip
9977ae5ddbce2c121cc63d44a4472b59, ECPDP_img_test_potsdam.zip
cb104d2d91e40e36aa2efb39fae0e8b2, ECPDP_img_test_prague.zip
e392f4bc9b6f8adf7a6eda693e282a22, ECPDP_img_test_roma.zip
33569317d2ca74c3a907bacacf996708, ECPDP_img_test_stuttgart.zip
4cdce0cd51cb3d0c0a82e24358d3b086, ECPDP_img_test_szczecin.zip
90c0caaccaa9e884a71f9dea8f52842f, ECPDP_img_test_torino.zip
b3f30e6962f8aa1d43941d3e6fd7edec, ECPDP_img_test_toulouse.zip
c1299dca71d6ced7029ceaf29f3d59b6, ECPDP_img_test_ulm.zip
e52eedda2ff6a3b415ecc2dfd398f456, ECPDP_img_test_wuerzburg.zip
92049a0dc96deaf84fdfd3b303bc1f43, ECPDP_img_test_zagreb.zip
fcc07785cc5c940f906714304c880096, ECPDP_img_test_zuerich.zip
48eed9f729d18aad3045f67f1fb3a660, ECPDP_img_train_amsterdam.zip
a983a5709609724bbb873d085db1c762, ECPDP_img_train_barcelona.zip
ff98ad86400f9572e8ca829de4de82e3, ECPDP_img_train_basel.zip
e174373ba944f9e02b9a79694e2ab14d, ECPDP_img_train_berlin.zip
68c8b7b76fc3b4188c77c2fee3905b13, ECPDP_img_train_bologna.zip
bef01235f5dfb3721d98e18f088672cb, ECPDP_img_train_bratislava.zip
622874e836642bac029a0af54834e9b3, ECPDP_img_train_brno.zip
a4e87ba81c4b5b81f28c4af44db58a4a, ECPDP_img_train_budapest.zip
4436ad0b1c78ccf21908982283c5ef3b, ECPDP_img_train_dresden.zip
8bd012f778dfe134d4b812ade26aa415, ECPDP_img_train_firenze.zip
3f31b53d17314d3a7ca5c6dc81d3f835, ECPDP_img_train_frankfurt.zip
fbf2e8b4d861674df27b551639517941, ECPDP_img_train_hamburg.zip
51c38d4656f38e7a46d8065ed1d53871, ECPDP_img_train_karlsruhe.zip
fcaf1b516e7160f59a3d965ac7c85e5b, ECPDP_img_train_koeln.zip
7bf605c0882997b12a287bf6a45e1515, ECPDP_img_train_leipzig.zip
4e2a9e5068920f951eb376f1c2e68915, ECPDP_img_train_ljubljana.zip
2680bf8019bac3e5a2357aec650f0d0c, ECPDP_img_train_lyon.zip
0b8fcc333cf34f443a71a71809d55ae2, ECPDP_img_train_marseille.zip
6434905f4610a8bc50d644ad41c05639, ECPDP_img_train_milano.zip
e8db5db1a733531fa07d8bb04bf44040, ECPDP_img_train_montpellier.zip
27fceb5a720d71cffc5dd2d920eb7c70, ECPDP_img_train_nuernberg.zip
b7328a551aa03177ec8d609a8096ae48, ECPDP_img_train_pisa.zip
1a8766412f7c49db74bc555e8d53d0a4, ECPDP_img_train_potsdam.zip
29ce5ff7d498e56ba8e25b61cff1371a, ECPDP_img_train_prague.zip
0c4a86a563bf5b2ff1faf2d53dd74097, ECPDP_img_train_roma.zip
4c2f6880339df35d37871d0ab5676835, ECPDP_img_train_strasbourg.zip
fd8b571d19969a4f337c20ebed1f0084, ECPDP_img_train_stuttgart.zip
96b86a85ff55590ddaca8e72b45e00ac, ECPDP_img_train_szczecin.zip
355483fd0b251041db6aa28f046931be, ECPDP_img_train_torino.zip
e29ca5f8a338ad857a43e0d0e12d421c, ECPDP_img_train_toulouse.zip
a4b81dc89a6bfdec4e81e173669f4ca1, ECPDP_img_train_ulm.zip
84d8428e52bb855f770adba5c868a1a5, ECPDP_img_train_wuerzburg.zip
1e20153b2173ceeb6eb493cdaecfdb96, ECPDP_img_train_zagreb.zip
c73159020586565b59dce360e1b0afe4, ECPDP_img_train_zuerich.zip
3a9aa9ea2e34f5ce4c7f670159dd71c0, ECPDP_img_val_amsterdam.zip
8a31ad0e7c5a2c0bf0fb3a07ae0a3d4c, ECPDP_img_val_barcelona.zip
66a7799a1e1d1a112cea82109f47d3dc, ECPDP_img_val_basel.zip
18ef75cf68c334dd661f510585cb1044, ECPDP_img_val_berlin.zip
86ef3aee484244712026d24cc94f428c, ECPDP_img_val_bologna.zip
c72f7829699a03c9e52d2cc8f524f904, ECPDP_img_val_bratislava.zip
455d9d1d4a35461191d1c939514c8630, ECPDP_img_val_brno.zip
824e308b4268dd592da7a711b5934363, ECPDP_img_val_budapest.zip
19938e7a9af41310c65453f2c21827fc, ECPDP_img_val_dresden.zip
827c115b66f9b8b73886b7da3ad61048, ECPDP_img_val_firenze.zip
073d5f862aa136d96a6d39b25ec5264c, ECPDP_img_val_hamburg.zip
c138d9dd751e5d0d4bf03fd9fbdba595, ECPDP_img_val_koeln.zip
10045fa100714d78fae95411abadac9c, ECPDP_img_val_leipzig.zip
d7c312ef451e8bafcc586a6638d212b2, ECPDP_img_val_ljubljana.zip
b0638df824de94147f56428ea468faf7, ECPDP_img_val_lyon.zip
c3d7fb0b40fd22ee40cea8e06ac4fb74, ECPDP_img_val_marseille.zip
368bba4059bd7a65345d968adf371bb6, ECPDP_img_val_milano.zip
5e69d2a8f657cf1eda1b26a8d7eff469, ECPDP_img_val_montpellier.zip
7e931525d21b93c32239201e15bc0d24, ECPDP_img_val_nuernberg.zip
20a1711b6b6bcfce342033b3570324d8, ECPDP_img_val_pisa.zip
e6c25241e057856c7464a3c8fcec7141, ECPDP_img_val_potsdam.zip
a73a446600b81c04e2e38b08355cbe64, ECPDP_img_val_prague.zip
a263fe9606d835c280b550ad9ea30aaf, ECPDP_img_val_roma.zip
e11f61da406b9bb98f053c475fbf9cef, ECPDP_img_val_stuttgart.zip
36c39f42291ee4a29da340bd823ee090, ECPDP_img_val_szczecin.zip
96edf8807e3ea56c5ccc842e8cb63a13, ECPDP_img_val_torino.zip
187c6c56a396cf406bbba6ca12c73308, ECPDP_img_val_toulouse.zip
51a7a0a397aa3979bd9bd4286a783300, ECPDP_img_val_ulm.zip
4b20c55bdf2367c8bda6c076e15bc5ec, ECPDP_img_val_wuerzburg.zip
2a028e7f809635882cb65f4753dabfda, ECPDP_img_val_zagreb.zip
1e1c7fbe2d64085e0856472255eee26b, ECPDP_img_val_zuerich.zip
EOM
